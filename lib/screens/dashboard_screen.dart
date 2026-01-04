import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habiter/providers/habit_provider.dart';
import 'package:habiter/widgets/weekly_grid_tracker.dart';
import 'package:habiter/widgets/progress_card.dart';
import 'package:habiter/models/habit.dart';
import 'package:habiter/widgets/add_habit_dialog.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                  ),
                  Text(
                    'Your Dashboard',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  final newHabit = await showDialog<Habit>(
                    context: context,
                    builder: (context) => const AddHabitDialog(),
                  );
                  if (newHabit != null && context.mounted) {
                    Provider.of<HabitProvider>(
                      context,
                      listen: false,
                    ).addHabit(newHabit);
                  }
                },
                icon: const Icon(CupertinoIcons.add, size: 18),
                label: const Text('Add Habit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
          const Row(
            children: [
              Expanded(
                child: ProgressCard(
                  title: 'Weekly Progress',
                  progress: 0.72,
                  label: '72%',
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: ProgressCard(
                  title: 'Monthly Goal',
                  progress: 0.45,
                  label: '45%',
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: ProgressCard(
                  title: 'Yearly Streak',
                  progress: 0.12,
                  label: '12%',
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
          Text(
            'This Week',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const Expanded(child: WeeklyGridTracker()),
        ],
      ),
    );
  }
}
