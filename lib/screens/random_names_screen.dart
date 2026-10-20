import 'package:flutter/material.dart';

import '../models/generated_name.dart';
import '../widgets/name_tile.dart';
import 'saved_names_screen.dart';

/// Main screen: an infinite, lazily-built list of random names.
///
/// This is a StatefulWidget because the list of generated names, the set of
/// favourites and the selected source all change over time.
class RandomNamesScreen extends StatefulWidget {
  const RandomNamesScreen({super.key});

  @override
  State<RandomNamesScreen> createState() => _RandomNamesScreenState();
}

class _RandomNamesScreenState extends State<RandomNamesScreen> {
  final _generator = NameGenerator();
  final _suggestions = <GeneratedName>[];
  final _saved = <GeneratedName>{};
  final _scroll = ScrollController();
  NameSource _source = NameSource.wordPairs;

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _toggleSaved(GeneratedName name) {
    setState(() {
      if (!_saved.remove(name)) _saved.add(name);
    });
  }

  void _changeSource(NameSource source) {
    setState(() {
      _source = source;
      _suggestions.clear(); // start a fresh infinite list for the new source
    });
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  Future<void> _openSaved() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SavedNamesScreen(
          saved: _saved,
          onRemove: _toggleSaved,
        ),
      ),
    );
    if (mounted) setState(() {}); // refresh hearts after returning
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Name Generator'),
        actions: [
          IconButton(
            tooltip: 'Saved names',
            onPressed: _openSaved,
            icon: Badge(
              isLabelVisible: _saved.isNotEmpty,
              label: Text('${_saved.length}'),
              child: const Icon(Icons.favorite),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: SegmentedButton<NameSource>(
              segments: const [
                ButtonSegment(
                  value: NameSource.wordPairs,
                  label: Text('Word pairs'),
                  icon: Icon(Icons.text_fields),
                ),
                ButtonSegment(
                  value: NameSource.people,
                  label: Text('People'),
                  icon: Icon(Icons.person),
                ),
              ],
              selected: {_source},
              onSelectionChanged: (s) => _changeSource(s.first),
            ),
          ),
          Expanded(
            // ListView.builder only builds the rows that are on screen.
            // itemCount is null, so the list is infinite: whenever the
            // builder asks for an index we don't have yet, we generate
            // another batch of names.
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
              itemBuilder: (context, index) {
                while (index >= _suggestions.length) {
                  _suggestions.addAll(_generator.nextBatch(_source));
                }
                final name = _suggestions[index];
                return NameTile(
                  name: name,
                  index: index,
                  isSaved: _saved.contains(name),
                  onTap: () => _toggleSaved(name),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _changeSource(_source), // regenerate from scratch
        backgroundColor: scheme.tertiaryContainer,
        foregroundColor: scheme.onTertiaryContainer,
        icon: const Icon(Icons.shuffle),
        label: const Text('Shuffle'),
      ),
    );
  }
}
