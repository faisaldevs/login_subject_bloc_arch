import 'package:dio/dio.dart';
import 'package:login_subject_demo_bloc_arch/core/error/exceptions.dart';

extension DioExceptionMapper on DioException {
  ServerException toServerException() {
    final data = response?.data;
    final serverMessage = data is Map ? data['message'] as String? : null;
    return ServerException(
      message: serverMessage ?? message ?? 'Network error',
      statusCode: response?.statusCode,
    );
  }
}
