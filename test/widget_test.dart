import 'package:flutter_test/flutter_test.dart';
import 'package:name_generator/models/generated_name.dart';

void main() {
  test('generator always returns a full batch (list never runs out)', () {
    final gen = NameGenerator();
    for (final source in NameSource.values) {
      for (var i = 0; i < 5; i++) {
        expect(gen.nextBatch(source, count: 20), hasLength(20));
      }
    }
  });

  test('initials', () {
    expect(const GeneratedName('SunnyRiver', NameSource.wordPairs).initials, 'SR');
    expect(const GeneratedName('Ada Lovelace', NameSource.people).initials, 'AL');
  });
}
