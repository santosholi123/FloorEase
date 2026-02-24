import 'package:flutter_test/flutter_test.dart';
import 'package:batch35_floorease/app.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // Verify that App widget is present in widget tree
    expect(find.byType(App), findsOneWidget);
  });
}
