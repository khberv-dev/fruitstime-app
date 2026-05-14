import 'package:fruitstime/features/branch/domain/entity/branch_entity.dart';

class BranchDto {
  final String id;
  final int posId;
  final String name;
  final String address;
  final bool isActive;

  BranchDto({
    required this.id,
    required this.posId,
    required this.name,
    required this.address,
    required this.isActive,
  });

  factory BranchDto.parse(Map<String, dynamic> data) => BranchDto(
    id: data['id'],
    posId: data['posId'],
    name: data['name'],
    address: data['address'],
    isActive: data['isActive'],
  );

  BranchEntity toEntity() => BranchEntity(
    id: id,
    posId: posId,
    name: name,
    address: address,
    isActive: isActive,
  );
}
