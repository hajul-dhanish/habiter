import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:habiter/models/habit.dart';
import 'package:habiter/models/journal_entry.dart';

class DatabaseService {
  static late Isar isar;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([
      HabitSchema,
      JournalEntrySchema,
    ], directory: dir.path);
  }

  // Habits Logic
  Future<void> addHabit(Habit habit) async {
    await isar.writeTxn(() => isar.habits.put(habit));
  }

  Future<List<Habit>> getAllHabits() async {
    return await isar.habits.where().findAll();
  }

  Future<void> updateHabit(Habit habit) async {
    await isar.writeTxn(() => isar.habits.put(habit));
  }

  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(() => isar.habits.delete(id));
  }

  // Journal Entries Logic
  Future<void> addJournalEntry(JournalEntry entry) async {
    await isar.writeTxn(() => isar.journalEntrys.put(entry));
  }

  Future<List<JournalEntry>> getAllJournalEntries() async {
    return await isar.journalEntrys.where().sortByDateDesc().findAll();
  }

  Future<void> deleteJournalEntry(int id) async {
    await isar.writeTxn(() => isar.journalEntrys.delete(id));
  }
}
