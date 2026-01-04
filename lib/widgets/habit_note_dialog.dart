import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habiter/providers/habit_provider.dart';
import 'package:intl/intl.dart';

class HabitNoteDialog extends StatefulWidget {
  final int habitId;
  final DateTime date;
  final String initialNote;

  const HabitNoteDialog({
    super.key,
    required this.habitId,
    required this.date,
    required this.initialNote,
  });

  @override
  State<HabitNoteDialog> createState() => _HabitNoteDialogState();
}

class _HabitNoteDialogState extends State<HabitNoteDialog> {
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.initialNote);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(32),
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Habit Note',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat('MMMM dd, yyyy').format(widget.date),
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'What happened today?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<HabitProvider>(
                      context,
                      listen: false,
                    ).addDailyNote(
                      widget.habitId,
                      widget.date,
                      _noteController.text,
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Save Note'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
