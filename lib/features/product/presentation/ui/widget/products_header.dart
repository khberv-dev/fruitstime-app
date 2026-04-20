import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';

class ProductsHeader extends StatelessWidget {
  final String catalogTitle;
  final VoidCallback onBackClick;

  const ProductsHeader({super.key, required this.catalogTitle, required this.onBackClick});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: onBackClick, icon: SvgPicture.asset('assets/icons/arrow_left.svg')),
        SizedBox(width: AppSpacing.lg),
        Text(
          catalogTitle,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}
