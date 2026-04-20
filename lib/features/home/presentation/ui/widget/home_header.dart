import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruitstime/l10n/app_localizations.dart';

class HomeHeader extends StatelessWidget {
  final String? userFirstName;

  const HomeHeader({super.key, required this.userFirstName});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return SizedBox(
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localization.welcomeMessage,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                userFirstName != null ? userFirstName! : "Fruits Time",
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w900),
              ),
            ],
          ),
          IconButton(onPressed: () {}, icon: SvgPicture.asset('assets/icons/bell.svg')),
        ],
      ),
    );
  }
}
