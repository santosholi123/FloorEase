import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus_platform_interface/sensors_plus_platform_interface.dart';

import 'package:batch35_floorease/features/dashboard/presentation/pages/home_screen.dart';
import 'package:batch35_floorease/features/profile/presentation/provider/profile_provider.dart';

class _MockProfileProvider extends Mock implements ProfileProvider {}

class _FakeSensorsPlatform extends SensorsPlatform {
  @override
  Stream<AccelerometerEvent> accelerometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    return const Stream.empty();
  }

  @override
  Stream<GyroscopeEvent> gyroscopeEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    return const Stream.empty();
  }

  @override
  Stream<UserAccelerometerEvent> userAccelerometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    return const Stream.empty();
  }

  @override
  Stream<MagnetometerEvent> magnetometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    return const Stream.empty();
  }
}

Future<void> pumpHome(
  WidgetTester tester, {
  required ProfileProvider profileProvider,
}) async {
  await tester.pumpWidget(
    ChangeNotifierProvider<ProfileProvider>.value(
      value: profileProvider,
      child: const MaterialApp(home: HomeScreen()),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    SensorsPlatform.instance = _FakeSensorsPlatform();
  });

  group('HomeScreen Widget Tests', () {
    late _MockProfileProvider mockProfileProvider;

    setUp(() {
      mockProfileProvider = _MockProfileProvider();
      when(() => mockProfileProvider.fetchProfile()).thenAnswer((_) async {});
      when(() => mockProfileProvider.profile).thenReturn(null);
    });

    testWidgets('1) shows app title FloorEase', (tester) async {
      await pumpHome(tester, profileProvider: mockProfileProvider);
      expect(find.text('FloorEase'), findsOneWidget);
    });

    testWidgets('2) shows subtitle Your Smart Flooring Companion', (
      tester,
    ) async {
      await pumpHome(tester, profileProvider: mockProfileProvider);
      expect(find.text('Your Smart Flooring Companion'), findsOneWidget);
    });

    testWidgets('3) shows Search TextField', (tester) async {
      await pumpHome(tester, profileProvider: mockProfileProvider);
      expect(find.widgetWithText(TextField, 'Search'), findsOneWidget);
    });

    testWidgets('4) shows filter chips', (tester) async {
      await pumpHome(tester, profileProvider: mockProfileProvider);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Homogeneous'), findsOneWidget);
      expect(find.text('Heterogeneous'), findsOneWidget);
      expect(find.text('Sports'), findsOneWidget);
    });

    testWidgets('5) shows bottom nav icons', (tester) async {
      await pumpHome(tester, profileProvider: mockProfileProvider);
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.calendar_month), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });
  });
}
