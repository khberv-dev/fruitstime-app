import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/controller/app_locale.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/core/ui/prompt_dialog.dart';
import 'package:fruitstime/features/auth/presentation/ui/change_locale_dialog.dart';
import 'package:fruitstime/features/auth/presentation/ui/controller/user_provider.dart';
import 'package:fruitstime/features/auth/presentation/ui/login_screen.dart';
import 'package:fruitstime/features/auth/presentation/ui/set_birthday_modal.dart';
import 'package:fruitstime/features/auth/presentation/ui/set_height_modal.dart';
import 'package:fruitstime/features/auth/presentation/ui/set_weight_modal.dart';
import 'package:fruitstime/features/auth/presentation/ui/widget/login_profile_card.dart';
import 'package:fruitstime/features/auth/presentation/ui/widget/preference_item.dart';
import 'package:fruitstime/features/auth/presentation/ui/widget/preferences_group.dart';
import 'package:fruitstime/features/auth/presentation/ui/widget/profile_card.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:fruitstime/utils/lib.dart';
import 'package:fruitstime/utils/messanger.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final locales = ref.read(availableLocalesProvider);
    final currentLocale = ref.watch(appLocaleProvider);
    final user = ref.watch(userProvider);

    final currentLocaleName = locales
        .firstWhere((locale) => locale.localeCode == currentLocale.languageCode)
        .localeName;

    void onGotoLoginClick() {
      context.push(LoginScreen.path);
    }

    void onSelectLanguageClick() {
      showDialog(context: context, builder: (_) => ChangeLocaleDialog());
    }

    Future<String> getVersion() async {
      final info = await PackageInfo.fromPlatform();

      return info.version;
    }

    void onLogoutClick() async {
      final bool confirm = await showDialog(
        context: context,
        builder: (_) => PromptDialog(
          title: localization.confirmDialogTitle,
          content: localization.logoutConfirmContent,
        ),
      );

      if (confirm) {
        ref.read(userProvider.notifier).logout();
      }
    }

    void onOpenPrivacyWebClick() {
      launchUrl(
        Uri.parse('https://fruitstime.uz/web/privacy_policy.html'),
        mode: LaunchMode.inAppBrowserView,
      );
    }

    void onReferralClick() async {
      await Clipboard.setData(ClipboardData(text: 'HXYUV384'));

      showInfoMessage(context, "Referral kod nusxalandi");
    }

    void onSetBirthdayClick() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => SetBirthdayModal(),
      );
    }

    void onSetWeightClick() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => SetWeightModal(),
      );
    }

    void onSetHeightClick() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => SetHeightModal(),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Column(
          children: [
            SizedBox(height: AppSpacing.xxl),
            user.data != null
                ? ProfileCard(user: user.data!)
                : LoginProfileCard(onGotoLoginClick: onGotoLoginClick),
            SizedBox(height: AppSpacing.lg),
            user.data != null
                ? PreferencesGroup(
                    text: localization.profileSection,
                    child: Column(
                      children: [
                        PreferenceItem(
                          name: localization.phoneLabel,
                          value: "+${formatPhoneNumber(user.data!.phoneNumber)}",
                          iconPath: 'assets/icons/phone.svg',
                        ),
                        Divider(height: 0),
                        PreferenceItem(
                          name: "Tug'ilgan kun",
                          value: user.data!.birthday?.format(pattern: 'dd-MM-yyyy') ?? "Belgilash",
                          iconPath: 'assets/icons/cake.svg',
                          onPressed: onSetBirthdayClick,
                        ),
                        Divider(height: 0),
                        PreferenceItem(
                          name: "Vazn",
                          value: user.data!.weight != null
                              ? "${user.data!.weight} kg"
                              : "Belgilash",
                          iconPath: 'assets/icons/weight.svg',
                          onPressed: onSetWeightClick,
                        ),
                        Divider(height: 0),
                        PreferenceItem(
                          name: "Bo'y",
                          value: user.data!.height != null
                              ? "${user.data!.height} sm"
                              : "Belgilash",
                          iconPath: 'assets/icons/ruler.svg',
                          onPressed: onSetHeightClick,
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
            SizedBox(height: AppSpacing.md),
            PreferencesGroup(
              text: localization.settingsSection,
              child: Column(
                children: [
                  PreferenceItem(
                    name: localization.languageSetting,
                    value: currentLocaleName,
                    iconPath: 'assets/icons/globe.svg',
                    onPressed: onSelectLanguageClick,
                  ),
                  Divider(height: 0),
                  PreferenceItem(
                    name: localization.termsOfUse,
                    value: localization.privacyPolicy,
                    iconPath: 'assets/icons/document.svg',
                    onPressed: onOpenPrivacyWebClick,
                  ),
                  Divider(height: 0),
                  FutureBuilder(
                    future: getVersion(),
                    builder: (_, state) => state.hasData
                        ? PreferenceItem(
                            name: localization.versionLabel,
                            value: state.data!,
                            iconPath: 'assets/icons/info.svg',
                          )
                        : SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.md),
            user.data != null
                ? PreferencesGroup(
                    text: localization.accountSection,
                    child: Column(
                      children: [
                        PreferenceItem(
                          name: localization.referralCodeLabel,
                          value: 'HXYUV384',
                          iconPath: 'assets/icons/copy.svg',
                          onPressed: onReferralClick,
                        ),
                        Divider(height: 0),
                        PreferenceItem(
                          name: localization.logoutButton,
                          value: localization.logoutDescription,
                          itemColor: Theme.of(context).colorScheme.error,
                          iconPath: 'assets/icons/logout.svg',
                          onPressed: onLogoutClick,
                        ),
                        Divider(height: 0),
                        PreferenceItem(
                          name: localization.deleteAccountButton,
                          value: localization.deleteAccountDescription,
                          itemColor: Theme.of(context).colorScheme.error,
                          iconPath: 'assets/icons/delete.svg',
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
            SizedBox(height: 96),
          ],
        ),
      ),
    );
  }
}
