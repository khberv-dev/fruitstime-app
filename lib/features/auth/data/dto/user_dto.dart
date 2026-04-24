import 'package:fruitstime/features/auth/domain/entity/user_entity.dart';
import 'package:jiffy/jiffy.dart';

class UserDto {
  final String id;
  final String firstName;
  final String phoneNumber;
  final Jiffy? birthday;
  final int? weight;
  final int? height;

  UserDto({
    required this.id,
    required this.firstName,
    required this.phoneNumber,
    this.birthday,
    this.weight,
    this.height,
  });

  factory UserDto.parse(Map<String, dynamic> data) => UserDto(
    id: data['id'],
    firstName: data['firstName'],
    phoneNumber: data['phoneNumber'],
    birthday: data['birthday'] != null ? Jiffy.parse(data['birthday']) : null,
    weight: data['weight'],
    height: data['height'],
  );

  UserEntity toEntity() => UserEntity(
    id: id,
    firstName: firstName,
    phoneNumber: phoneNumber,
    birthday: birthday,
    weight: weight,
    height: height,
  );
}
