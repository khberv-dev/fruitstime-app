import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';

class ChatHeader extends StatelessWidget {
  final VoidCallback onCloseClick;

  const ChatHeader({super.key, required this.onCloseClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withAlpha(40),
              borderRadius: BorderRadius.circular(AppRadius.round),
            ),
            child: SvgPicture.asset(
              'assets/icons/doctor.svg',
              colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn),
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Fruits Time doctor",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w900),
                ),
                Text(
                  "• Online",
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.secondary),
                ),
              ],
            ),
          ),
          IconButton(onPressed: onCloseClick, icon: SvgPicture.asset('assets/icons/close.svg')),
        ],
      ),
    );
  }
}
