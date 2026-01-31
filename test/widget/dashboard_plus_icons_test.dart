import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:batch35_floorease/features/dashboard/presentation/pages/home_screen.dart';

void main() {
  testWidgets('Dashboard shows + icon on all three cards', (tester) async {
    // Arrange: Set a larger screen size to ensure all cards are visible
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;

    // Pump MaterialApp with HomeScreen
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    // Act: Wait for all animations to settle
    await tester.pumpAndSettle();

    // Assert: Check that all three + icon buttons are present
    expect(find.byKey(const Key('add_image_homogeneous')), findsOneWidget);
    expect(find.byKey(const Key('add_image_heterogeneous')), findsOneWidget);
    expect(find.byKey(const Key('add_image_sports')), findsOneWidget);

    // Reset for other tests
    addTearDown(tester.view.reset);
  });
}
//