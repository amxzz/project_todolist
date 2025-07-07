import 'package:supabase_flutter/supabase_flutter.dart';

class HabitService {
  final SupabaseClient _client = Supabase.instance.client;
  final String habitTable = 'habits';
  final String completionTable = 'habit_completions';

  Future<List<Map<String, dynamic>>> fetchHabits() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];
    final response = await _client
        .from(habitTable)
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    if (response is List) {
      return List<Map<String, dynamic>>.from(response);
    }
    return [];
  }

  Future<bool> addHabit(String name, {String? color}) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;
    final response = await _client.from(habitTable).insert({
      'user_id': userId,
      'name': name,
      'color': color,
    });
    return response == null || (response is List && response.isEmpty);
  }

  Future<List<Map<String, dynamic>>> fetchHabitCompletions(
    DateTime weekStart,
    DateTime weekEnd,
  ) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];
    final response = await _client
        .from(completionTable)
        .select()
        .eq('user_id', userId)
        .gte('completion_date', weekStart.toIso8601String().substring(0, 10))
        .lte('completion_date', weekEnd.toIso8601String().substring(0, 10));
    if (response is List) {
      return List<Map<String, dynamic>>.from(response);
    }
    return [];
  }

  Future<bool> markHabitCompleted(String habitId, DateTime date) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;
    final response = await _client.from(completionTable).insert({
      'habit_id': habitId,
      'user_id': userId,
      'completion_date': date.toIso8601String().substring(0, 10),
      'completed': true,
    });
    return response == null || (response is List && response.isEmpty);
  }

  Future<bool> unmarkHabitCompleted(String completionId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;
    final response = await _client
        .from(completionTable)
        .delete()
        .eq('id', completionId)
        .eq('user_id', userId);
    return response == null || (response is List && response.isEmpty);
  }

  Future<bool> updateHabit(String id, String name, {String? color}) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;
    final response = await _client
        .from(habitTable)
        .update({'name': name, 'color': color})
        .eq('id', id)
        .eq('user_id', userId);
    return response == null || (response is List && response.isEmpty);
  }

  Future<bool> deleteHabit(String id) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;
    final response = await _client
        .from(habitTable)
        .delete()
        .eq('id', id)
        .eq('user_id', userId);
    return response == null || (response is List && response.isEmpty);
  }

  Future<bool> updateHabitDays(String id, List<int> activeDays) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;
    final response = await _client
        .from(habitTable)
        .update({'active_days': activeDays})
        .eq('id', id)
        .eq('user_id', userId);
    return response == null || (response is List && response.isEmpty);
  }
}
