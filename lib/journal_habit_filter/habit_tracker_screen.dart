import 'package:flutter/material.dart';
import 'habit_service.dart';

class HabitTrackerScreen extends StatefulWidget {
  const HabitTrackerScreen({Key? key}) : super(key: key);

  @override
  HabitTrackerScreenState createState() => HabitTrackerScreenState();
}

class HabitTrackerScreenState extends State<HabitTrackerScreen> {
  final _service = HabitService();
  bool _loading = false;
  String? _error;
  List<Map<String, dynamic>> _habits = [];
  Map<String, Map<String, dynamic>> _completions = {};

  DateTime get _weekStart {
    final now = DateTime.now();
    return now.subtract(Duration(days: now.weekday % 7));
  }

  DateTime get _weekEnd => _weekStart.add(const Duration(days: 6));

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final habits = await _service.fetchHabits();
      final completions = await _service.fetchHabitCompletions(_weekStart, _weekEnd);
      final completionMap = <String, Map<String, dynamic>>{};
      for (final c in completions) {
        final key = '${c['habit_id']}_${c['completion_date']}';
        completionMap[key] = c;
      }
      if (mounted) {
        setState(() {
          _habits = habits;
          _completions = completionMap;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load habits';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _toggleCompletion(String habitId, DateTime date) async {
    final dateString = date.toIso8601String().substring(0, 10);
    final key = '${habitId}_$dateString';
    final isCompleted = _completions.containsKey(key);

    setState(() => _loading = true);
    try {
      if (isCompleted) {
        await _service.unmarkHabitCompleted(_completions[key]!['id']);
      } else {
        await _service.markHabitCompleted(habitId, date);
      }
      await _fetchData();
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to update habit';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> showAddHabitDialog() async {
    final controller = TextEditingController();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? theme.cardColor : Colors.white,
        title: Text('Tambah Habit', style: theme.textTheme.titleLarge),
        content: TextField(
          controller: controller,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          decoration: const InputDecoration(
            hintText: 'Nama aktivitas',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Batal', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() => _loading = true);
      final success = await _service.addHabit(result);
      if (success) {
        await _fetchData();
      } else {
        if (mounted) {
          setState(() {
            _error = 'Failed to add habit';
          });
        }
      }
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _deleteHabit(String habitId) async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? theme.cardColor : Colors.white,
        title: Text('Hapus Habit', style: theme.textTheme.titleLarge),
        content: Text('Yakin ingin menghapus habit ini?', style: theme.textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Batal', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      setState(() => _loading = true);
      final success = await _service.deleteHabit(habitId);
      if (success) {
        await _fetchData();
      } else {
        if (mounted) {
          setState(() {
            _error = 'Failed to delete habit';
          });
        }
      }
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? theme.scaffoldBackgroundColor : const Color(0xFFF7F7FB),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            Expanded(
              child: _loading && _habits.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _habits.isEmpty
                      ? Center(
                          child: Text(
                            'Belum ada habit.',
                            style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(top: 24),
                          itemCount: _habits.length,
                          itemBuilder: (context, i) {
                            return _HabitCard(
                              habit: _habits[i],
                              completions: _completions,
                              weekStart: _weekStart,
                              onToggle: _toggleCompletion,
                              onDelete: () => _deleteHabit(_habits[i]['id']),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddHabitDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _HabitCard extends StatelessWidget {
  final Map<String, dynamic> habit;
  final Map<String, Map<String, dynamic>> completions;
  final DateTime weekStart;
  final Function(String, DateTime) onToggle;
  final VoidCallback onDelete;

  const _HabitCard({
    required this.habit,
    required this.completions,
    required this.weekStart,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final daysShort = ['S', 'S', 'R', 'K', 'J', 'S', 'M'];

    int completedCount = 0;
    for (int i = 0; i < 7; i++) {
      final date = weekStart.add(Duration(days: i));
      final dateString = date.toIso8601String().substring(0, 10);
      final key = '${habit['id']}_$dateString';
      if (completions.containsKey(key)) {
        completedCount++;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                habit['name'] ?? '',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$completedCount Hari',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.delete_outline, size: 22, color: isDark ? Colors.white70 : null),
                    onPressed: onDelete,
                    tooltip: 'Hapus Habit',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final date = weekStart.add(Duration(days: i));
              final dateString = date.toIso8601String().substring(0, 10);
              final key = '${habit['id']}_$dateString';
              final isCompleted = completions.containsKey(key);

              return GestureDetector(
                onTap: () => onToggle(habit['id'], date),
                child: Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isCompleted ? theme.colorScheme.primary : Colors.transparent,
                    border: Border.all(
                      color: isCompleted
                          ? theme.colorScheme.primary
                          : (isDark ? Colors.white24 : Colors.grey.shade300),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    daysShort[i],
                    style: TextStyle(
                      color: isCompleted
                          ? (isDark ? Colors.black : Colors.white)
                          : (isDark ? Colors.white70 : Colors.grey),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
