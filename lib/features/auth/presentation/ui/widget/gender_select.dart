import 'package:flutter/material.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/auth/data/enum/gender.dart';
import 'package:fruitstime/features/auth/domain/model/gender_select_item.dart';
import 'package:fruitstime/l10n/app_localizations.dart';

class _GenderSelectOption extends StatelessWidget {
  final GenderSelectItem item;
  final bool isSelected;

  const _GenderSelectOption({super.key, required this.isSelected, required this.item});

  @override
  Widget build(BuildContext context) {
    final bgColor = isSelected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).scaffoldBackgroundColor;

    final textColor = isSelected
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onSurface;

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Text(
        item.name,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(color: textColor, fontWeight: FontWeight.w900),
      ),
    );
  }
}

class GenderSelect extends StatelessWidget {
  final Gender? selected;
  final Function(Gender) onItemClick;

  const GenderSelect({super.key, required this.selected, required this.onItemClick});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final genders = [
      GenderSelectItem(name: localization.genderMale, gender: Gender.male),
      GenderSelectItem(name: localization.genderFemale, gender: Gender.female),
    ];

    return Column(
      children: List.generate(
        genders.length,
        (index) => Column(
          children: [
            GestureDetector(
              onTap: () => onItemClick(genders[index].gender),
              child: _GenderSelectOption(
                item: genders[index],
                isSelected: genders[index].gender == selected,
              ),
            ),
            SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
