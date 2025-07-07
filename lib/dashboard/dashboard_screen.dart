import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_thrive/tasks/add_task_dialog.dart';
import 'package:project_thrive/tasks/task.dart';
import 'package:project_thrive/tasks/task_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  final TaskService _taskService = TaskService();
  List<Task> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    setState(() => _isLoading = true);
    try {
      final tasks = await _taskService.fetchTasks();
      if (mounted) {
        setState(() {
          _tasks = tasks;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      // TODO: Handle error with a snackbar
    }
  }

  void showAddTaskDialog() {
    showDialog(
      context: context,
      builder:
          (dContext) => AddTaskDialog(
            onCancel: () => Navigator.of(dContext).pop(),
            onAdd: (taskData) async {
              final userId = _taskService.client.auth.currentUser?.id;
              if (userId == null) return;

              DateTime? dueDate;
              if (taskData['date'] != null && taskData['time'] != null) {
                final date = taskData['date'] as DateTime;
                final time = taskData['time'] as TimeOfDay;
                dueDate = DateTime(
                  date.year,
                  date.month,
                  date.day,
                  time.hour,
                  time.minute,
                );
              }

              final newTask = Task(
                id: '', // Let Supabase generate it
                userId: userId,
                title: taskData['title'],
                description: taskData['description'],
                dueDate: dueDate,
                completed: false,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );
              final addedTask = await _taskService.addTask(newTask);
              Navigator.of(dContext).pop();
              if (addedTask != null) {
                fetchTasks();
              }
            },
          ),
    );
  }

  void _deleteTask(String taskId) async {
    final success = await _taskService.deleteTask(taskId);
    if (success) {
      fetchTasks();
    } else {
      // Handle error
    }
  }

  void _updateTask(Task task) {
    showDialog(
      context: context,
      builder:
          (dContext) => AddTaskDialog(
            isEdit: true,
            initialTask: task,
            onCancel: () => Navigator.of(dContext).pop(),
            onAdd: (taskData) async {
              DateTime? dueDate;
              if (taskData['date'] != null && taskData['time'] != null) {
                final date = taskData['date'] as DateTime;
                final time = taskData['time'] as TimeOfDay;
                dueDate = DateTime(
                  date.year,
                  date.month,
                  date.day,
                  time.hour,
                  time.minute,
                );
              } else {
                dueDate = task.dueDate;
              }

              final updatedTask = Task(
                id: task.id,
                userId: task.userId,
                title: taskData['title'],
                description: taskData['description'],
                dueDate: dueDate,
                completed: task.completed,
                createdAt: task.createdAt,
                updatedAt: DateTime.now(),
              );
              final success = await _taskService.updateTask(updatedTask);
              Navigator.of(dContext).pop();
              if (success) {
                fetchTasks();
              }
            },
          ),
    );
  }

  void _toggleTaskCompletion(Task task) async {
    final updatedTask = Task(
      id: task.id,
      userId: task.userId,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      completed: !task.completed,
      createdAt: task.createdAt,
      updatedAt: DateTime.now(),
    );
    final success = await _taskService.updateTask(updatedTask);
    if (success) {
      fetchTasks();
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    final stats = _calculateStats();
    final upcomingTasks =
        _tasks.where((task) => !task.completed).take(5).toList();

    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
          onRefresh: fetchTasks,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Stats cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _StatCard(
                      label: 'Tugas Minggu ini',
                      value: stats['weekly'].toString(),
                    ),
                    _StatCard(
                      label: 'Hari Ini',
                      value: stats['today'].toString(),
                    ),
                    _StatCard(
                      label: 'Selesai',
                      value: stats['completed'].toString(),
                    ),
                    _StatCard(
                      label: 'Terlambat',
                      value: stats['overdue'].toString(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Progress bar
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${stats['completionRate']}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Tingkat Penyelesaian',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Upcoming tasks
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      if (Theme.of(context).brightness == Brightness.light)
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 8,
                        ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tugas Mendatang',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ).apply(color: Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                      const SizedBox(height: 12),
                      if (upcomingTasks.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Tidak ada tugas mendatang.',
                              style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                            ),
                          ),
                        )
                      else
                        ...upcomingTasks.map(
                          (task) => _UpcomingTaskItem(
                            task: task,
                            onToggle: () => _toggleTaskCompletion(task),
                            onEdit: () => _updateTask(task),
                            onDelete: () => _deleteTask(task.id),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
  }

  Map<String, int> _calculateStats() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    final weekly =
        _tasks
            .where(
              (task) =>
                  task.createdAt.isAfter(startOfWeek) &&
                  task.createdAt.isBefore(endOfWeek),
            )
            .length;
    final today =
        _tasks
            .where(
              (task) =>
                  task.dueDate != null &&
                  DateUtils.isSameDay(task.dueDate, now) &&
                  !task.completed,
            )
            .length;
    final completed = _tasks.where((task) => task.completed).length;
    final overdue =
        _tasks
            .where(
              (task) =>
                  task.dueDate != null &&
                  task.dueDate!.isBefore(now) &&
                  !task.completed,
            )
            .length;
    final totalTasks = _tasks.length;
    final completionRate =
        totalTasks > 0 ? (completed / totalTasks) * 100 : 0.0;

    return {
      'weekly': weekly,
      'today': today,
      'completed': completed,
      'overdue': overdue,
      'completionRate': completionRate.toInt(),
    };
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? theme.colorScheme.surface : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            if (!isDark)
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: isDark ? theme.colorScheme.primary : Color(0xFF0A3576),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _UpcomingTaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _UpcomingTaskItem({
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    String subtitle = '';
    if (task.dueDate != null) {
      subtitle = DateFormat('d MMM, HH:mm').format(task.dueDate!);
    }
    if (task.description != null && task.description!.isNotEmpty) {
      subtitle += (subtitle.isEmpty ? '' : ' - ') + task.description!;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Checkbox(value: task.completed, onChanged: (_) => onToggle()),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : null,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white38 : Colors.black54,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              size: 20,
              color: isDark ? Colors.white70 : null,
            ),
            onPressed: onEdit,
            tooltip: 'Edit',
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              size: 20,
              color: isDark ? Colors.white70 : null,
            ),
            onPressed: onDelete,
            tooltip: 'Delete',
          ),
        ],
      ),
    );
  }
}
