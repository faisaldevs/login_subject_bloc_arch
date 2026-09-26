import 'package:fpdart/fpdart.dart';
import 'package:login_subject_demo_bloc_arch/core/error/exceptions.dart';
import 'package:login_subject_demo_bloc_arch/core/error/failure.dart';
import 'package:login_subject_demo_bloc_arch/core/storage/secure_stroage.dart';
import 'package:login_subject_demo_bloc_arch/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:login_subject_demo_bloc_arch/features/auth/domain/entities/user.dart';
import 'package:login_subject_demo_bloc_arch/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required this._storage,
    required this._remoteDataSource,
  });

  final AuthRemoteDataSourceImpl _remoteDataSource;

  final SecureStroage _storage;

  @override
  Future<Either<Failure, User>> getUser() async {
    try {
      // No token means never logged in — skip a request that can only 401.
      if (await _storage.getAcessToken() == null) {
        return const Left(UnauthenticatedFailure());
      }
      final user = await _remoteDataSource.profile();
      return Right(user.toEntity());
    } on ServerException catch (e) {
      if (e.statusCode == 401) {
        await _storage.clearToken();
        return const Left(UnauthenticatedFailure('Session expired'));
      }
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> login({
    required String mobile,
    required String password,
  }) async {
    try {
      final token = await _remoteDataSource.login(
        mobile: mobile,
        password: password,
      );

      final accessToken = token.accessToken;
      final refreshToken = token.refreshToken;
      if (accessToken == null || refreshToken == null) {
        return const Left(ServerFailure('Login response missing tokens'));
      }

      await _storage.saveToken(
        acessToken: accessToken,
        refreshToken: refreshToken,
      );
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _storage.clearToken();
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
