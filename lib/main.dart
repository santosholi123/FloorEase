import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:batch35_floorease/app.dart';
import 'package:batch35_floorease/models/user.dart';

import 'package:batch35_floorease/core/api/api_client.dart';
import 'package:batch35_floorease/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:batch35_floorease/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:batch35_floorease/features/auth/domain/usecases/login_usecase.dart';
import 'package:batch35_floorease/features/auth/domain/usecases/register_usecase.dart';
import 'package:batch35_floorease/features/auth/presentation/provider/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive init (keep this)
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final apiClient = ApiClient();
            final remoteDatasource = AuthRemoteDatasourceImpl(
              apiClient: apiClient,
            );
            final authRepository = AuthRepositoryImpl(
              remoteDatasource: remoteDatasource,
            );
            final loginUseCase = LoginUseCase(authRepository: authRepository);
            final registerUseCase = RegisterUseCase(
              authRepository: authRepository,
            );

            return AuthProvider(
              loginUseCase: loginUseCase,
              registerUseCase: registerUseCase,
            );
          },
        ),
      ],
      child: const App(),
    ),
  );
}
