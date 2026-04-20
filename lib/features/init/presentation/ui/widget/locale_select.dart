import 'package:flutter/material.dart';
import 'package:fruitstime/core/model/app_locale.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/init/presentation/ui/widget/locale_select_option.dart';

class LocaleSelect extends StatelessWidget {
  final List<AppLocale> items;
  final int? current;
  final Function(int) onItemClick;

  const LocaleSelect({
    super.key,
    required this.items,
    required this.current,
    required this.onItemClick,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        items.length,
        (index) => Column(
          children: [
            GestureDetector(
              onTap: () => onItemClick(index),
              child: LocaleSelectOption(item: items[index], isCurrent: current == index),
            ),
            SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
