import 'package:fruitstime/features/auth/data/enum/gender.dart';
import 'package:fruitstime/features/auth/domain/entity/user_entity.dart';
import 'package:jiffy/jiffy.dart';

class UserDto {
  final String id;
  final String firstName;
  final String phoneNumber;
  final Jiffy? birthday;
  final int? weight;
  final int? height;
  final Gender? gender;

  UserDto({
    required this.id,
    required this.firstName,
    required this.phoneNumber,
    this.birthday,
    this.weight,
    this.height,
    this.gender,
  });

  factory UserDto.parse(Map<String, dynamic> data) => UserDto(
    id: data['id'],
    firstName: data['firstName'],
    phoneNumber: data['phoneNumber'],
    birthday: data['birthday'] != null ? Jiffy.parse(data['birthday']) : null,
    weight: data['weight'],
    height: data['height'],
    gender: data['gender'] != null ? Gender.values.byName(data['gender']) : null,
  );

  UserEntity toEntity() => UserEntity(
    id: id,
    firstName: firstName,
    phoneNumber: phoneNumber,
    birthday: birthday,
    weight: weight,
    height: height,
    gender: gender,
  );
}
