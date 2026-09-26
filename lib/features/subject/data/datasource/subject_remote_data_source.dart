import 'package:dio/dio.dart';
import 'package:login_subject_demo_bloc_arch/core/error/exceptions.dart';
import 'package:login_subject_demo_bloc_arch/core/network/dio_exception_mapper.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/data/datasource/subject_api_service.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/data/model/subject_response_model.dart';

abstract class SubjectRemoteDataSource {
  Future<SubjectProgressModel> getSubjects();
}

class SubjectRemoteDataSourceImpl implements SubjectRemoteDataSource {
  final SubjectApiService apiService;

  SubjectRemoteDataSourceImpl({required this.apiService});

  @override
  Future<SubjectProgressModel> getSubjects() async {
    try {
      final res = await apiService.getTasks();
      if (res.code == 200 && res.data != null) {
        return res.data!;
      }
      throw ServerException(
        message: res.message ?? 'Failed to load subjects',
        statusCode: res.code,
      );
    } on DioException catch (e) {
      throw e.toServerException();
    }
  }
}
