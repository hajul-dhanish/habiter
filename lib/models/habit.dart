import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

part 'habit.g.dart';

@embedded
class HabitNote {
  late DateTime date;
  late String note;
}

@collection
class Habit {
  Id id = Isar.autoIncrement;

  late String title;

  // Daily, Weekly, Interval
  late String frequency;

  // Easy, Challenging, Hard
  late String difficulty;

  late int colorValue;

  DateTime createdAt = DateTime.now();

  // List of dates when the habit was completed
  List<DateTime> completedDates = [];

  // List of daily notes for this specific habit
  List<HabitNote> dailyNotes = [];

  @ignore
  Color get color => Color(colorValue);

  set color(Color color) => colorValue = color.value;
}
