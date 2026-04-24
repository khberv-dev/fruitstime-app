import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/core/ui/widget/label_badge.dart';
import 'package:fruitstime/features/cart/presentation/controller/cart_provider.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:fruitstime/utils/lib.dart';
import 'package:go_router/go_router.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class PaymentSheet extends ConsumerWidget {
  const PaymentSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final cart = ref.watch(cartProvider);
    final cartPrice = ref.read(cartProvider.notifier).totalProductsPrice();

    void onCloseClick() {
      context.pop();
    }

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localization.paymentTitle,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              IconButton(onPressed: onCloseClick, icon: SvgPicture.asset('assets/icons/close.svg')),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Container(
            width: 180,
            height: 180,
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(20),
                width: 3,
              ),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(40),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: PrettyQrView.data(
                data: 'order json here with product info for POS application',
              ),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            localization.orderNumberLabel("123456"),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            localization.totalWithPrice(formatNumber(cartPrice)),
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: AppSpacing.sm),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpacing.sm,
            children: List.generate(
              cart.keys.length,
              (index) => Text(
                cart.keys.elementAt(index).title,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          Spacer(),
          LabelBadge(
            text: localization.showQrCodeMessage,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}
