import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habiter/services/database_service.dart';

final statsProvider = Provider((ref) async {
  final db = DatabaseService();
  final habits = await db.getAllHabits();

  if (habits.isEmpty) {
    return const HabitStats(
      totalHabits: 0,
      completionRate: 0,
      bestStreak: 0,
      trends: [],
      weekdayPerformance: [],
    );
  }

  int totalCompletions = 0;
  int maxStreak = 0;
  final now = DateTime.now();
  final last7Days = List.generate(
    7,
    (i) =>
        DateTime(now.year, now.month, now.day).subtract(Duration(days: 6 - i)),
  );

  List<double> trends = List.filled(7, 0.0);
  List<double> weekdayPerf = List.filled(7, 0.0); // 0 = Mon, 6 = Sun

  for (var habit in habits) {
    totalCompletions += habit.completedDates.length;

    // Streaks
    if (habit.completedDates.length > maxStreak) {
      maxStreak = habit.completedDates.length;
    }

    // Trends (last 7 days)
    for (int i = 0; i < 7; i++) {
      final day = last7Days[i];
      if (habit.completedDates.any(
        (d) => d.year == day.year && d.month == day.month && d.day == day.day,
      )) {
        trends[i]++;
      }
    }

    // Weekday Performance
    for (var date in habit.completedDates) {
      weekdayPerf[date.weekday - 1]++;
    }
  }

  // Normalize trends by habit count
  trends = trends.map((t) => t / habits.length).toList();
  // Normalize weekday performance (rough estimation)
  final maxPerf = weekdayPerf.reduce((a, b) => a > b ? a : b);
  if (maxPerf > 0) {
    weekdayPerf = weekdayPerf.map((w) => w / maxPerf).toList();
  }

  double rate = totalCompletions / (habits.length * 7);

  return HabitStats(
    totalHabits: habits.length,
    completionRate: rate,
    bestStreak: maxStreak,
    trends: trends,
    weekdayPerformance: weekdayPerf,
  );
});

class HabitStats {
  final int totalHabits;
  final double completionRate;
  final int bestStreak;
  final List<double> trends;
  final List<double> weekdayPerformance;

  const HabitStats({
    required this.totalHabits,
    required this.completionRate,
    required this.bestStreak,
    required this.trends,
    required this.weekdayPerformance,
  });
}
