import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/auth/domain/model/forgot_password_session.dart';
import 'package:fruitstime/features/auth/presentation/ui/controller/forgot_password_session_provider.dart';
import 'package:fruitstime/features/auth/presentation/ui/controller/send_reset_otp_provider.dart';
import 'package:fruitstime/features/auth/presentation/ui/reset_otp_screen.dart';
import 'package:fruitstime/features/auth/presentation/ui/widget/simple_auth_header.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:fruitstime/utils/lib.dart';
import 'package:fruitstime/utils/messanger.dart';
import 'package:fruitstime/utils/phone_number_formatter.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  static const path = '/forgot-password';

  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final sendOtpState = ref.watch(sendResetOtpProvider);

    void onBackClick() {
      context.pop();
    }

    void onSendCodeClick() {
      if (formKey.currentState!.validate()) {
        ref
            .read(sendResetOtpProvider.notifier)
            .sendOtp('998${extractDigits(phoneNumberController.text)}');
      }
    }

    ref.listen(sendResetOtpProvider, (_, state) {
      if (state.error != null) {
        showErrorMessage(context, state.error!);
      }

      if (state.data != null) {
        ref.read(forgotPasswordSessionProvider.notifier).state = ForgotPasswordSession(
          sessionId: state.data!,
          phoneNumber: '998${extractDigits(phoneNumberController.text)}',
        );

        context.push(ResetOtpScreen.path);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              SimpleAuthHeader(title: localization.forgotPasswordTitle, onBackClick: onBackClick),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: AppSpacing.xl),
                      Container(
                        width: 96,
                        height: 96,
                        padding: EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: scheme.primary.withAlpha(40),
                          borderRadius: BorderRadius.circular(AppRadius.round),
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/guard.svg',
                          colorFilter: ColorFilter.mode(scheme.primary, BlendMode.srcIn),
                        ),
                      ),
                      SizedBox(height: AppSpacing.md),
                      Text(
                        localization.forgotPasswordSubtitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
                      ),
                      SizedBox(height: AppSpacing.xl),
                      Form(
                        key: formKey,
                        child: TextFormField(
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
                      ),
                      SizedBox(height: AppSpacing.md),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: sendOtpState.isLoading ? null : onSendCodeClick,
                          child: Text(localization.continueButton),
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
    phoneNumberController.dispose();

    super.dispose();
  }
}
