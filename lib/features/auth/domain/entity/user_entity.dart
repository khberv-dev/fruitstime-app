import 'package:jiffy/jiffy.dart';

class UserEntity {
  final String id;
  final String firstName;
  final String phoneNumber;
  final Jiffy? birthday;
  final int? weight;
  final int? height;

  UserEntity({
    required this.id,
    required this.firstName,
    required this.phoneNumber,
    this.birthday,
    this.weight,
    this.height,
  });
}
