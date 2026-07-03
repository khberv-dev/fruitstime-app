import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/assistant/presentation/controller/assistant_hint_provider.dart';
import 'package:fruitstime/features/assistant/presentation/ui/chat_screen.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class AssistantBubble extends ConsumerWidget {
  const AssistantBubble({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final hintVisible = ref.watch(assistantHintVisibleProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hintVisible) ...[
          Container(
            constraints: const BoxConstraints(maxWidth: 200),
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.sm,
              AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: scheme.onSurfaceVariant.withAlpha(40)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(20),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    localization.assistantHintText,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                GestureDetector(
                  onTap: () => ref.read(assistantHintVisibleProvider.notifier).dismiss(),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: SvgPicture.asset(
                      'assets/icons/close.svg',
                      width: 14,
                      height: 14,
                      colorFilter: ColorFilter.mode(scheme.onSurfaceVariant, BlendMode.srcIn),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.sm),
        ],
        GestureDetector(
          onTap: () => context.push(ChatScreen.path),
          child: Container(
            width: 64,
            height: 64,
            padding: EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: scheme.surface,
              shape: BoxShape.circle,
              border: Border.all(color: scheme.onSurfaceVariant.withAlpha(40)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(40),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(child: Lottie.asset('assets/anim/robot.json')),
          ),
        ),
      ],
    );
  }
}
