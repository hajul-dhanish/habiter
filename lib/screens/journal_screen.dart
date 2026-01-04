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
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    childAspectRatio: 4,
                  ),
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
    return GestureDetector(
      onTap: () => _showNoteDetails(context, entry),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  DateFormat('MMM dd').format(entry.date),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const Spacer(),
                Icon(
                  CupertinoIcons.smiley,
                  size: 14,
                  color: _getMoodColor(entry.moodScore),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Text(
                entry.title.isNotEmpty ? entry.title : 'Untitled Entry',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  height: 1.3,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNoteDetails(BuildContext context, JournalEntry entry) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('MMMM dd, yyyy').format(entry.date),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        entry.title.isNotEmpty ? entry.title : 'Untitled Entry',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  _buildMoodIndicator(entry.moodScore),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),
              Flexible(
                child: SingleChildScrollView(
                  child: Text(
                    entry.content,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(
                      CupertinoIcons.trash,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                    onPressed: () => _confirmDelete(context, entry),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, JournalEntry entry) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Delete Note'),
        content: const Text(
          'Are you sure you want to delete this entry? This action cannot be undone.',
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Provider.of<JournalProvider>(
                context,
                listen: false,
              ).deleteEntry(entry.id);
              Navigator.pop(context); // Close confirmation
              Navigator.pop(context); // Close detail view
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Color _getMoodColor(double score) {
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.lightGreen,
      Colors.green,
    ];
    return colors[(score - 1).clamp(0, 4).toInt()];
  }

  Widget _buildMoodIndicator(double score) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getMoodColor(score).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Mood: ${score.toInt()}/5',
        style: TextStyle(
          color: _getMoodColor(score),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
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
  final _titleController = TextEditingController();
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
              controller: _titleController,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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
                        ..title = _titleController.text
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
