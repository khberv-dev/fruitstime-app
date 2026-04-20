import 'package:fruitstime/features/auth/domain/entity/user_entity.dart';

class UserDto {
  final String id;
  final String firstName;
  final String phoneNumber;

  UserDto({required this.id, required this.firstName, required this.phoneNumber});

  factory UserDto.parse(Map<String, dynamic> data) =>
      UserDto(id: data['id'], firstName: data['firstName'], phoneNumber: data['phoneNumber']);

  UserEntity toEntity() => UserEntity(id: id, firstName: firstName, phoneNumber: phoneNumber);
}
