import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/auth/presentation/ui/controller/forgot_password_session_provider.dart';
import 'package:fruitstime/features/auth/presentation/ui/controller/reset_password_provider.dart';
import 'package:fruitstime/features/auth/presentation/ui/login_screen.dart';
import 'package:fruitstime/features/auth/presentation/ui/widget/simple_auth_header.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:fruitstime/utils/messanger.dart';
import 'package:go_router/go_router.dart';

class NewPasswordScreen extends ConsumerStatefulWidget {
  static const path = '/new-password';

  const NewPasswordScreen({super.key});

  @override
  ConsumerState<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends ConsumerState<NewPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final session = ref.watch(forgotPasswordSessionProvider)!;
    final resetState = ref.watch(resetPasswordProvider);

    void onBackClick() {
      context.pop();
    }

    void onSaveClick() {
      if (formKey.currentState!.validate()) {
        ref
            .read(resetPasswordProvider.notifier)
            .reset(otpId: session.sessionId, password: passwordController.text);
      }
    }

    ref.listen(resetPasswordProvider, (_, state) {
      if (state.error != null) {
        showErrorMessage(context, state.error!);
      }

      if (state.data == true) {
        ref.read(forgotPasswordSessionProvider.notifier).state = null;
        showInfoMessage(context, localization.resetPasswordSuccessMessage);
        context.go(LoginScreen.path);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              SimpleAuthHeader(title: localization.newPasswordTitle, onBackClick: onBackClick),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: AppSpacing.xl),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: passwordController,
                              decoration: InputDecoration(labelText: localization.newPasswordLabel),
                              obscureText: true,
                              validator: (value) =>
                                  value!.length > 7 ? null : localization.passwordValidationError,
                            ),
                            SizedBox(height: AppSpacing.md),
                            TextFormField(
                              controller: confirmPasswordController,
                              decoration: InputDecoration(
                                labelText: localization.confirmPasswordLabel,
                              ),
                              obscureText: true,
                              validator: (value) => value == passwordController.text
                                  ? null
                                  : localization.passwordMismatchError,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSpacing.md),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: resetState.isLoading ? null : onSaveClick,
                          child: Text(localization.resetPasswordButton),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }
}
