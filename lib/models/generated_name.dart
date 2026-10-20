import 'package:english_words/english_words.dart';
import 'package:faker/faker.dart';

/// Where the names come from.
enum NameSource {
  /// Guided activity: two random English words, e.g. "SunnyRiver".
  wordPairs('Word pairs'),

  /// Extension: realistic first + last names from the `faker` package.
  people('People');

  const NameSource(this.label);
  final String label;
}

/// A single generated name. Equality is by text so it can live in a Set.
class GeneratedName {
  const GeneratedName(this.text, this.source);

  final String text;
  final NameSource source;

  String get initials {
    final parts = text.split(RegExp(r'(?=[A-Z])|\s+')).where((p) => p.isNotEmpty);
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }

  @override
  bool operator ==(Object other) =>
      other is GeneratedName && other.text == text && other.source == source;

  @override
  int get hashCode => Object.hash(text, source);
}

/// Produces batches of names on demand — the list never runs out.
class NameGenerator {
  final _faker = Faker();

  List<GeneratedName> nextBatch(NameSource source, {int count = 20}) {
    switch (source) {
      case NameSource.wordPairs:
        return generateWordPairs()
            .take(count)
            .map((p) => GeneratedName(p.asPascalCase, source))
            .toList();
      case NameSource.people:
        return List.generate(
          count,
          (_) => GeneratedName(
            '${_faker.person.firstName()} ${_faker.person.lastName()}',
            source,
          ),
        );
    }
  }
}
