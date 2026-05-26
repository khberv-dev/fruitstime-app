import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';

class GotoPayButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;

  const GotoPayButton({super.key, required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/bill.svg',
            colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onPrimary, BlendMode.srcIn),
          ),
          SizedBox(width: AppSpacing.md),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w900,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
