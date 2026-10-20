# Name Generator (Flutter)

Infinite list of random names. As you scroll, more names are generated — there is no end.

## Run it

```bash
cd name_generator
flutter create .          # generates the android/ ios/ web/ platform folders (keeps lib/ and pubspec.yaml)
flutter pub get
flutter run               # pick an Android emulator, iOS simulator or Chrome
```

While it runs, edit any file in `lib/` and press `r` in the terminal for **hot reload** (state is kept) or `R` for hot restart. Try changing `_seedColor` in `lib/main.dart` and hot-reloading to see the whole theme change.

> `google_fonts` downloads fonts at runtime. Debug builds already have internet access; for an Android **release** build add
> `<uses-permission android:name="android.permission.INTERNET"/>` to `android/app/src/main/AndroidManifest.xml`.

## Structure

```
lib/
  main.dart                       App root, theme (colours + fonts, light & dark)
  models/generated_name.dart      Name model + generator (english_words / faker)
  screens/random_names_screen.dart  Infinite list — the StatefulWidget
  screens/saved_names_screen.dart   Second screen: favourites
  widgets/name_tile.dart            One row of the list
test/widget_test.dart             Unit tests for the generator
```

## How the infinite list works

`ListView.builder` has no `itemCount`, so Flutter keeps asking for the next index as you scroll. The builder only creates rows that are about to appear on screen. When it asks for an index past the end of `_suggestions`, the state generates another batch of 20 names and appends them:

```dart
itemBuilder: (context, index) {
  while (index >= _suggestions.length) {
    _suggestions.addAll(_generator.nextBatch(_source));
  }
  ...
}
```

`RandomNamesScreen` is a **StatefulWidget** because the generated list, the set of favourites and the selected source change over time; `setState` tells Flutter to rebuild.

## Guided activity vs. extensions

| Task | Where |
|---|---|
| Guided: random names in an infinite list (`english_words`) | `random_names_screen.dart`, `generated_name.dart` |
| Ext. 1 — colours, typography, layout: Material 3 seed colour, dark mode, Nunito + Playfair Display, cards, avatars with initials, animated heart | `main.dart`, `name_tile.dart` |
| Ext. 2 — more screens & widgets: Saved screen (swipe to delete + undo), counter badge, source selector (`SegmentedButton`), Shuffle button | `saved_names_screen.dart`, `random_names_screen.dart` |
| Ext. 3 — extra libraries: `faker` (realistic person names), `google_fonts` | `pubspec.yaml` |

Works on Android and iOS from the same code (plus web/desktop).
