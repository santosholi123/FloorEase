import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:batch35_floorease/features/auth/presentation/provider/reset_password_provider.dart';
import 'package:batch35_floorease/core/api/api_client.dart';
import 'package:batch35_floorease/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:batch35_floorease/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:batch35_floorease/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:batch35_floorease/features/auth/domain/usecases/verify_reset_otp_usecase.dart';
import 'package:batch35_floorease/features/auth/domain/usecases/reset_password_usecase.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final apiClient = ApiClient();
        final remoteDatasource = AuthRemoteDatasourceImpl(apiClient: apiClient);
        final authRepository = AuthRepositoryImpl(
          remoteDatasource: remoteDatasource,
        );

        // Create use cases following clean architecture
        final forgotPasswordUsecase = ForgotPasswordUsecase(
          repository: authRepository,
        );
        final verifyResetOtpUsecase = VerifyResetOtpUsecase(
          repository: authRepository,
        );
        final resetPasswordUsecase = ResetPasswordUsecase(
          repository: authRepository,
        );

        return ResetPasswordProvider(
          forgotPasswordUsecase: forgotPasswordUsecase,
          verifyResetOtpUsecase: verifyResetOtpUsecase,
          resetPasswordUsecase: resetPasswordUsecase,
        );
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF33CCFF), Color(0xFF33FFCC)],
            ),
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                final horizontalPadding = isWide ? 48.0 : 24.0;
                final headingSize = isWide ? 40.0 : 32.0;
                final topGap = isWide ? 100.0 : 30.0;
                final bottomInset = MediaQuery.of(context).viewInsets.bottom;

                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    24,
                    horizontalPadding,
                    24 + bottomInset,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: isWide ? 600 : double.infinity,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Back Button
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                ),
                                onPressed: () => Navigator.pop(context),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ),
                            SizedBox(height: topGap),
                            // Title
                            Text(
                              'Reset Password',
                              style: TextStyle(
                                fontSize: headingSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: isWide ? 48 : 32),
                            // Email TextField
                            Consumer<ResetPasswordProvider>(
                              builder: (context, provider, _) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(
                                      (0.95 * 255).toInt(),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextField(
                                    controller: provider.emailController,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter your email',
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 16,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            // Get OTP Button
                            Consumer<ResetPasswordProvider>(
                              builder: (context, provider, _) {
                                return Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: provider.isSendingOtp
                                          ? null
                                          : () async {
                                              await provider.sendOtp();

                                              if (!mounted) return;

                                              // Show error or success message
                                              if (provider.errorMessage !=
                                                  null) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      provider.errorMessage!,
                                                    ),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              } else if (provider
                                                      .successMessage !=
                                                  null) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      provider.successMessage!,
                                                    ),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                );
                                              }
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF0D7A6A,
                                        ),
                                        foregroundColor: Colors.white,
                                        disabledBackgroundColor: const Color(
                                          0xFF0D7A6A,
                                        ).withAlpha(128),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      child: provider.isSendingOtp
                                          ? const SizedBox(
                                              height: 18,
                                              width: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Text(
                                              'Get OTP',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ),
                                    // Resend OTP link
                                    if (provider.successMessage != null &&
                                        provider.successMessage!.contains(
                                          'OTP sent',
                                        ))
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: provider.isSendingOtp
                                              ? null
                                              : () async {
                                                  await provider.sendOtp();

                                                  if (!mounted) return;

                                                  if (provider.errorMessage !=
                                                      null) {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          provider
                                                              .errorMessage!,
                                                        ),
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                    );
                                                  } else if (provider
                                                          .successMessage !=
                                                      null) {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          provider
                                                              .successMessage!,
                                                        ),
                                                        backgroundColor:
                                                            Colors.green,
                                                      ),
                                                    );
                                                  }
                                                },
                                          child: const Text(
                                            'Resend OTP',
                                            style: TextStyle(
                                              color: Colors.black87,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            // OTP TextField
                            Consumer<ResetPasswordProvider>(
                              builder: (context, provider, _) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(
                                      (0.95 * 255).toInt(),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextField(
                                    controller: provider.otpController,
                                    decoration: const InputDecoration(
                                      hintText:
                                          'Enter the OTP sent to your email',
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 16,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    keyboardType: TextInputType.number,
                                    maxLength: 6,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            // Verify OTP Button
                            Consumer<ResetPasswordProvider>(
                              builder: (context, provider, _) {
                                return ElevatedButton(
                                  onPressed: provider.isVerifyingOtp
                                      ? null
                                      : () async {
                                          await provider.verifyOtp();

                                          if (!mounted) return;

                                          // Show error message if any
                                          if (provider.errorMessage != null) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  provider.errorMessage!,
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }

                                          // Show success message if any
                                          if (provider.successMessage != null) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  provider.successMessage!,
                                                ),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: provider.isOtpVerified
                                        ? Colors.green
                                        : const Color(0xFF0D7A6A),
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor: const Color(
                                      0xFF0D7A6A,
                                    ).withAlpha(128),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: provider.isVerifyingOtp
                                      ? const SizedBox(
                                          height: 18,
                                          width: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              provider.isOtpVerified
                                                  ? 'OTP Verified ✓'
                                                  : 'Verify OTP',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            // New Password TextField
                            Consumer<ResetPasswordProvider>(
                              builder: (context, provider, _) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(
                                      (0.95 * 255).toInt(),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextField(
                                    controller: provider.newPasswordController,
                                    obscureText: _obscureNewPassword,
                                    decoration: InputDecoration(
                                      hintText: 'Enter New Password',
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 16,
                                          ),
                                      border: InputBorder.none,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscureNewPassword
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscureNewPassword =
                                                !_obscureNewPassword;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            // Confirm Password TextField
                            Consumer<ResetPasswordProvider>(
                              builder: (context, provider, _) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(
                                      (0.95 * 255).toInt(),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextField(
                                    controller:
                                        provider.confirmPasswordController,
                                    obscureText: _obscureConfirmPassword,
                                    decoration: InputDecoration(
                                      hintText: 'Confirm new password',
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 16,
                                          ),
                                      border: InputBorder.none,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscureConfirmPassword
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscureConfirmPassword =
                                                !_obscureConfirmPassword;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 32),
                            // Reset Password Button
                            Consumer<ResetPasswordProvider>(
                              builder: (context, provider, _) {
                                return ElevatedButton(
                                  onPressed:
                                      (provider.isResetting ||
                                          !provider.isOtpVerified)
                                      ? null
                                      : () async {
                                          await provider.resetPassword();

                                          if (!mounted) return;

                                          // Show error message if any
                                          if (provider.errorMessage != null) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  provider.errorMessage!,
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }

                                          // Show success message if any
                                          if (provider.successMessage != null) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  provider.successMessage!,
                                                ),
                                                backgroundColor: Colors.green,
                                              ),
                                            );

                                            // Pop back after success
                                            Future.delayed(
                                              const Duration(seconds: 2),
                                              () {
                                                if (mounted) {
                                                  Navigator.pop(context);
                                                }
                                              },
                                            );
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0D7A6A),
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor: const Color(
                                      0xFF0D7A6A,
                                    ).withAlpha(128),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: provider.isResetting
                                      ? const SizedBox(
                                          height: 18,
                                          width: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          'Reset Password',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
