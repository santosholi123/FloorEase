import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:batch35_floorease/features/booking/presentation/pages/booking_step1_personal.dart';
import 'package:batch35_floorease/features/booking/presentation/pages/booking_step2_service.dart';
import 'package:batch35_floorease/features/booking/presentation/pages/booking_step3_notes.dart';
import 'package:batch35_floorease/features/booking/presentation/pages/booking_success_screen.dart';
import 'package:batch35_floorease/features/booking/presentation/provider/booking_provider.dart';

Future<void> pumpWithBookingProvider(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    ChangeNotifierProvider<BookingProvider>(
      create: (_) => BookingProvider(),
      child: MaterialApp(home: Scaffold(body: child)),
    ),
  );
}

void main() {
  group('Booking Widget Tests', () {
    testWidgets('1) Step1 shows Personal Info and fields', (tester) async {
      await pumpWithBookingProvider(tester, const BookingStep1Personal());
      expect(find.text('Personal Info'), findsOneWidget);
      expect(find.text('Full Name *'), findsOneWidget);
      expect(find.text('Mobile Number *'), findsOneWidget);
      expect(find.text('Email (optional)'), findsOneWidget);
      expect(find.text('City/Address *'), findsOneWidget);
    });

    testWidgets('2) Step2 shows Service Details dropdowns and fields', (
      tester,
    ) async {
      await pumpWithBookingProvider(tester, const BookingStep2Service());
      expect(find.text('Service Details'), findsOneWidget);
      expect(find.text('Service Type'), findsOneWidget);
      expect(find.text('Flooring Type'), findsOneWidget);
      expect(find.text('Area Size (sq.ft) *'), findsOneWidget);
      expect(find.text('Preferred Date *'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_month), findsOneWidget);
    });

    testWidgets('3) Step3 shows Schedule + Notes widgets', (tester) async {
      await pumpWithBookingProvider(tester, const BookingStep3Notes());
      expect(find.text('Schedule + Notes'), findsOneWidget);
      expect(find.text('Preferred Time'), findsOneWidget);
      expect(find.text('Notes (optional)'), findsOneWidget);
    });

    testWidgets('4) Step2 shows dropdown menu items when opened', (
      tester,
    ) async {
      await pumpWithBookingProvider(tester, const BookingStep2Service());

      await tester.tap(find.text('Service Type'));
      await tester.pumpAndSettle();

      expect(find.text('Installation'), findsWidgets);
      expect(find.text('Repair'), findsWidgets);
      expect(find.text('Polish'), findsWidgets);
      expect(find.text('Inspection'), findsWidgets);
    });

    testWidgets(
      '5) BookingSuccessScreen shows success text and Return button',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: BookingSuccessScreen()),
        );
        expect(find.text('Bookings'), findsOneWidget);
        expect(find.textContaining('successfully completed'), findsOneWidget);
        expect(find.text('Return Back >>'), findsOneWidget);
      },
    );
  });
}
