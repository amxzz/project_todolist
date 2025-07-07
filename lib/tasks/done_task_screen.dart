import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'task_service.dart';
import 'task.dart';
import 'task_details_screen.dart';

class DoneTaskScreen extends StatefulWidget {
  const DoneTaskScreen({Key? key}) : super(key: key);

  @override
  DoneTaskScreenState createState() => DoneTaskScreenState();
}

class DoneTaskScreenState extends State<DoneTaskScreen> {
  final TaskService _taskService = TaskService();
  late Future<List<Task>> _tasksFuture;

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
    return tasks.where((t) => t.completed).toList();
  }

  void _deleteTask(String taskId) async {
    final success = await _taskService.deleteTask(taskId);
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
                'Tidak ada tugas selesai.',
                style: TextStyle(color: theme.textTheme.bodyMedium?.color),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 24),
            itemCount: tasks.length,
            itemBuilder: (context, i) {
              final task = tasks[i];
              return _DoneTaskListItem(
                task: task,
                onDelete: () => _deleteTask(task.id),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TaskDetailsScreen(task: task),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _DoneTaskListItem extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const _DoneTaskListItem({
    required this.task,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    String subtitle = 'Diselesaikan';
    if (task.updatedAt != null) {
      subtitle += ' ${DateFormat.yMMMMd().format(task.updatedAt)}';
    }
    if (task.description != null && task.description!.isNotEmpty) {
      subtitle += ' • ${task.description}';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        leading: Checkbox(
          value: true,
          onChanged: null,
          fillColor: MaterialStateProperty.all(theme.colorScheme.primary),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : null,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline, size: 22, color: isDark ? Colors.white70 : null),
          onPressed: onDelete,
          tooltip: 'Delete',
        ),
        onTap: onTap,
      ),
    );
  }
}
