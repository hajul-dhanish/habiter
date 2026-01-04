import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habiter/models/habit.dart';
import 'package:habiter/providers/habit_provider.dart';
import 'package:intl/intl.dart';
import 'package:habiter/screens/journal_screen.dart';
import 'package:habiter/widgets/add_habit_dialog.dart';
import 'package:habiter/widgets/habit_note_dialog.dart';

class WeeklyGridTracker extends StatelessWidget {
  const WeeklyGridTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitProvider>(
      builder: (context, provider, child) {
        if (provider.habits.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.spa_outlined,
                  size: 64,
                  color: Colors.grey.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No habits yet. Start your journey by adding one!',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final now = DateTime.now();
        // Start of the week (Monday)
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final weekDays = List.generate(
          7,
          (index) => startOfWeek.add(Duration(days: index)),
        );

        return Column(
          children: [
            // Day headers
            Padding(
              padding: const EdgeInsets.only(
                left: 150.0,
              ), // Space for habit title
              child: Row(
                children: weekDays.map((day) {
                  final isToday =
                      day.year == now.year &&
                      day.month == now.month &&
                      day.day == now.day;
                  return Expanded(
                    child: Column(
                      children: [
                        Text(
                          DateFormat('E').format(day).toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isToday
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          day.day.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: isToday
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: provider.habits.length,
                itemBuilder: (context, index) {
                  final habit = provider.habits[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 150,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  habit.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              PopupMenuButton<String>(
                                icon: const Icon(
                                  Icons.more_vert,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                padding: EdgeInsets.zero,
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                    final updatedHabit =
                                        await showDialog<Habit>(
                                          context: context,
                                          builder: (context) =>
                                              AddHabitDialog(habit: habit),
                                        );
                                    if (updatedHabit != null &&
                                        context.mounted) {
                                      provider.updateHabit(updatedHabit);
                                    }
                                  } else if (value == 'delete') {
                                    provider.deleteHabit(habit.id);
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Text('Edit'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ...weekDays.map((day) {
                          final isCompleted = habit.completedDates.any(
                            (d) =>
                                d.year == day.year &&
                                d.month == day.month &&
                                d.day == day.day,
                          );

                          final note = habit.dailyNotes
                              .where(
                                (n) =>
                                    n.date.year == day.year &&
                                    n.date.month == day.month &&
                                    n.date.day == day.day,
                              )
                              .firstOrNull;

                          return Expanded(
                            child: Center(
                              child: Tooltip(
                                message: note?.note ?? 'Long press for note',
                                child: InkWell(
                                  onLongPress: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => HabitNoteDialog(
                                        habitId: habit.id,
                                        date: day,
                                        initialNote: note?.note ?? '',
                                      ),
                                    );
                                  },
                                  onTap: () async {
                                    final wasCompleted = habit.completedDates
                                        .any(
                                          (d) =>
                                              d.year == day.year &&
                                              d.month == day.month &&
                                              d.day == day.day,
                                        );

                                    await provider.toggleHabitCompletion(
                                      habit.id,
                                      day,
                                    );

                                    // If now completed and it wasn't before
                                    if (!wasCompleted && context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Completed: ${habit.title}!',
                                          ),
                                          action: SnackBarAction(
                                            label: 'Quick Note',
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    const AddJournalEntryDialog(),
                                              );
                                            },
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          width: 300,
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: isCompleted
                                          ? Colors.black
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: isCompleted
                                            ? Colors.black
                                            : note != null
                                            ? Colors.blue.withOpacity(0.5)
                                            : Colors.grey.withOpacity(0.3),
                                        width: note != null ? 2 : 1,
                                      ),
                                    ),
                                    child: isCompleted
                                        ? const Icon(
                                            Icons.check,
                                            size: 16,
                                            color: Colors.white,
                                          )
                                        : note != null
                                        ? const Icon(
                                            Icons.notes,
                                            size: 12,
                                            color: Colors.blue,
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
