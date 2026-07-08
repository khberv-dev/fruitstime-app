import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/auth/data/repository/user_repository.dart';
import 'package:fruitstime/features/auth/domain/entity/status_tier_entity.dart';

final getStatusTiersProvider = Provider((ref) => GetStatusTiers(ref.read(userRepositoryProvider)));

class GetStatusTiers {
  final UserRepository _repository;

  GetStatusTiers(this._repository);

  Future<List<StatusTierEntity>> call() async {
    final data = await _repository.getStatusTiers();

    return data.map((e) => e.toEntity()).toList();
  }
}
