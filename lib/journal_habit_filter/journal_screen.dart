import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'journal_service.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({Key? key}) : super(key: key);

  @override
  JournalScreenState createState() => JournalScreenState();
}

class JournalScreenState extends State<JournalScreen> {
  final _controller = TextEditingController();
  final _service = JournalService();
  bool _loading = false;
  String? _error;
  List<Map<String, dynamic>> _entries = [];

  @override
  void initState() {
    super.initState();
    _fetchEntries();
  }

  Future<void> _fetchEntries() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final entries = await _service.fetchJournalEntries();
      setState(() {
        _entries = entries;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load entries';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _addEntry() async {
    final content = _controller.text.trim();
    if (content.isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final success = await _service.addJournalEntry(content);
      if (success) {
        _controller.clear();
        await _fetchEntries();
      } else {
        setState(() {
          _error = 'Failed to save entry';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to save entry';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _editEntry(Map<String, dynamic> entry) async {
    final controller = TextEditingController(text: entry['content'] ?? '');
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? theme.cardColor : Colors.white,
        title: Text('Edit Journal', style: theme.textTheme.titleLarge),
        content: TextField(
          controller: controller,
          maxLines: 5,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          decoration: const InputDecoration(
            hintText: 'Edit your journal entry',
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
      setState(() {
        _loading = true;
      });
      final success = await _service.updateJournalEntry(entry['id'], result);
      if (success) {
        await _fetchEntries();
      } else {
        if (mounted) {
          setState(() {
            _error = 'Failed to update entry';
          });
        }
      }
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _deleteEntry(Map<String, dynamic> entry) async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? theme.cardColor : Colors.white,
        title: Text('Hapus Journal', style: theme.textTheme.titleLarge),
        content: Text('Yakin ingin menghapus entri ini?', style: theme.textTheme.bodyMedium),
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
      setState(() {
        _loading = true;
      });
      final success = await _service.deleteJournalEntry(entry['id']);
      if (success) {
        await _fetchEntries();
      } else {
        if (mounted) {
          setState(() {
            _error = 'Failed to delete entry';
          });
        }
      }
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? theme.cardColor : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hari Ini',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _controller,
                  maxLines: 5,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Apa yang terjadi hari ini? Bagaimana perasaan Anda?',
                    hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _addEntry,
                    child: _loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Simpan'),
                  ),
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (_entries.isNotEmpty)
            Text(
              'Riwayat Journal',
              style: theme.textTheme.titleLarge?.copyWith(
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          const SizedBox(height: 16),
          Expanded(
            child: _loading && _entries.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _entries.isEmpty
                    ? Center(
                        child: Text(
                          'Belum ada entri.',
                          style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _entries.length,
                        itemBuilder: (context, i) {
                          final entry = _entries[i];
                          return _JournalEntryItem(
                            entry: entry,
                            onEdit: () => _editEntry(entry),
                            onDelete: () => _deleteEntry(entry),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _JournalEntryItem extends StatelessWidget {
  final Map<String, dynamic> entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _JournalEntryItem({
    required this.entry,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final entryDate = DateTime.tryParse(entry['entry_date'] ?? '');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entry['content'] ?? '',
            style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                entryDate != null ? DateFormat.yMMMMd().format(entryDate) : '',
                style: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontSize: 12),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit_outlined, size: 20, color: isDark ? Colors.white70 : null),
                    onPressed: onEdit,
                    tooltip: 'Edit',
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline, size: 20, color: isDark ? Colors.white70 : null),
                    onPressed: onDelete,
                    tooltip: 'Delete',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
