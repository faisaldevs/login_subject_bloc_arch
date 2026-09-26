import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:login_subject_demo_bloc_arch/core/network/dio_client.dart';
import 'package:login_subject_demo_bloc_arch/core/storage/secure_stroage.dart';
import 'package:login_subject_demo_bloc_arch/features/auth/data/datasources/remote/api/auth_api_service.dart';
import 'package:login_subject_demo_bloc_arch/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:login_subject_demo_bloc_arch/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:login_subject_demo_bloc_arch/features/auth/domain/usecases/get_profile.dart';
import 'package:login_subject_demo_bloc_arch/features/auth/domain/usecases/login.dart';
import 'package:login_subject_demo_bloc_arch/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:login_subject_demo_bloc_arch/features/home/presentation/bloc/profile_bloc.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/data/datasource/subject_api_service.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/data/datasource/subject_remote_data_source.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/data/repository/subject_repository_impl.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/domain/usecase/get_subjects.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/presentation/bloc/subjects_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  _init();
  _initAuth();
  _initSubject();
}

void _init() {
  sl.registerLazySingleton(() => FlutterSecureStorage());

  sl.registerLazySingleton(() => SecureStroage(sl<FlutterSecureStorage>()));

  sl.registerLazySingleton(() => DioClient.create(sl<SecureStroage>()));
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

void _initSubject() {
  sl.registerLazySingleton(() => SubjectApiService(sl<Dio>()));
  sl.registerLazySingleton(
    () => SubjectRemoteDataSourceImpl(apiService: sl<SubjectApiService>()),
  );
  sl.registerLazySingleton(
    () => SubjectRepositoryImpl(
      remoteDataSource: sl<SubjectRemoteDataSourceImpl>(),
    ),
  );

  sl.registerLazySingleton(() => GetSubjects(sl<SubjectRepositoryImpl>()));

  sl.registerFactory(() => SubjectsBloc(sl<GetSubjects>()));
}
