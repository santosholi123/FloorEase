abstract class AuthRepository {
  Future<void> login(String email, String password);
  Future<void> register(
    String fullName,
    String email,
    String phone,
    String password,
  );
  Future<void> forgotPassword(String email);
  Future<void> verifyResetOtp(String email, String otp);
  Future<void> resetPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
  });
}
