import 'package:flutter/material.dart';
import 'task_service.dart';
import 'task.dart';
import '../journal_habit_filter/label_assignment_service.dart';
import '../journal_habit_filter/label_service.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskService _taskService = TaskService();
  final LabelAssignmentService _labelAssignmentService =
      LabelAssignmentService();
  late Future<List<Task>> _tasksFuture;
  Map<String, List<Map<String, dynamic>>> _taskLabels = {};

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

  Future<void> _fetchLabelsForTasks(List<Task> tasks) async {
    final Map<String, List<Map<String, dynamic>>> map = {};
    for (final task in tasks) {
      final labels = await _labelAssignmentService.getLabelsForTask(task.id);
      map[task.id] = labels;
    }
    setState(() {
      _taskLabels = map;
    });
  }

  Future<void> _showAddTaskDialog() async {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool loading = false;
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Task'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                      validator:
                          (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: descController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed:
                      loading
                          ? null
                          : () async {
                            if (!formKey.currentState!.validate()) return;
                            setState(() => loading = true);
                            try {
                              final userId =
                                  _taskService.client.auth.currentUser?.id;
                              if (userId == null)
                                throw Exception('User not logged in');
                              final now = DateTime.now();
                              final task = Task(
                                id: '', // Supabase will generate
                                userId: userId,
                                title: titleController.text.trim(),
                                description: descController.text.trim(),
                                dueDate: null,
                                completed: false,
                                createdAt: now,
                                updatedAt: now,
                              );
                              await _taskService.addTask(task);
                              Navigator.of(context).pop();
                              _refreshTasks();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to add task: $e'),
                                ),
                              );
                            } finally {
                              setState(() => loading = false);
                            }
                          },
                  child:
                      loading
                          ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showEditTaskDialog(Task task) async {
    final titleController = TextEditingController(text: task.title);
    final descController = TextEditingController(text: task.description ?? '');
    final formKey = GlobalKey<FormState>();
    bool loading = false;
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Task'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                      validator:
                          (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: descController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed:
                      loading
                          ? null
                          : () async {
                            if (!formKey.currentState!.validate()) return;
                            setState(() => loading = true);
                            try {
                              final updatedTask = Task(
                                id: task.id,
                                userId: task.userId,
                                title: titleController.text.trim(),
                                description: descController.text.trim(),
                                dueDate: task.dueDate,
                                completed: task.completed,
                                createdAt: task.createdAt,
                                updatedAt: DateTime.now(),
                              );
                              await _taskService.updateTask(updatedTask);
                              Navigator.of(context).pop();
                              _refreshTasks();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to update task: $e'),
                                ),
                              );
                            } finally {
                              setState(() => loading = false);
                            }
                          },
                  child:
                      loading
                          ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshTasks,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: FutureBuilder<List<Task>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          }
          final tasks = snapshot.data ?? [];
          if (tasks.isEmpty) {
            return const Center(child: Text('No tasks yet.'));
          }
          // Fetch labels for all tasks after tasks are loaded
          if (_taskLabels.length != tasks.length) {
            _fetchLabelsForTasks(tasks);
          }
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, i) {
              final task = tasks[i];
              final labels = _taskLabels[task.id] ?? [];
              return ListTile(
                title: Text(task.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (task.description != null &&
                        task.description!.isNotEmpty)
                      Text(task.description!),
                    if (labels.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Wrap(
                          spacing: 6,
                          children:
                              labels.map((labelMap) {
                                final label = labelMap['labels'] ?? {};
                                return Chip(
                                  label: Text(label['name'] ?? ''),
                                  backgroundColor: const Color(0xFF8BC34A),
                                  labelStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                  ],
                ),
                trailing: Icon(
                  task.completed
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: task.completed ? Colors.green : null,
                ),
                onTap: () => _showEditTaskDialog(task),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
        tooltip: 'Add Task',
      ),
    );
  }
}
