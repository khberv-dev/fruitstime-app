import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/auth/presentation/ui/controller/user_provider.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:fruitstime/utils/messanger.dart';
import 'package:go_router/go_router.dart';

class SetWeightModal extends ConsumerStatefulWidget {
  const SetWeightModal({super.key});

  @override
  ConsumerState<SetWeightModal> createState() => _SetWeightModalState();
}

class _SetWeightModalState extends ConsumerState<SetWeightModal> {
  final weightInputController = TextEditingController();

  int weight = 0;

  @override
  void initState() {
    super.initState();

    weightInputController.addListener(() {
      weight = weightInputController.text.isNotEmpty ? int.parse(weightInputController.text) : 0;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = 250 + MediaQuery.of(context).viewInsets.bottom;

    void onSaveClick() {
      ref.read(userProvider.notifier).updateProfile(weight: weight);
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
            localization.setWeightTitle,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w900),
          ),
          SizedBox(height: AppSpacing.lg),
          TextField(
            controller: weightInputController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(suffixText: localization.weightUnit),
          ),
          SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: weight > 10 ? onSaveClick : null,
              child: Text(localization.saveButton),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    weightInputController.dispose();

    super.dispose();
  }
}
