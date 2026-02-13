abstract class AuthRemoteDatasource {
  Future<void> login(String email, String password);
  Future<void> register(
    String fullName,
    String email,
    String phone,
    String password,
  );
}
