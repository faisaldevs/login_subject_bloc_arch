// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserResponseModel _$UserResponseModelFromJson(Map<String, dynamic> json) =>
    UserResponseModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      mobile: json['mobile'] as String,
      email: json['email'],
      photo: json['photo'] as String?,
      birthday: json['birthday'] == null
          ? null
          : DateTime.parse(json['birthday'] as String),
      profession: json['profession'] as String?,
      education: json['education'] as String?,
      institution: json['institution'] as String?,
      address: json['address'] as String?,
      gender: (json['gender'] as num?)?.toInt(),
      hasReward: (json['has_reward'] as num?)?.toInt(),
      pendingRewardProof: (json['pending_reward_proof'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserResponseModelToJson(UserResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'mobile': instance.mobile,
      'email': instance.email,
      'photo': instance.photo,
      'birthday': instance.birthday?.toIso8601String(),
      'profession': instance.profession,
      'education': instance.education,
      'institution': instance.institution,
      'address': instance.address,
      'gender': instance.gender,
      'has_reward': instance.hasReward,
      'pending_reward_proof': instance.pendingRewardProof,
    };
