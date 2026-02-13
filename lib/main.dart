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
import 'package:batch35_floorease/features/profile/Data/datasources/profile_remote_datasource.dart';
import 'package:batch35_floorease/features/profile/Data/repositories/profile_repository_impl.dart';
import 'package:batch35_floorease/features/profile/domain/usecases/delete_profile_image_usecase.dart';
import 'package:batch35_floorease/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:batch35_floorease/features/profile/domain/usecases/update_profile_image_usecase.dart';
import 'package:batch35_floorease/features/profile/domain/usecases/update_user_profile_usecase.dart';
import 'package:batch35_floorease/features/profile/domain/usecases/upload_profile_image_usecase.dart';
import 'package:batch35_floorease/features/profile/presentation/provider/profile_provider.dart';

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
        ChangeNotifierProvider(
          create: (_) {
            final apiClient = ApiClient();
            final remoteDataSource = ProfileRemoteDataSource(
              apiClient: apiClient,
            );
            final profileRepository = ProfileRepositoryImpl(remoteDataSource);
            final getUserProfileUseCase = GetUserProfileUseCase(
              profileRepository,
            );
            final uploadProfileImageUseCase = UploadProfileImageUseCase(
              profileRepository,
            );
            final updateProfileImageUseCase = UpdateProfileImageUseCase(
              profileRepository,
            );
            final deleteProfileImageUseCase = DeleteProfileImageUseCase(
              profileRepository,
            );
            final updateUserProfileUseCase = UpdateUserProfileUseCase(
              profileRepository,
            );

            return ProfileProvider(
              getUserProfileUseCase,
              uploadProfileImageUseCase,
              updateProfileImageUseCase,
              deleteProfileImageUseCase,
              updateUserProfileUseCase,
            );
          },
        ),
      ],
      child: const App(),
    ),
  );
}
