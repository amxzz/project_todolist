import 'package:flutter/material.dart';
import 'task_service.dart';
import 'task.dart';
import 'package:intl/intl.dart';
import 'add_task_dialog.dart';
import 'task_details_screen.dart';

class UpcomingTaskScreen extends StatefulWidget {
  const UpcomingTaskScreen({Key? key}) : super(key: key);

  @override
  UpcomingTaskScreenState createState() => UpcomingTaskScreenState();
}

class UpcomingTaskScreenState extends State<UpcomingTaskScreen> {
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

  Map<String, List<Task>> _groupTasks(List<Task> tasks) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    Map<String, List<Task>> grouped = {'Minggu Ini': [], 'Bulan Ini': []};
    for (final t in tasks) {
      if (t.dueDate == null || t.completed) continue;
      final due = t.dueDate!;
      if (due.isAfter(today) && (due.isBefore(endOfWeek) || due == endOfWeek)) {
        grouped['Minggu Ini']!.add(t);
      } else if (due.isAfter(endOfWeek)) {
        grouped['Bulan Ini']!.add(t);
      }
    }
    return grouped;
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
          final updatedTask = task.copyWith(
            title: taskData['title'],
            description: taskData['description'],
            dueDate: dueDate,
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
      child: FutureBuilder<List<Task>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final grouped = _groupTasks(snapshot.data ?? []);
          if (grouped.values.every((list) => list.isEmpty)) {
            return Center(
              child: Text(
                'Tidak ada tugas mendatang.',
                style: TextStyle(color: theme.textTheme.bodyMedium?.color),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.only(top: 24),
            children: grouped.entries
                .where((entry) => entry.value.isNotEmpty)
                .map((entry) => _buildGroup(entry.key, entry.value))
                .toList(),
          );
        },
      ),
    );
  }

  Widget _buildGroup(String label, List<Task> tasks) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
        ],
      ),
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
      subtitle = DateFormat('EEEE, d MMM').format(task.dueDate!);
    }
    if (task.description != null && task.description!.isNotEmpty) {
      subtitle += (subtitle.isEmpty ? '' : ' • ') + task.description!;
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
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
