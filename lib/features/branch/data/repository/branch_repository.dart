import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/api_client.dart';
import 'package:fruitstime/features/branch/data/dto/branch_dto.dart';

final branchRepositoryProvider = Provider((ref) => BranchRepository(ref.read(apiClientProvider)));

class BranchRepository {
  final Dio _client;

  BranchRepository(this._client);

  Future<List<BranchDto>> getAll() async {
    final response = await _client.get('branch');
    final data = response.data as List<dynamic>;
    return data.map((e) => BranchDto.parse(e)).toList();
  }
}
