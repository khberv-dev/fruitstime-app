import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/core/ui/widget/otp_field.dart';
import 'package:fruitstime/features/auth/presentation/ui/controller/forgot_password_session_provider.dart';
import 'package:fruitstime/features/auth/presentation/ui/controller/verify_reset_otp_provider.dart';
import 'package:fruitstime/features/auth/presentation/ui/new_password_screen.dart';
import 'package:fruitstime/features/auth/presentation/ui/widget/simple_auth_header.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:fruitstime/utils/lib.dart';
import 'package:fruitstime/utils/messanger.dart';
import 'package:go_router/go_router.dart';

class ResetOtpScreen extends ConsumerStatefulWidget {
  static const path = '/reset-otp';

  const ResetOtpScreen({super.key});

  @override
  ConsumerState<ResetOtpScreen> createState() => _ResetOtpScreenState();
}

class _ResetOtpScreenState extends ConsumerState<ResetOtpScreen> {
  String? otp;
  int sendDelaySeconds = 60;

  late final Timer sendDelayCounter;

  @override
  void initState() {
    super.initState();

    sendDelayCounter = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (sendDelaySeconds > 0) {
          sendDelaySeconds--;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final session = ref.watch(forgotPasswordSessionProvider)!;
    final verifyState = ref.watch(verifyResetOtpProvider);

    void onBackClick() {
      context.pop();
    }

    void onVerifyClick() {
      ref.read(verifyResetOtpProvider.notifier).verify(sessionId: session.sessionId, code: otp!);
    }

    void onResendClick() {}

    void onOtpComplete(String code) {
      setState(() {
        otp = code;
      });
    }

    ref.listen(verifyResetOtpProvider, (_, state) {
      if (state.error != null) {
        showErrorMessage(context, state.error!);
      }

      if (state.data == true) {
        context.push(NewPasswordScreen.path);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              SimpleAuthHeader(title: localization.confirmNumberTitle, onBackClick: onBackClick),
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
                        localization.enterOtpTitle,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: AppSpacing.md),
                      Text(
                        localization.otpSentMessage(formatPhoneNumber(session.phoneNumber)),
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
                      ),
                      SizedBox(height: AppSpacing.xl),
                      OtpField(onCompleted: onOtpComplete),
                      SizedBox(height: AppSpacing.md),
                      sendDelaySeconds > 0
                          ? Text(
                              localization.resendCountdown(sendDelaySeconds),
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium!.copyWith(color: scheme.onSurfaceVariant),
                            )
                          : SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: onResendClick,
                                child: Text(localization.resendButton),
                              ),
                            ),
                      SizedBox(height: AppSpacing.xl),
                      FilledButton(
                        onPressed: otp != null && !verifyState.isLoading ? onVerifyClick : null,
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(localization.confirmButton, textAlign: TextAlign.center),
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
    sendDelayCounter.cancel();

    super.dispose();
  }
}
