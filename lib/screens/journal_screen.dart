import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habiter/providers/journal_provider.dart';
import 'package:habiter/models/journal_entry.dart';
import 'package:intl/intl.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

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
              Text(
                'Diary & Notes',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddEntryDialog(context),
                icon: const Icon(CupertinoIcons.pencil, size: 18),
                label: const Text('Add Entry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
          Expanded(
            child: Consumer<JournalProvider>(
              builder: (context, provider, child) {
                if (provider.entries.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.doc_text,
                          size: 64,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Your thoughts belong here.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: provider.entries.length,
                  itemBuilder: (context, index) {
                    final entry = provider.entries[index];
                    return _buildJournalCard(context, entry);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalCard(BuildContext context, JournalEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                DateFormat('MMMM dd, yyyy').format(entry.date),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              _buildMoodIndicator(entry.moodScore),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            entry.content,
            style: const TextStyle(height: 1.5, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodIndicator(double score) {
    final icons = [
      CupertinoIcons.smiley,
      CupertinoIcons.smiley,
      CupertinoIcons.smiley,
      CupertinoIcons.smiley,
      CupertinoIcons.smiley,
    ];
    // Simple logic for mood colors
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.lightGreen,
      Colors.green,
    ];
    int index = (score - 1).clamp(0, 4).toInt();

    return Row(
      children: [
        Icon(icons[index], color: colors[index], size: 18),
        const SizedBox(width: 8),
        Text(
          'Mood: ${score.toInt()}/5',
          style: TextStyle(color: colors[index], fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _showAddEntryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddJournalEntryDialog(),
    );
  }
}

class AddJournalEntryDialog extends StatefulWidget {
  const AddJournalEntryDialog({super.key});

  @override
  State<AddJournalEntryDialog> createState() => _AddJournalEntryDialogState();
}

class _AddJournalEntryDialogState extends State<AddJournalEntryDialog> {
  final _contentController = TextEditingController();
  double _moodScore = 3;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(32),
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Journal Entry',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'How was your day?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Mood Score',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _moodScore,
              min: 1,
              max: 5,
              divisions: 4,
              label: _moodScore.toInt().toString(),
              onChanged: (val) => setState(() => _moodScore = val),
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
                    if (_contentController.text.isNotEmpty) {
                      final entry = JournalEntry()
                        ..date = DateTime.now()
                        ..content = _contentController.text
                        ..moodScore = _moodScore;
                      Provider.of<JournalProvider>(
                        context,
                        listen: false,
                      ).addEntry(entry);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Save Entry'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
