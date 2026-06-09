import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/order/domain/entity/order_entity.dart';
import 'package:fruitstime/features/order/domain/usecase/get_active_order.dart';

final activeOrderProvider = StreamProvider.autoDispose<OrderEntity?>((ref) {
  final controller = StreamController<OrderEntity?>();

  Future<void> fetch() async {
    try {
      controller.add(await ref.read(getActiveOrderProvider).call());
    } catch (_) {}
  }

  fetch();
  final timer = Timer.periodic(const Duration(seconds: 3), (_) => fetch());

  ref.onDispose(() {
    timer.cancel();
    controller.close();
  });

  return controller.stream;
});
