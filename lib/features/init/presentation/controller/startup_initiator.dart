import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/request_state.dart';
import 'package:fruitstime/features/auth/presentation/ui/controller/user_provider.dart';
import 'package:fruitstime/features/banner/presentation/controller/banners_provider.dart';
import 'package:fruitstime/features/branch/presentation/controller/branches_provider.dart';
import 'package:fruitstime/features/catalog/presentation/controller/catalogs_provider.dart';
import 'package:fruitstime/features/loyalty/presentation/controller/loyalty_status_provider.dart';
import 'package:fruitstime/features/referral/presentation/controller/referral_status_provider.dart';
import 'package:fruitstime/features/session/domain/usecase/upsert_session.dart';
import 'package:upgrader/upgrader.dart';

final upgraderProvider = Provider<Upgrader>(
  (_) => Upgrader(debugDisplayAlways: kDebugMode, debugLogging: kDebugMode),
);

class _StartupNotifier extends Notifier<RequestState<bool>> {
  @override
  build() => RequestState.idle();

  Future<void> startup() async {
    await Future.delayed(Duration(milliseconds: 800));

    await FirebaseMessaging.instance.requestPermission();

    state = RequestState.loading();

    final upgrader = ref.read(upgraderProvider);
    final versionFuture = upgrader.initialize();

    await ref.read(bannersProvider.notifier).getAll();
    await ref.read(catalogsProvider.notifier).getAll();
    await ref.read(branchesProvider.notifier).getAll();
    await ref.read(userProvider.notifier).getMe();

    if (ref.read(userProvider).data != null) {
      await ref.read(upsertSessionProvider).call();
      await ref.read(loyaltyStatusProvider.notifier).getStatus();
      await ref.read(referralStatusProvider.notifier).getStatus();
    }

    await versionFuture;

    state = RequestState.data(true);
  }
}

final startupInitiatorProvider = NotifierProvider(_StartupNotifier.new);
