import 'package:dio/dio.dart';
import 'package:login_subject_demo_bloc_arch/core/error/exceptions.dart';
import 'package:login_subject_demo_bloc_arch/features/auth/data/datasources/remote/api/auth_api_service.dart';
import 'package:login_subject_demo_bloc_arch/features/auth/data/models/login_response_model.dart';
import 'package:login_subject_demo_bloc_arch/features/auth/data/models/user_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login({
    required String mobile,
    required String password,
  });

  Future<UserResponseModel> profile();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this.api);
  final AuthApiService api;

  @override
  Future<LoginResponseModel> login({
    required String mobile,
    required String password,
  }) async {
    try {
      final res = await api.login({"mobile": mobile, "password": password});

      if (res.code == 200 && res.data != null) {
        return res.data!;
      }
      throw ServerException(
        message: res.message ?? 'Login failed',
        statusCode: res.code,
      );
    } on DioException catch (e) {
      final msg = e.response?.data is Map ? e.response?.data['message'] : null;
      throw ServerException(
        message: msg ?? e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<UserResponseModel> profile() async {
    try {
      final res = await api.profile();

      if (res.code == 200 && res.data != null) {
        return res.data!;
      }
      throw ServerException(
        message: res.message ?? 'Failed to load profile',
        statusCode: res.code,
      );
    } on DioException catch (e) {
      final msg = e.response?.data is Map ? e.response?.data['message'] : null;
      throw ServerException(
        message: msg ?? e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
