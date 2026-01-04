import 'package:flutter/material.dart';
import 'package:habiter/models/habit.dart';

class AddHabitDialog extends StatefulWidget {
  final Habit? habit;
  const AddHabitDialog({super.key, this.habit});

  @override
  State<AddHabitDialog> createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  late TextEditingController _titleController;
  late String _selectedFrequency;
  late String _selectedDifficulty;
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.habit?.title ?? '');
    _selectedFrequency = widget.habit?.frequency ?? 'Daily';
    _selectedDifficulty = widget.habit?.difficulty ?? 'Easy';
    _selectedColor = widget.habit?.color ?? Colors.blue;
  }

  final List<String> _frequencies = ['Daily', 'Weekly', 'Interval'];
  final List<String> _difficulties = ['Easy', 'Challenging', 'Hard'];
  final List<Color> _colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.black,
  ];

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
              widget.habit == null ? 'New Habit' : 'Edit Habit',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Habit Title',
                hintText: 'e.g. Morning Run',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Frequency',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildDropdown(_frequencies, _selectedFrequency, (val) {
              setState(() => _selectedFrequency = val!);
            }),
            const SizedBox(height: 24),
            const Text(
              'Difficulty',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildDropdown(_difficulties, _selectedDifficulty, (val) {
              setState(() => _selectedDifficulty = val!);
            }),
            const SizedBox(height: 24),
            const Text(
              'Accent Color',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: _colors.map((color) {
                final isSelected = _selectedColor == color;
                return InkWell(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withOpacity(0.5),
                                blurRadius: 8,
                              ),
                            ]
                          : null,
                    ),
                  ),
                );
              }).toList(),
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
                    if (_titleController.text.isNotEmpty) {
                      final habit = widget.habit ?? Habit();
                      habit
                        ..title = _titleController.text
                        ..frequency = _selectedFrequency
                        ..difficulty = _selectedDifficulty
                        ..color = _selectedColor;

                      if (widget.habit == null) {
                        habit.createdAt = DateTime.now();
                        habit.completedDates = [];
                        habit.dailyNotes = [];
                      }

                      Navigator.pop(context, habit);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    widget.habit == null ? 'Create Habit' : 'Update Habit',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    List<String> items,
    String value,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
