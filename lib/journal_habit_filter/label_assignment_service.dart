import 'package:supabase_flutter/supabase_flutter.dart';

class LabelAssignmentService {
  final SupabaseClient _client = Supabase.instance.client;
  final String taskLabelTable = 'task_labels';
  final String journalLabelTable = 'journal_entry_labels';

  Future<bool> assignLabelToTask(String taskId, String labelId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;
    final response = await _client.from(taskLabelTable).insert({
      'task_id': taskId,
      'label_id': labelId,
      'user_id': userId,
    });
    return response == null || (response is List && response.isEmpty);
  }

  Future<bool> unassignLabelFromTask(String taskId, String labelId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;
    final response = await _client
        .from(taskLabelTable)
        .delete()
        .eq('task_id', taskId)
        .eq('label_id', labelId)
        .eq('user_id', userId);
    return response == null || (response is List && response.isEmpty);
  }

  Future<List<Map<String, dynamic>>> getLabelsForTask(String taskId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];
    final response = await _client
        .from(taskLabelTable)
        .select('label_id, labels(*)')
        .eq('task_id', taskId)
        .eq('user_id', userId);
    if (response is List) {
      return List<Map<String, dynamic>>.from(response);
    }
    return [];
  }

  Future<bool> assignLabelToJournalEntry(
    String journalEntryId,
    String labelId,
  ) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;
    final response = await _client.from(journalLabelTable).insert({
      'journal_entry_id': journalEntryId,
      'label_id': labelId,
      'user_id': userId,
    });
    return response == null || (response is List && response.isEmpty);
  }

  Future<bool> unassignLabelFromJournalEntry(
    String journalEntryId,
    String labelId,
  ) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;
    final response = await _client
        .from(journalLabelTable)
        .delete()
        .eq('journal_entry_id', journalEntryId)
        .eq('label_id', labelId)
        .eq('user_id', userId);
    return response == null || (response is List && response.isEmpty);
  }

  Future<List<Map<String, dynamic>>> getLabelsForJournalEntry(
    String journalEntryId,
  ) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];
    final response = await _client
        .from(journalLabelTable)
        .select('label_id, labels(*)')
        .eq('journal_entry_id', journalEntryId)
        .eq('user_id', userId);
    if (response is List) {
      return List<Map<String, dynamic>>.from(response);
    }
    return [];
  }
}
