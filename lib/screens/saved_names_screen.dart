import 'package:flutter/material.dart';

import '../models/generated_name.dart';

/// Second screen (extension): the names the user has marked as favourite.
class SavedNamesScreen extends StatefulWidget {
  const SavedNamesScreen({
    super.key,
    required this.saved,
    required this.onRemove,
  });

  final Set<GeneratedName> saved;
  final ValueChanged<GeneratedName> onRemove;

  @override
  State<SavedNamesScreen> createState() => _SavedNamesScreenState();
}

class _SavedNamesScreenState extends State<SavedNamesScreen> {
  void _remove(GeneratedName name) {
    widget.onRemove(name);
    setState(() {});
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('Removed ${name.text}'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            widget.onRemove(name); // toggling again re-adds it
            setState(() {});
          },
        ),
      ));
  }

  @override
  Widget build(BuildContext context) {
    final names = widget.saved.toList()..sort((a, b) => a.text.compareTo(b.text));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Saved (${names.length})')),
      body: names.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border,
                      size: 64, color: theme.colorScheme.outline),
                  const SizedBox(height: 12),
                  Text('No saved names yet',
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text('Tap a name in the list to save it.',
                      style: theme.textTheme.bodyMedium),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: names.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final name = names[i];
                return Dismissible(
                  key: ValueKey(name),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.delete,
                        color: theme.colorScheme.onErrorContainer),
                  ),
                  onDismissed: (_) => _remove(name),
                  child: Card(
                    child: ListTile(
                      leading: Icon(name.source == NameSource.people
                          ? Icons.person
                          : Icons.text_fields),
                      title: Text(name.text,
                          style: theme.textTheme.titleMedium),
                      subtitle: Text(name.source.label),
                      trailing: IconButton(
                        tooltip: 'Remove',
                        icon: const Icon(Icons.close),
                        onPressed: () => _remove(name),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
