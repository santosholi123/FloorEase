import 'package:flutter/material.dart';
import 'package:batch35_floorease/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:batch35_floorease/features/auth/domain/usecases/verify_reset_otp_usecase.dart';
import 'package:batch35_floorease/features/auth/domain/usecases/reset_password_usecase.dart';

class ResetPasswordProvider extends ChangeNotifier {
  final ForgotPasswordUsecase forgotPasswordUsecase;
  final VerifyResetOtpUsecase verifyResetOtpUsecase;
  final ResetPasswordUsecase resetPasswordUsecase;

  // Controllers
  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // State
  bool isSendingOtp = false;
  bool isVerifyingOtp = false;
  bool isResetting = false;
  String? errorMessage;
  String? successMessage;
  bool isOtpVerified = false;
  int otpAttempts = 0;
  int rateLimitSeconds = 0;

  ResetPasswordProvider({
    required this.forgotPasswordUsecase,
    required this.verifyResetOtpUsecase,
    required this.resetPasswordUsecase,
  });

  @override
  void dispose() {
    emailController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _clearMessages() {
    errorMessage = null;
    successMessage = null;
  }

  Future<void> sendOtp() async {
    _clearMessages();

    // Validate email not empty
    if (emailController.text.trim().isEmpty) {
      errorMessage = 'Please enter a valid email';
      notifyListeners();
      return;
    }

    // Validate email contains '@'
    if (!emailController.text.trim().contains('@')) {
      errorMessage = 'Please enter a valid email';
      notifyListeners();
      return;
    }

    isSendingOtp = true;
    notifyListeners();

    try {
      await forgotPasswordUsecase.call(emailController.text.trim());

      successMessage = 'OTP sent to your email ✅';
      errorMessage = null;
      isOtpVerified = false;
      otpAttempts = 0;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      successMessage = null;
    } finally {
      isSendingOtp = false;
      notifyListeners();
    }
  }

  Future<void> verifyOtp() async {
    _clearMessages();

    // Validate OTP not empty
    if (otpController.text.trim().isEmpty) {
      errorMessage = 'Please enter the OTP';
      notifyListeners();
      return;
    }

    isVerifyingOtp = true;
    notifyListeners();

    try {
      await verifyResetOtpUsecase.call(
        emailController.text.trim(),
        otpController.text.trim(),
      );

      successMessage = 'OTP verified successfully ✅';
      errorMessage = null;
      isOtpVerified = true;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      successMessage = null;
      isOtpVerified = false;
    } finally {
      isVerifyingOtp = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword() async {
    _clearMessages();

    // Validate OTP verified
    if (!isOtpVerified) {
      errorMessage = 'Please verify OTP first';
      notifyListeners();
      return;
    }

    // Validate newPassword length >= 6
    if (newPasswordController.text.length < 6) {
      errorMessage = 'Password must be at least 6 characters';
      notifyListeners();
      return;
    }

    // Validate newPassword == confirmPassword
    if (newPasswordController.text != confirmPasswordController.text) {
      errorMessage = 'Passwords do not match';
      notifyListeners();
      return;
    }

    isResetting = true;
    notifyListeners();

    try {
      await resetPasswordUsecase.call(
        email: emailController.text.trim(),
        newPassword: newPasswordController.text,
        confirmPassword: confirmPasswordController.text,
      );

      successMessage = 'Password reset successfully ✅';
      errorMessage = null;
      _resetAllFields();
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      successMessage = null;
    } finally {
      isResetting = false;
      notifyListeners();
    }
  }

  void _resetAllFields() {
    emailController.clear();
    otpController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
    isOtpVerified = false;
    otpAttempts = 0;
  }
}
