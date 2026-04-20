import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/core/ui/widget/otp_field.dart';
import 'package:fruitstime/features/app/presentation/ui/app_screen.dart';
import 'package:fruitstime/features/auth/presentation/ui/controller/register_session_provider.dart';
import 'package:fruitstime/features/auth/presentation/ui/controller/register_user_provider.dart';
import 'package:fruitstime/features/auth/presentation/ui/widget/otp_header.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:fruitstime/utils/lib.dart';
import 'package:fruitstime/utils/messanger.dart';
import 'package:go_router/go_router.dart';

class OtpScreen extends ConsumerStatefulWidget {
  static const path = '/otp';

  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
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
    final registerSession = ref.watch(registerSessionProvider)!;
    final registerUserState = ref.watch(registerUserProvider);

    void onBackClick() {
      context.pop();
    }

    void onVerifyClick() {
      ref.read(registerUserProvider.notifier).register(registerSession, otp!);
    }

    void onResendClick() {}

    void onOtpComplete(String code) {
      setState(() {
        otp = code;
      });
    }

    ref.listen(registerUserProvider, (_, state) {
      if (state.error != null) {
        showErrorMessage(context, state.error!);
      }

      if (state.data == true) {
        context.go(AppScreen.path);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              OtpHeader(onBackClick: onBackClick),
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
                          color: Theme.of(context).colorScheme.primary.withAlpha(40),
                          borderRadius: BorderRadius.circular(AppRadius.round),
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/guard.svg',
                          colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.primary,
                            BlendMode.srcIn,
                          ),
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
                        localization.otpSentMessage(formatPhoneNumber(registerSession.phoneNumber)),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xl),
                      OtpField(onCompleted: onOtpComplete),
                      SizedBox(height: AppSpacing.md),
                      sendDelaySeconds > 0
                          ? Text(
                              localization.resendCountdown(sendDelaySeconds),
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
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
                        onPressed: otp != null && !registerUserState.isLoading
                            ? onVerifyClick
                            : null,
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
