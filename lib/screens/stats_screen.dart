import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habiter/providers/stats_provider.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(statsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Stats',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 48),
          FutureBuilder<HabitStats>(
            future: statsAsync,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Error loading stats'));
              }
              final stats = snapshot.data!;
              return Column(
                children: [
                  _buildStatRow(
                    context,
                    'Total Habits',
                    stats.totalHabits.toString(),
                    Icons.layers_outlined,
                  ),
                  const SizedBox(height: 24),
                  _buildStatRow(
                    context,
                    'Completion Rate',
                    '${(stats.completionRate * 100).toInt()}%',
                    Icons.check_circle_outline,
                  ),
                  const SizedBox(height: 24),
                  _buildStatRow(
                    context,
                    'Best Streak',
                    '${stats.bestStreak} days',
                    Icons.local_fire_department_outlined,
                  ),
                  const SizedBox(height: 48),
                  _buildVisualChart(context),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 32, color: Colors.grey),
          const SizedBox(width: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVisualChart(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Consistency Heatmap',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(14, (index) {
              return Container(
                width: 12,
                height: 40 + (index % 5) * 10.0,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1 + (index / 14.0) * 0.8),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
