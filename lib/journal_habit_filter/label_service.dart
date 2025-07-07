import 'package:supabase_flutter/supabase_flutter.dart';

class LabelService {
  final SupabaseClient _client = Supabase.instance.client;
  final String table = 'labels';

  Future<List<Map<String, dynamic>>> fetchLabels() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];
    final response = await _client
        .from(table)
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    if (response is List) {
      return List<Map<String, dynamic>>.from(response);
    }
    return [];
  }

  Future<bool> addLabel(String name, {String? color}) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;
    final response = await _client.from(table).insert({
      'user_id': userId,
      'name': name,
      'color': color,
    });
    return response == null || (response is List && response.isEmpty);
  }

  Future<bool> updateLabel(String id, String name, {String? color}) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;
    final response = await _client
        .from(table)
        .update({'name': name, 'color': color})
        .eq('id', id)
        .eq('user_id', userId);
    return response == null || (response is List && response.isEmpty);
  }

  Future<bool> deleteLabel(String id) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;
    final response = await _client
        .from(table)
        .delete()
        .eq('id', id)
        .eq('user_id', userId);
    return response == null || (response is List && response.isEmpty);
  }
}
