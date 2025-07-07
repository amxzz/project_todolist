import 'package:supabase_flutter/supabase_flutter.dart';

class JournalService {
  final SupabaseClient _client = Supabase.instance.client;
  final String table = 'journal_entries';

  Future<List<Map<String, dynamic>>> fetchJournalEntries() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];
    final response = await _client
        .from(table)
        .select()
        .eq('user_id', userId)
        .order('entry_date', ascending: false);
    if (response is List) {
      return List<Map<String, dynamic>>.from(response);
    }
    return [];
  }

  Future<bool> addJournalEntry(String content) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;
    final today = DateTime.now().toIso8601String().substring(
      0,
      10,
    ); // yyyy-MM-dd
    final response = await _client.from(table).insert({
      'user_id': userId,
      'entry_date': today,
      'content': content,
    });
    return response == null || (response is List && response.isEmpty);
  }

  Future<bool> updateJournalEntry(String id, String content) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;
    final response = await _client
        .from(table)
        .update({'content': content})
        .eq('id', id)
        .eq('user_id', userId);
    return response == null || (response is List && response.isEmpty);
  }

  Future<bool> deleteJournalEntry(String id) async {
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
