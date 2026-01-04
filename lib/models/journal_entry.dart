import 'package:isar/isar.dart';

part 'journal_entry.g.dart';

@collection
class JournalEntry {
  Id id = Isar.autoIncrement;

  late DateTime date;

  late String content;
  
  late String title;

  late double moodScore; // 1 to 5 or similar

  List<int> linkedHabitIds = [];
}
