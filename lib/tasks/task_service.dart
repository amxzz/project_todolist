import 'package:supabase_flutter/supabase_flutter.dart';
import 'task.dart';

class TaskService {
  final SupabaseClient _client = Supabase.instance.client;
  final String table = 'tasks';

  Future<List<Task>> fetchTasks() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];
    final response = await _client
        .from(table)
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return (response as List)
        .map((item) => Task.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<Task?> addTask(Task task) async {
    final map = task.toMap();
    map.remove(
      'id',
    ); // Do not send id so Supabase/Postgres can auto-generate it
    final response = await _client.from(table).insert(map).select().single();
    if (response == null) return null;
    return Task.fromMap(response as Map<String, dynamic>);
  }

  Future<bool> updateTask(Task task) async {
    final response = await _client
        .from(table)
        .update(task.toMap())
        .eq('id', task.id)
        .eq('user_id', task.userId);
    return response != null;
  }

  Future<bool> deleteTask(String id) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;
    final response = await _client
        .from(table)
        .delete()
        .eq('id', id)
        .eq('user_id', userId);
    return response != null;
  }

  SupabaseClient get client => _client;
}
