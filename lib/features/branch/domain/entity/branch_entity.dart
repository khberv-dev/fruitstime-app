class BranchEntity {
  final String id;
  final int posId;
  final String name;
  final String address;
  final bool isActive;
  final int? storageId;

  BranchEntity({
    required this.id,
    required this.posId,
    required this.name,
    required this.address,
    required this.isActive,
    this.storageId,
  });
}
