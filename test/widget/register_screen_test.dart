import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:batch35_floorease/features/auth/domain/repositories/auth_repository.dart';
import 'package:batch35_floorease/features/auth/domain/usecases/login_usecase.dart';
import 'package:batch35_floorease/features/auth/domain/usecases/register_usecase.dart';
import 'package:batch35_floorease/features/auth/presentation/pages/create_account_screen.dart';
import 'package:batch35_floorease/features/auth/presentation/provider/auth_provider.dart';

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<void> login(String email, String password) async {}

  @override
  Future<void> register(
    String fullName,
    String email,
    String phone,
    String password,
  ) async {}

  @override
  Future<void> forgotPassword(String email) async {}

  @override
  Future<void> verifyResetOtp(String email, String otp) async {}

  @override
  Future<void> resetPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {}
}

Future<void> pumpRegister(WidgetTester tester) async {
  final authRepository = _FakeAuthRepository();
  final loginUseCase = LoginUseCase(authRepository: authRepository);
  final registerUseCase = RegisterUseCase(authRepository: authRepository);

  await tester.pumpWidget(
    ChangeNotifierProvider<AuthProvider>(
      create: (_) => AuthProvider(
        loginUseCase: loginUseCase,
        registerUseCase: registerUseCase,
      ),
      child: const MaterialApp(home: CreateAccountScreen()),
    ),
  );
}

void main() {
  group('CreateAccountScreen Widget Tests', () {
    testWidgets('1) Full Name field exists', (tester) async {
      await pumpRegister(tester);
      expect(
        find.widgetWithText(TextField, 'Enter Your Full Name'),
        findsOneWidget,
      );
    });

    testWidgets('2) Mobile Number field exists', (tester) async {
      await pumpRegister(tester);
      expect(
        find.widgetWithText(TextField, 'Enter mobile number'),
        findsOneWidget,
      );
    });

    testWidgets('3) Email field exists', (tester) async {
      await pumpRegister(tester);
      expect(
        find.widgetWithText(TextField, 'Enter your email address'),
        findsOneWidget,
      );
    });

    testWidgets('4) Password field exists', (tester) async {
      await pumpRegister(tester);
      expect(
        find.widgetWithText(TextField, 'Create a secure password'),
        findsOneWidget,
      );
    });

    testWidgets('5) Get Started button exists', (tester) async {
      await pumpRegister(tester);
      expect(find.text('Get Started'), findsOneWidget);
    });
  });
}
