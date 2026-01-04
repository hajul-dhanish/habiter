import 'package:flutter/material.dart';
import 'package:habiter/models/journal_entry.dart';
import 'package:habiter/services/database_service.dart';

class JournalProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<JournalEntry> _entries = [];

  List<JournalEntry> get entries => _entries;

  Future<void> fetchEntries() async {
    _entries = await _databaseService.getAllJournalEntries();
    notifyListeners();
  }

  Future<void> addEntry(JournalEntry entry) async {
    await _databaseService.addJournalEntry(entry);
    await fetchEntries();
  }

  Future<JournalEntry?> getEntryForDate(DateTime date) async {
    // Basic implementation: find entry for specific day
    try {
      return _entries.firstWhere(
        (e) =>
            e.date.year == date.year &&
            e.date.month == date.month &&
            e.date.day == date.day,
      );
    } catch (_) {
      return null;
    }
  }
}
