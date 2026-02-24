import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';

import 'package:batch35_floorease/features/auth/presentation/pages/login_screen.dart';
import 'package:batch35_floorease/features/auth/presentation/provider/auth_provider.dart';
import 'package:batch35_floorease/features/auth/domain/usecases/login_usecase.dart';
import 'package:batch35_floorease/features/auth/domain/usecases/register_usecase.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockRegisterUseCase mockRegisterUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockRegisterUseCase = MockRegisterUseCase();
  });

  group('LoginScreen Widget Tests', () {
    testWidgets('1) Email field exists', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>(
              create: (_) => AuthProvider(
                loginUseCase: mockLoginUseCase,
                registerUseCase: mockRegisterUseCase,
              ),
            ),
          ],
          child: const MaterialApp(home: LoginScreen()),
        ),
      );
      expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);
    });

    testWidgets('2) Password field exists', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>(
              create: (_) => AuthProvider(
                loginUseCase: mockLoginUseCase,
                registerUseCase: mockRegisterUseCase,
              ),
            ),
          ],
          child: const MaterialApp(home: LoginScreen()),
        ),
      );
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('3) Login button exists', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>(
              create: (_) => AuthProvider(
                loginUseCase: mockLoginUseCase,
                registerUseCase: mockRegisterUseCase,
              ),
            ),
          ],
          child: const MaterialApp(home: LoginScreen()),
        ),
      );
      expect(find.text('Log In'), findsOneWidget);
    });

    testWidgets('4) Create now text exists', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>(
              create: (_) => AuthProvider(
                loginUseCase: mockLoginUseCase,
                registerUseCase: mockRegisterUseCase,
              ),
            ),
          ],
          child: const MaterialApp(home: LoginScreen()),
        ),
      );
      expect(find.textContaining('Create'), findsOneWidget);
    });

    testWidgets('5) Login button is tappable', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>(
              create: (_) => AuthProvider(
                loginUseCase: mockLoginUseCase,
                registerUseCase: mockRegisterUseCase,
              ),
            ),
          ],
          child: const MaterialApp(home: LoginScreen()),
        ),
      );
      await tester.tap(find.text('Log In'));
      await tester.pump();
    });
  });
}
