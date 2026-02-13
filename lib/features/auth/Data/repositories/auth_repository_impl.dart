import 'package:batch35_floorease/features/auth/Data/datasources/auth_remote_datasource.dart';
import 'package:batch35_floorease/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.remoteDatasource});

  final AuthRemoteDatasource remoteDatasource;

  @override
  Future<void> login(String email, String password) {
    return remoteDatasource.login(email, password);
  }

  @override
  Future<void> register(
    String fullName,
    String email,
    String phone,
    String password,
  ) {
    return remoteDatasource.register(fullName, email, phone, password);
  }
}
