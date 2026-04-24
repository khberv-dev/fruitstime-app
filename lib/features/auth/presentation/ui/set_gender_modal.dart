import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/auth/data/enum/gender.dart';
import 'package:fruitstime/features/auth/presentation/ui/controller/user_provider.dart';
import 'package:fruitstime/features/auth/presentation/ui/widget/gender_select.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:fruitstime/utils/messanger.dart';
import 'package:go_router/go_router.dart';

class SetGenderModal extends ConsumerStatefulWidget {
  const SetGenderModal({super.key});

  @override
  ConsumerState<SetGenderModal> createState() => _SetGenderModalState();
}

class _SetGenderModalState extends ConsumerState<SetGenderModal> {
  Gender? selectedGender;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    void onSaveClick() {
      ref.read(userProvider.notifier).updateProfile(gender: selectedGender);
    }

    void onGenderClick(Gender gender) {
      selectedGender = gender;

      setState(() {});
    }

    ref.listen(userProvider, (_, state) {
      if (state.data != null) {
        context.pop();
      }

      if (state.error != null) {
        showErrorMessage(context, state.error!);
      }
    });

    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xl),
      child: Column(
        children: [
          Text(
            localization.setGenderTitle,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w900),
          ),
          SizedBox(height: AppSpacing.lg),
          GenderSelect(selected: selectedGender, onItemClick: onGenderClick),
          SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: selectedGender != null ? onSaveClick : null,
              child: Text(localization.saveButton),
            ),
          ),
        ],
      ),
    );
  }
}
