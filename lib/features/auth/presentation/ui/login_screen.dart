import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/app/presentation/ui/app_screen.dart';
import 'package:fruitstime/features/auth/presentation/ui/controller/login_user_provider.dart';
import 'package:fruitstime/features/auth/presentation/ui/forgot_password_screen.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:fruitstime/utils/lib.dart';
import 'package:fruitstime/utils/messanger.dart';
import 'package:fruitstime/utils/phone_number_formatter.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const path = '/login';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final loginState = ref.watch(loginUserProvider);

    void onLoginClick() {
      if (formKey.currentState!.validate()) {
        ref
            .read(loginUserProvider.notifier)
            .login('998${extractDigits(phoneNumberController.text)}', passwordController.text);
      }
    }

    void onGotoRegisterClick() {
      context.replace('/register');
    }

    void onForgotPasswordClick() {
      context.push(ForgotPasswordScreen.path);
    }

    ref.listen(loginUserProvider, (_, state) {
      if (state.error != null) {
        showErrorMessage(context, state.error!);
      }

      if (state.data == true) {
        context.go(AppScreen.path);
      }
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: SvgPicture.asset(
                'assets/icons/brand.svg',
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              localization.loginTitle,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              localization.loginSubtitle,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: AppSpacing.xl),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: phoneNumberController,
                    decoration: InputDecoration(
                      labelText: localization.phoneLabel,
                      prefixText: '+998 ',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [PhoneNumberFormatter()],
                    validator: (value) =>
                        value!.length == 12 ? null : localization.phoneValidationError,
                  ),
                  SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: localization.passwordLabel),
                    obscureText: true,
                    validator: (value) =>
                        value!.length > 7 ? null : localization.passwordValidationError,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: onForgotPasswordClick,
                      child: Text(localization.forgotPasswordLink),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: loginState.isLoading ? null : onLoginClick,
                child: Text(localization.signInButton),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                children: [
                  TextSpan(text: localization.noAccountText),
                  TextSpan(
                    text: localization.registerTitle,
                    recognizer: TapGestureRecognizer()..onTap = onGotoRegisterClick,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    passwordController.dispose();

    super.dispose();
  }
}
