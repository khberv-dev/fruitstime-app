import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/cache/cache_service_impl.dart';
import 'package:fruitstime/core/data/network/request_state.dart';
import 'package:fruitstime/features/branch/domain/entity/branch_entity.dart';
import 'package:fruitstime/features/branch/domain/usecase/get_branches.dart';

final branchesProvider = NotifierProvider<_BranchesNotifier, RequestState<List<BranchEntity>>>(
  _BranchesNotifier.new,
);

class _BranchesNotifier extends Notifier<RequestState<List<BranchEntity>>> {
  @override
  RequestState<List<BranchEntity>> build() => RequestState.idle();

  Future<void> getAll() async {
    try {
      state = RequestState.loading();
      final branches = await ref.read(getBranchesProvider).call();
      state = RequestState.data(branches);

      final cache = ref.read(cacheProvider);
      if (cache.getSelectedBranchId() == null && branches.isNotEmpty) {
        cache.setSelectedBranchId(branches.first.id);
        ref.read(selectedBranchProvider.notifier).resolve(branches);
      } else {
        ref.read(selectedBranchProvider.notifier).resolve(branches);
      }
    } on DioException catch (e) {
      state = RequestState.error(e.message);
    }
  }
}

final selectedBranchProvider = NotifierProvider<_SelectedBranchNotifier, BranchEntity?>(
  _SelectedBranchNotifier.new,
);

class _SelectedBranchNotifier extends Notifier<BranchEntity?> {
  @override
  BranchEntity? build() => null;

  void resolve(List<BranchEntity> branches) {
    final savedId = ref.read(cacheProvider).getSelectedBranchId();
    if (savedId == null) {
      state = branches.isNotEmpty ? branches.first : null;
    } else {
      state = branches.where((b) => b.id == savedId).firstOrNull ?? branches.firstOrNull;
    }
  }

  void select(BranchEntity branch) {
    ref.read(cacheProvider).setSelectedBranchId(branch.id);
    state = branch;
  }
}
