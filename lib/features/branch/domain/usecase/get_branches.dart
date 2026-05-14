import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/branch/data/repository/branch_repository.dart';
import 'package:fruitstime/features/branch/domain/entity/branch_entity.dart';

final getBranchesProvider = Provider((ref) => GetBranches(ref.read(branchRepositoryProvider)));

class GetBranches {
  final BranchRepository _repository;

  GetBranches(this._repository);

  Future<List<BranchEntity>> call() async {
    final data = await _repository.getAll();
    return data.map((e) => e.toEntity()).toList();
  }
}
