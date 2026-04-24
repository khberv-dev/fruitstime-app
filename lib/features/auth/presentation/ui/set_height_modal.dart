import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/auth/presentation/ui/controller/user_provider.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:fruitstime/utils/messanger.dart';
import 'package:go_router/go_router.dart';

class SetHeightModal extends ConsumerStatefulWidget {
  const SetHeightModal({super.key});

  @override
  ConsumerState<SetHeightModal> createState() => _SetHeighModalState();
}

class _SetHeighModalState extends ConsumerState<SetHeightModal> {
  final weightInputController = TextEditingController();

  int height = 0;

  @override
  void initState() {
    super.initState();

    weightInputController.addListener(() {
      height = weightInputController.text.isNotEmpty ? int.parse(weightInputController.text) : 0;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = 250 + MediaQuery.of(context).viewInsets.bottom;

    void onSaveClick() {
      ref.read(userProvider.notifier).updateProfile(height: this.height);
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
            localization.setHeightTitle,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w900),
          ),
          SizedBox(height: AppSpacing.lg),
          TextField(
            controller: weightInputController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(suffixText: localization.heightUnit),
          ),
          SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: this.height > 10 ? onSaveClick : null,
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
