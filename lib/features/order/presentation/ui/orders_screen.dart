import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/app/presentation/controller/bottom_navbar_provider.dart';
import 'package:fruitstime/features/app/presentation/ui/app_screen.dart';
import 'package:fruitstime/features/order/presentation/controller/orders_provider.dart';
import 'package:fruitstime/features/order/presentation/ui/widget/order_card.dart';
import 'package:fruitstime/features/order/presentation/ui/widget/orders_empty_state.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:fruitstime/utils/messanger.dart';
import 'package:go_router/go_router.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  static const path = '/orders';

  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ordersProvider.notifier).getMine();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final orders = ref.watch(ordersProvider);

    void onBackClick() {
      context.pop();
    }

    void onBrowseClick() {
      ref.read(bottomNavbarProvider.notifier).state = 1;
      context.go(AppScreen.path);
    }

    ref.listen(ordersProvider, (_, state) {
      if (state.error != null) {
        showErrorMessage(context, state.error!);
      }
    });

    final orderList = orders.data;
    final isEmpty = orderList != null && orderList.isEmpty;

    Widget content;
    if (orders.isLoading || orderList == null) {
      content = const Expanded(child: Center(child: CircularProgressIndicator()));
    } else if (isEmpty) {
      content = Expanded(child: OrdersEmptyState(onBrowseClick: onBrowseClick));
    } else {
      content = Expanded(
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: orderList.length,
          separatorBuilder: (_, _) => SizedBox(height: AppSpacing.md),
          itemBuilder: (_, i) => OrderCard(order: orderList[i]),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: onBackClick,
                    icon: SvgPicture.asset('assets/icons/arrow_left.svg'),
                  ),
                  SizedBox(width: AppSpacing.lg),
                  Text(
                    localization.ordersTitle,
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.md),
              content,
            ],
          ),
        ),
      ),
    );
  }
}
