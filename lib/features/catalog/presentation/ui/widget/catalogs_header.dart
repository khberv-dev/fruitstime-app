import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitstime/l10n/app_localizations.dart';

class CatalogsHeader extends StatelessWidget {
  const CatalogsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return SizedBox(
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localization.catalogTitle,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w900),
          ),
          IconButton(onPressed: () {}, icon: SvgPicture.asset('assets/icons/search.svg')),
        ],
      ),
    );
  }
}
