import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
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

  final int id;
  final String name;
  final String mobile;
  final String? email;
  final String? photo;
  final DateTime? birthday;
  final String? profession;
  final String? education;
  final String? institution;
  final String? address;
  final int? gender;
  final int? hasReward;
  final int? pendingRewardProof;

  @override
  List<Object?> get props => [
    id,
    name,
    mobile,
    email,
    photo,
    birthday,
    profession,
    education,
    institution,
    address,
    gender,
    hasReward,
    pendingRewardProof,
  ];
}
