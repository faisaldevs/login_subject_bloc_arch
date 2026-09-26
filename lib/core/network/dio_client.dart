import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:login_subject_demo_bloc_arch/core/network/dio.dart';
import 'package:login_subject_demo_bloc_arch/core/network/endpoints.dart';
import 'package:login_subject_demo_bloc_arch/core/storage/secure_stroage.dart';

class DioClient {
  static Dio create(SecureStroage storage) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    dio.interceptors.add(AuthInterceptor(storage));
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }

    return dio;
  }
}
