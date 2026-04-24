import 'package:birth_picker/birth_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/auth/presentation/ui/controller/user_provider.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:fruitstime/utils/messanger.dart';
import 'package:go_router/go_router.dart';
import 'package:jiffy/jiffy.dart';

class SetBirthdayModal extends ConsumerStatefulWidget {
  const SetBirthdayModal({super.key});

  @override
  ConsumerState<SetBirthdayModal> createState() => _SetBirthdayModalState();
}

class _SetBirthdayModalState extends ConsumerState<SetBirthdayModal> {
  String? birthday;

  @override
  Widget build(BuildContext context) {
    final height = 250 + MediaQuery.of(context).viewInsets.bottom;

    void onDateChange(DateTime? date) {
      if (date != null) {
        final selectedDate = Jiffy.parseFromDateTime(date);

        if (selectedDate.isBefore(Jiffy.now().subtract(years: 3))) {
          birthday = selectedDate.format(pattern: 'dd-MM-yyyy');
          setState(() {});
        }
      }
    }

    void onSaveClick() {
      ref.read(userProvider.notifier).updateProfile(birthday: birthday);
    }

    ref.listen(userProvider, (_, state) {
      if (state.data != null) {
        context.pop();
      }

      if (state.error != null) {
        showErrorMessage(context, state.error!);
      }
    });

    final localization = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xl),
      child: Column(
        children: [
          Text(
            localization.setBirthdayTitle,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w900),
          ),
          SizedBox(height: AppSpacing.lg),
          BirthPicker(autofocus: false, onChanged: onDateChange),
          SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: birthday != null ? onSaveClick : null,
              child: Text(localization.saveButton),
            ),
          ),
        ],
      ),
    );
  }
}
