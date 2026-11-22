import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cs310_project/data/app_state.dart';
import 'package:cs310_project/main.dart';

void main() {
  // Language and theme are global variables in app_state.dart,
  // so reset them before every test.
  setUp(() {
    appLanguage = 'en';
    appAppearance = 'light';
  });

  /// Uses a normal phone size (like a Pixel) instead of the small
  /// default test window, so the Welcome screen fits.
  void usePhoneSize(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);
  }

  testWidgets('App starts on the welcome screen', (tester) async {
    usePhoneSize(tester);
    await tester.pumpWidget(const PetPocketApp());

    expect(find.text('PetPocket'), findsWidgets);
  });

  testWidgets('Welcome screen switches between English and Turkish',
      (tester) async {
    usePhoneSize(tester);
    await tester.pumpWidget(const PetPocketApp());

    // Starts in English
    expect(find.text('Sign in'), findsOneWidget);

    // Tap TR: texts change to Turkish
    await tester.tap(find.text('TR'));
    await tester.pump();
    expect(appLanguage, 'tr');
    expect(find.text('Giriş yap'), findsOneWidget);

    // Tap EN: back to English
    await tester.tap(find.text('EN'));
    await tester.pump();
    expect(appLanguage, 'en');
    expect(find.text('Sign in'), findsOneWidget);
  });

  testWidgets('Welcome screen switches to dark mode', (tester) async {
    usePhoneSize(tester);
    await tester.pumpWidget(const PetPocketApp());

    // Light mode shows the moon (switch to dark)
    await tester.tap(find.byIcon(Icons.dark_mode_outlined));
    await tester.pump();

    expect(appAppearance, 'dark');
    // Dark mode shows the sun (switch back to light)
    expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);
  });
}