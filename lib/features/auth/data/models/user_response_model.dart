import 'package:json_annotation/json_annotation.dart';
import 'package:login_subject_demo_bloc_arch/features/auth/domain/entities/user.dart';

part 'user_response_model.g.dart';

@JsonSerializable()
class UserResponseModel {
  final int id;
  final String name;
  final String mobile;
  final dynamic email;
  final String? photo;
  final DateTime? birthday;
  final String? profession;
  final String? education;
  final String? institution;
  final String? address;
  final int? gender;
  @JsonKey(name: 'has_reward')
  final int? hasReward;
  @JsonKey(name: 'pending_reward_proof')
  final int? pendingRewardProof;

  UserResponseModel({
    required this.id,
    required this.name,
    required this.mobile,
    this.email,
    this.photo,
    this.birthday,
    this.profession,
    this.education,
    this.institution,
    this.address,
    this.gender,
    this.hasReward,
    this.pendingRewardProof,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UserResponseModelFromJson(json);

  User toEntity() => User(
    id: id,
    name: name,
    mobile: mobile,
    address: address,
    birthday: birthday,
    education: education,
    email: email,
    gender: gender,
    hasReward: hasReward,
    institution: institution,
    pendingRewardProof: pendingRewardProof,
    photo: photo,
    profession: profession,
  );
}
