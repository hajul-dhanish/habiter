import 'package:flutter/material.dart';
import 'package:habiter/models/habit.dart';
import 'package:habiter/services/database_service.dart';

class HabitProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<Habit> _habits = [];

  List<Habit> get habits => _habits;

  Future<void> fetchHabits() async {
    _habits = await _databaseService.getAllHabits();
    notifyListeners();
  }

  Future<void> addHabit(Habit habit) async {
    await _databaseService.addHabit(habit);
    await fetchHabits();
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
