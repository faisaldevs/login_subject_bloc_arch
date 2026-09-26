import 'package:dio/dio.dart';
import 'package:login_subject_demo_bloc_arch/core/network/base_model/base_response_model.dart';
import 'package:login_subject_demo_bloc_arch/core/network/endpoints.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/data/model/subject_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'subject_api_service.g.dart';

@RestApi(baseUrl: ApiEndpoints.baseUrl)
abstract class SubjectApiService {
  factory SubjectApiService(Dio dio, {String? baseUrl}) = _SubjectApiService;

  @GET(ApiEndpoints.subjects)
  Future<BaseResponseModel<SubjectProgressModel>> getTasks();

}
