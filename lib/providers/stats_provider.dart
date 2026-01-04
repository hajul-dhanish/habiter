import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habiter/services/database_service.dart';

final statsProvider = Provider((ref) async {
  final db = DatabaseService();
  final habits = await db.getAllHabits();

  if (habits.isEmpty)
    return const HabitStats(totalHabits: 0, completionRate: 0, bestStreak: 0);

  int totalCompletions = 0;
  int maxStreak = 0;

  for (var habit in habits) {
    totalCompletions += habit.completedDates.length;
    // Simple streak calculation (placeholder for actual logic)
    if (habit.completedDates.length > maxStreak) {
      maxStreak = habit.completedDates.length;
    }
  }

  double rate = totalCompletions / (habits.length * 7); // Rough weekly rate

  return HabitStats(
    totalHabits: habits.length,
    completionRate: rate,
    bestStreak: maxStreak,
  );
});

class HabitStats {
  final int totalHabits;
  final double completionRate;
  final int bestStreak;

  const HabitStats({
    required this.totalHabits,
    required this.completionRate,
    required this.bestStreak,
  });
}
