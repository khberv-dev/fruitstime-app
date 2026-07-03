import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/notification/presentation/ui/widget/notifications_empty_state.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class NotificationsScreen extends StatelessWidget {
  static const path = '/notifications';

  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    void onBackClick() {
      context.pop();
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
                    localization.notificationsTitle,
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              const Expanded(child: NotificationsEmptyState()),
            ],
          ),
        ),
      ),
    );
  }
}
