import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitstime/l10n/app_localizations.dart';

class OtpHeader extends StatelessWidget {
  final VoidCallback onBackClick;

  const OtpHeader({super.key, required this.onBackClick});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return SizedBox(
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(onPressed: onBackClick, icon: SvgPicture.asset('assets/icons/arrow_left.svg')),
          Text(
            localization.confirmNumberTitle,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w900),
          ),
          SizedBox(),
        ],
      ),
    );
  }
}
