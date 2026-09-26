import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:login_subject_demo_bloc_arch/core/network/dio.dart';
import 'package:login_subject_demo_bloc_arch/core/storage/secure_stroage.dart';
import 'package:login_subject_demo_bloc_arch/features/auth/data/datasources/remote/api/auth_api_service.dart';
import 'package:login_subject_demo_bloc_arch/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:login_subject_demo_bloc_arch/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:login_subject_demo_bloc_arch/features/auth/domain/usecases/get_profile.dart';
import 'package:login_subject_demo_bloc_arch/features/auth/domain/usecases/login.dart';
import 'package:login_subject_demo_bloc_arch/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:login_subject_demo_bloc_arch/features/home/presentation/bloc/profile_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  _init();
  _initAuth();
}

void _init() {
  sl.registerLazySingleton(
    () => Dio()..interceptors.add(AuthInterceptor(sl<SecureStroage>())),
  );
  sl.registerLazySingleton(() => FlutterSecureStorage());

  sl.registerLazySingleton(() => SecureStroage(sl<FlutterSecureStorage>()));
}

void _initAuth() {
  sl.registerLazySingleton(() => AuthApiService(sl<Dio>()));
  sl.registerLazySingleton(
    () => AuthRemoteDataSourceImpl(sl<AuthApiService>()),
  );
  sl.registerLazySingleton(
    () => AuthRepositoryImpl(
      storage: sl<SecureStroage>(),
      remoteDataSource: sl<AuthRemoteDataSourceImpl>(),
    ),
  );

  sl.registerLazySingleton(() => Login(sl<AuthRepositoryImpl>()));
  sl.registerLazySingleton(() => GetProfile(sl<AuthRepositoryImpl>()));

  sl.registerFactory(() => AuthBloc(login: sl<Login>()));
  sl.registerFactory(() => ProfileBloc(getProfile: sl<GetProfile>()));
}
