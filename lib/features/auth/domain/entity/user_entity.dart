import 'package:fruitstime/features/auth/data/enum/gender.dart';
import 'package:fruitstime/features/auth/data/enum/tier.dart';
import 'package:jiffy/jiffy.dart';

class UserEntity {
  final String id;
  final String firstName;
  final String phoneNumber;
  final Jiffy? birthday;
  final int? weight;
  final int? height;
  final Gender? gender;
  final String? referralCode;
  final String role;
  final Tier tier;
  final Jiffy createdAt;
  final Jiffy updatedAt;

  UserEntity({
    required this.id,
    required this.firstName,
    required this.phoneNumber,
    this.birthday,
    this.weight,
    this.height,
    this.gender,
    this.referralCode,
    required this.role,
    required this.tier,
    required this.createdAt,
    required this.updatedAt,
  });
}
