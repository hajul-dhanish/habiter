import 'package:flutter/material.dart';
import 'package:habiter/models/habit.dart';
import 'package:habiter/services/database_service.dart';

class HabitProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<Habit> _habits = [];

  List<Habit> get habits => _habits;

  double get weeklyProgress {
    if (_habits.isEmpty) return 0.0;
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final normalizedStart = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    );

    int completions = 0;
    for (var habit in _habits) {
      completions += habit.completedDates
          .where(
            (d) =>
                d.isAfter(normalizedStart.subtract(const Duration(seconds: 1))),
          )
          .length;
    }

    return completions / (_habits.length * 7);
  }

  double get monthlyProgress {
    if (_habits.isEmpty) return 0.0;
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    int completions = 0;
    for (var habit in _habits) {
      completions += habit.completedDates
          .where(
            (d) => d.isAfter(startOfMonth.subtract(const Duration(seconds: 1))),
          )
          .length;
    }

    return completions / (_habits.length * daysInMonth);
  }

  double get yearlyProgress {
    if (_habits.isEmpty) return 0.0;
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final isLeapYear =
        (now.year % 4 == 0) && (now.year % 100 != 0 || now.year % 400 == 0);
    final daysInYear = isLeapYear ? 366 : 365;

    int completions = 0;
    for (var habit in _habits) {
      completions += habit.completedDates
          .where(
            (d) => d.isAfter(startOfYear.subtract(const Duration(seconds: 1))),
          )
          .length;
    }

    return completions / (_habits.length * daysInYear);
  }

  Future<void> fetchHabits() async {
    _habits = await _databaseService.getAllHabits();
    notifyListeners();
  }

  Future<void> addHabit(Habit habit) async {
    await _databaseService.addHabit(habit);
    await fetchHabits();
  }

  Future<void> updateHabit(Habit habit) async {
    await _databaseService.updateHabit(habit);
    await fetchHabits();
  }

  Future<void> addDailyNote(int habitId, DateTime date, String noteText) async {
    final habitIndex = _habits.indexWhere((h) => h.id == habitId);
    if (habitIndex != -1) {
      final habit = _habits[habitIndex];
      final normalizedDate = DateTime(date.year, date.month, date.day);

      final noteIndex = habit.dailyNotes.indexWhere(
        (n) =>
            n.date.year == normalizedDate.year &&
            n.date.month == normalizedDate.month &&
            n.date.day == normalizedDate.day,
      );

      if (noteIndex != -1) {
        habit.dailyNotes[noteIndex].note = noteText;
      } else {
        habit.dailyNotes.add(
          HabitNote()
            ..date = normalizedDate
            ..note = noteText,
        );
      }

      await _databaseService.updateHabit(habit);
      notifyListeners();
    }
  }

  Future<void> toggleHabitCompletion(int habitId, DateTime date) async {
    final habitIndex = _habits.indexWhere((h) => h.id == habitId);
    if (habitIndex != -1) {
      final habit = _habits[habitIndex];

      // Normalize date to compare only day/month/year
      final normalizedDate = DateTime(date.year, date.month, date.day);

      bool alreadyCompleted = habit.completedDates.any(
        (d) =>
            d.year == normalizedDate.year &&
            d.month == normalizedDate.month &&
            d.day == normalizedDate.day,
      );

      if (alreadyCompleted) {
        habit.completedDates.removeWhere(
          (d) =>
              d.year == normalizedDate.year &&
              d.month == normalizedDate.month &&
              d.day == normalizedDate.day,
        );
      } else {
        habit.completedDates.add(normalizedDate);
      }

      await _databaseService.updateHabit(habit);
      notifyListeners();
    }
  }

  Future<void> deleteHabit(int id) async {
    await _databaseService.deleteHabit(id);
    await fetchHabits();
  }
}
