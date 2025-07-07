import 'package:flutter/material.dart';
import 'task.dart';
import 'package:intl/intl.dart';
import 'task_service.dart';
import 'add_task_dialog.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Task task;
  const TaskDetailsScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TaskService _taskService = TaskService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tugas'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final updated = await showDialog(
                context: context,
                builder:
                    (context) => AddTaskDialog(
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
                                : null;
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
                        Navigator.of(context).pop(true);
                      },
                    ),
              );
              if (updated == true) {
                Navigator.of(context).pop(true);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text('Hapus Tugas?'),
                      content: Text(
                        'Apakah Anda yakin ingin menghapus tugas ini?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('Hapus'),
                        ),
                      ],
                    ),
              );
              if (confirm == true) {
                await _taskService.deleteTask(task.id);
                Navigator.of(context).pop(true);
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(task.completed ? Icons.undo : Icons.check),
        label: Text(task.completed ? 'Tandai Belum Selesai' : 'Tandai Selesai'),
        onPressed: () async {
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
          await _taskService.updateTask(updatedTask);
          Navigator.of(context).pop(true);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (task.description != null && task.description!.isNotEmpty)
              Text(task.description!, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            if (task.dueDate != null)
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat(
                      'EEEE, d MMM yyyy – HH:mm',
                    ).format(task.dueDate!),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.check_box, size: 20),
                const SizedBox(width: 8),
                Text(task.completed ? 'Selesai' : 'Belum Selesai'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.access_time, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Dibuat: ' +
                      DateFormat('d MMM yyyy, HH:mm').format(task.createdAt),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.update, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Diubah: ' +
                      DateFormat('d MMM yyyy, HH:mm').format(task.updatedAt),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
