import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'task_service.dart';
import 'task.dart';
import 'add_task_dialog.dart';
import 'task_details_screen.dart';

class TodayTaskScreen extends StatefulWidget {
  const TodayTaskScreen({Key? key}) : super(key: key);

  @override
  TodayTaskScreenState createState() => TodayTaskScreenState();
}

class TodayTaskScreenState extends State<TodayTaskScreen> {
  final TaskService _taskService = TaskService();
  late Future<List<Task>> _tasksFuture;
  int _filterIndex = 0; // 0: Semua, 1: Belum Selesai, 2: Selesai

  @override
  void initState() {
    super.initState();
    _refreshTasks();
  }

  void _refreshTasks() {
    setState(() {
      _tasksFuture = _taskService.fetchTasks();
    });
  }

  List<Task> _filterTasks(List<Task> tasks) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    List<Task> filtered = tasks.where((t) {
      if (t.dueDate == null) return false;
      final due = DateTime(t.dueDate!.year, t.dueDate!.month, t.dueDate!.day);
      return due == today;
    }).toList();

    if (_filterIndex == 1) {
      filtered = filtered.where((t) => !t.completed).toList();
    } else if (_filterIndex == 2) {
      filtered = filtered.where((t) => t.completed).toList();
    }
    return filtered;
  }

  void showAddTaskDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        onCancel: () => Navigator.of(context).pop(),
        onAdd: (taskData) async {
          final userId = _taskService.client.auth.currentUser?.id;
          if (userId == null) return;

          final dueDate =
              taskData['date'] != null && taskData['time'] != null
                  ? DateTime(
                      taskData['date'].year,
                      taskData['date'].month,
                      taskData['date'].day,
                      taskData['time'].hour,
                      taskData['time'].minute,
                    )
                  : null;

          final task = Task(
            id: '',
            userId: userId,
            title: taskData['title'],
            description: taskData['description'],
            dueDate: dueDate,
            completed: false,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          await _taskService.addTask(task);
          Navigator.of(context).pop();
          _refreshTasks();
        },
      ),
    );
  }

  void _showEditTaskDialog(Task task) async {
    await showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        isEdit: true,
        initialTask: task,
        onCancel: () => Navigator.of(context).pop(),
        onAdd: (taskData) async {
          final dueDate =
              taskData['date'] != null && taskData['time'] != null
                  ? DateTime(
                      taskData['date'].year,
                      taskData['date'].month,
                      taskData['date'].day,
                      taskData['time'].hour,
                      taskData['time'].minute,
                    )
                  : task.dueDate;
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
          await _taskService.updateTask(updatedTask);
          Navigator.of(context).pop();
          _refreshTasks();
        },
      ),
    );
  }

  void _deleteTask(String taskId) async {
    final success = await _taskService.deleteTask(taskId);
    if (success) {
      _refreshTasks();
    }
  }

  void _toggleTaskCompletion(Task task) async {
    final updatedTask = task.copyWith(completed: !task.completed);
    final success = await _taskService.updateTask(updatedTask);
    if (success) {
      _refreshTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FilterButton(
                label: 'Semua',
                isSelected: _filterIndex == 0,
                onPressed: () => setState(() => _filterIndex = 0),
              ),
              const SizedBox(width: 12),
              _FilterButton(
                label: 'Belum Selesai',
                isSelected: _filterIndex == 1,
                onPressed: () => setState(() => _filterIndex = 1),
              ),
              const SizedBox(width: 12),
              _FilterButton(
                label: 'Selesai',
                isSelected: _filterIndex == 2,
                onPressed: () => setState(() => _filterIndex = 2),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: FutureBuilder<List<Task>>(
              future: _tasksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final tasks = _filterTasks(snapshot.data ?? []);
                if (tasks.isEmpty) {
                  return Center(
                    child: Text(
                      'Tidak ada tugas hari ini.',
                      style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                    ),
                  );
                }
                return Container(
                  decoration: BoxDecoration(
                    color: isDark ? theme.cardColor : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: tasks.length,
                    separatorBuilder: (context, index) => Divider(
                      color: isDark ? Colors.white12 : Colors.grey[200],
                      height: 1,
                    ),
                    itemBuilder: (context, i) {
                      final task = tasks[i];
                      return _TaskListItem(
                        task: task,
                        onToggle: () => _toggleTaskCompletion(task),
                        onEdit: () => _showEditTaskDialog(task),
                        onDelete: () => _deleteTask(task.id),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TaskDetailsScreen(task: task),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _FilterButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedColor = theme.colorScheme.primary;
    final unselectedColor = isDark ? theme.cardColor : Colors.grey[200];

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected
            ? (isDark ? Colors.black : Colors.white)
            : (isDark ? Colors.white : Colors.black87),
        backgroundColor: isSelected ? selectedColor : unselectedColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        elevation: 0,
      ),
      child: Text(label),
    );
  }
}

class _TaskListItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const _TaskListItem({
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    String subtitle = '';
    if (task.dueDate != null) {
      subtitle = DateFormat('HH:mm').format(task.dueDate!);
    }
    if (task.description != null && task.description!.isNotEmpty) {
      subtitle += (subtitle.isEmpty ? '' : ' • ') + task.description!;
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      leading: Checkbox(
        value: task.completed,
        onChanged: (_) => onToggle(),
      ),
      title: Text(
        task.title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : null,
        ),
      ),
      subtitle: subtitle.isNotEmpty
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit_outlined, size: 22, color: isDark ? Colors.white70 : null),
            onPressed: onEdit,
            tooltip: 'Edit',
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, size: 22, color: isDark ? Colors.white70 : null),
            onPressed: onDelete,
            tooltip: 'Delete',
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
