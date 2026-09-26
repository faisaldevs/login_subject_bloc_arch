import 'package:dio/dio.dart';
import 'package:login_subject_demo_bloc_arch/core/network/base_model/base_response_model.dart';
import 'package:login_subject_demo_bloc_arch/core/network/endpoints.dart';
import 'package:login_subject_demo_bloc_arch/features/auth/data/models/login_response_model.dart';
import 'package:login_subject_demo_bloc_arch/features/auth/data/models/user_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api_service.g.dart';

@RestApi(baseUrl: ApiEndpoints.baseUrl) //Base url here
abstract class AuthApiService {
  factory AuthApiService(Dio dio, {String? baseUrl}) = _AuthApiService;

  @POST(ApiEndpoints.login)
  Future<BaseResponseModel<LoginResponseModel>> login(
    @Body() Map<String, dynamic> body,
  );
  @GET(ApiEndpoints.profile)
  Future<BaseResponseModel<UserResponseModel>> profile();
}
