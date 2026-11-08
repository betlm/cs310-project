import 'package:flutter_test/flutter_test.dart';

import 'package:cs310_project/main.dart';

void main() {
  testWidgets('App starts on the welcome screen', (tester) async {
    await tester.pumpWidget(const PetPocketApp());
    expect(find.text('PetPocket'), findsWidgets);
  });
}