import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/auth/domain/model/register_session.dart';
import 'package:fruitstime/features/auth/presentation/ui/controller/register_session_provider.dart';
import 'package:fruitstime/features/auth/presentation/ui/controller/send_otp_provider.dart';
import 'package:fruitstime/features/auth/presentation/ui/login_screen.dart';
import 'package:fruitstime/features/auth/presentation/ui/otp_screen.dart';
import 'package:fruitstime/features/auth/presentation/ui/widget/register_header.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:fruitstime/utils/lib.dart';
import 'package:fruitstime/utils/messanger.dart';
import 'package:fruitstime/utils/phone_number_formatter.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  static const path = '/register';

  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  bool hasReferral = false;

  final formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final referralController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final sendOtpState = ref.watch(sendOtpProvider);

    void onBackClick() {
      context.pop();
    }

    void onRegisterClick() {
      if (formKey.currentState!.validate()) {
        ref
            .read(sendOtpProvider.notifier)
            .sendOtp('998${extractDigits(phoneNumberController.text)}');
      }
    }

    void gotoLoginClick() {
      context.replace(LoginScreen.path);
    }

    void onHasReferralSwitch() {
      setState(() {
        hasReferral = !hasReferral;
      });
    }

    ref.listen(sendOtpProvider, (_, state) {
      if (state.error != null) {
        return showErrorMessage(context, state.error!);
      }

      if (state.data != null) {
        ref.read(registerSessionProvider.notifier).state = RegisterSession(
          sessionId: state.data!,
          firstName: firstNameController.text.trim(),
          phoneNumber: '998${extractDigits(phoneNumberController.text)}',
          password: passwordController.text,
        );

        context.push(OtpScreen.path);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              RegisterHeader(onBackClick: onBackClick),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: AppSpacing.xxl),
                      Column(
                        children: [
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: firstNameController,
                                  decoration: InputDecoration(labelText: localization.nameLabel),
                                  textCapitalization: TextCapitalization.sentences,
                                  validator: (value) => value!.toString().trim().length > 2
                                      ? null
                                      : localization.nameValidationError,
                                ),
                                SizedBox(height: AppSpacing.md),
                                TextFormField(
                                  controller: phoneNumberController,
                                  decoration: InputDecoration(
                                    labelText: localization.phoneLabel,
                                    prefixText: '+998 ',
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [PhoneNumberFormatter()],
                                  validator: (value) => value!.length == 12
                                      ? null
                                      : localization.phoneValidationError,
                                ),
                                SizedBox(height: AppSpacing.md),
                                TextFormField(
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                    labelText: localization.passwordLabel,
                                  ),
                                  obscureText: true,
                                  validator: (value) => value!.length > 7
                                      ? null
                                      : localization.passwordValidationError,
                                ),
                                GestureDetector(
                                  onTap: onHasReferralSwitch,
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: hasReferral,
                                        onChanged: (_) => onHasReferralSwitch(),
                                      ),
                                      Text(localization.hasReferralCode),
                                    ],
                                  ),
                                ),
                                hasReferral
                                    ? TextFormField(
                                        controller: referralController,
                                        decoration: InputDecoration(
                                          labelText: localization.referralCodeLabel,
                                        ),
                                      )
                                    : SizedBox.shrink(),
                                SizedBox(height: AppSpacing.md),
                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton(
                                    onPressed: !sendOtpState.isLoading ? onRegisterClick : null,
                                    child: Text(localization.continueButton),
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
                                      TextSpan(text: localization.haveAccountText),
                                      TextSpan(
                                        text: localization.loginTitle,
                                        recognizer: TapGestureRecognizer()..onTap = gotoLoginClick,
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
                        ],
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
    firstNameController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    referralController.dispose();

    super.dispose();
  }
}
