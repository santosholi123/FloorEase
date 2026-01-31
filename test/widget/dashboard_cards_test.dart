import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:batch35_floorease/features/dashboard/presentation/pages/home_screen.dart';

void main() {
  testWidgets('Dashboard shows 3 flooring category cards', (tester) async {
    // Arrange: Pump MaterialApp with HomeScreen
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    // Act: Wait for all animations to settle
    await tester.pumpAndSettle();

    // Assert: Check that all three flooring category texts are present exactly once
    expect(find.text('Homogeneous\nFlooring'), findsOneWidget);
    expect(find.text('Heterogeneous\nFlooring'), findsOneWidget);
    expect(find.text('Sports'), findsOneWidget);
  });
}
