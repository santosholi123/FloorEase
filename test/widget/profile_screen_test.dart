import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';

import 'package:batch35_floorease/features/profile/domain/entities/profile_entity.dart';
import 'package:batch35_floorease/features/profile/presentation/pages/profile_screen.dart';
import 'package:batch35_floorease/features/profile/presentation/provider/profile_provider.dart';
import 'package:batch35_floorease/features/auth/presentation/provider/auth_provider.dart';

class MockProfileProvider extends Mock implements ProfileProvider {}

class MockAuthProvider extends Mock implements AuthProvider {}

class _FakeBuildContext extends Fake implements BuildContext {}

Future<void> pumpProfile(
  WidgetTester tester, {
  required ProfileProvider profileProvider,
  required AuthProvider authProvider,
}) async {
  await mockNetworkImagesFor(() async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ProfileProvider>.value(value: profileProvider),
          ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ],
        child: const MaterialApp(home: ProfileScreen()),
      ),
    );
    await tester.pump();
  });
}

void main() {
  late MockProfileProvider mockProfileProvider;
  late MockAuthProvider mockAuthProvider;

  setUpAll(() {
    registerFallbackValue(_FakeBuildContext());
  });

  setUp(() {
    mockProfileProvider = MockProfileProvider();
    mockAuthProvider = MockAuthProvider();

    when(() => mockProfileProvider.fetchProfile()).thenAnswer((_) async {});
    when(() => mockProfileProvider.isLoading).thenReturn(false);
    when(() => mockProfileProvider.error).thenReturn(null);
    when(() => mockProfileProvider.actionMessage).thenReturn(null);
    when(() => mockProfileProvider.profile).thenReturn(
      const ProfileEntity(
        id: '1',
        fullName: 'Test User',
        email: 'test@gmail.com',
        phone: '9800000000',
        profileImage: '',
      ),
    );

    when(() => mockAuthProvider.logout(any())).thenAnswer((_) async {});
  });

  group('ProfileScreen Widget Tests', () {
    testWidgets('1) shows back button + Update Profile + Log Out', (
      tester,
    ) async {
      await pumpProfile(
        tester,
        profileProvider: mockProfileProvider,
        authProvider: mockAuthProvider,
      );

      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
      expect(find.text('Update Profile'), findsOneWidget);
      expect(find.text('Log Out'), findsOneWidget);
    });

    testWidgets('2) shows fields labels Name Email Mobile Number Password', (
      tester,
    ) async {
      await pumpProfile(
        tester,
        profileProvider: mockProfileProvider,
        authProvider: mockAuthProvider,
      );

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Mobile Number'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('3) initializes controllers from profile and shows values', (
      tester,
    ) async {
      await pumpProfile(
        tester,
        profileProvider: mockProfileProvider,
        authProvider: mockAuthProvider,
      );

      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('test@gmail.com'), findsOneWidget);
      expect(find.text('9800000000'), findsOneWidget);
    });

    testWidgets('4) password visibility toggle changes icon', (tester) async {
      await pumpProfile(
        tester,
        profileProvider: mockProfileProvider,
        authProvider: mockAuthProvider,
      );

      expect(find.byIcon(Icons.visibility_off_rounded), findsOneWidget);
      await tester.tap(find.byIcon(Icons.visibility_off_rounded));
      await tester.pump();
      expect(find.byIcon(Icons.visibility_rounded), findsOneWidget);
    });

    testWidgets(
      '5) shows loading indicator when isLoading true and profile null',
      (tester) async {
        when(() => mockProfileProvider.isLoading).thenReturn(true);
        when(() => mockProfileProvider.profile).thenReturn(null);

        await pumpProfile(
          tester,
          profileProvider: mockProfileProvider,
          authProvider: mockAuthProvider,
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      '6) shows error + Retry button when error not null and profile null',
      (tester) async {
        when(() => mockProfileProvider.isLoading).thenReturn(false);
        when(() => mockProfileProvider.profile).thenReturn(null);
        when(() => mockProfileProvider.error).thenReturn('Failed');

        await pumpProfile(
          tester,
          profileProvider: mockProfileProvider,
          authProvider: mockAuthProvider,
        );

        expect(find.text('Retry'), findsOneWidget);
      },
    );
  });
}
