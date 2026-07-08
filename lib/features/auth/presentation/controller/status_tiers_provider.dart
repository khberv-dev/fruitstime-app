import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/auth/domain/usecase/get_status_tiers.dart';

final statusTiersProvider = FutureProvider((ref) => ref.read(getStatusTiersProvider).call());
