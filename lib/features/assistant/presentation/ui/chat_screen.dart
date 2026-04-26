import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/assistant/domain/entity/message_entity.dart';
import 'package:fruitstime/features/assistant/domain/enum/message_sender.dart';
import 'package:fruitstime/features/assistant/presentation/controller/chat_ask_provider.dart';
import 'package:fruitstime/features/assistant/presentation/ui/widget/chat_header.dart';
import 'package:fruitstime/features/assistant/presentation/ui/widget/chat_message.dart';
import 'package:fruitstime/features/auth/presentation/ui/controller/user_provider.dart';
import 'package:fruitstime/features/product/domain/entity/product_entity.dart';
import 'package:fruitstime/features/product/presentation/ui/product_view_modal.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class ChatScreen extends ConsumerStatefulWidget {
  static const path = '/chat';

  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  List<MessageEntity> messages = [];

  final inputMessageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final chatAskState = ref.watch(chatAskStateProvider);

    void onCloseClick() {
      context.pop();
    }

    void onSendClick() {
      if (inputMessageController.text.trim().isEmpty || chatAskState.isLoading) return;

      setState(() {
        messages = [
          MessageEntity(
            text: inputMessageController.text,
            from: MessageSender.me,
            suggestedProducts: [],
          ),
          ...messages,
        ];
      });

      ref.read(chatAskStateProvider.notifier).ask(inputMessageController.text);

      inputMessageController.text = '';
    }

    void onProductItemClick(ProductEntity product) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => ProductViewModal(product: product),
      );
    }

    ref.listen(chatAskStateProvider, (_, state) {
      if (state.data != null) {
        setState(() {
          final newMessage = state.data!;

          messages = [newMessage, ...messages];
        });
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            ChatHeader(onCloseClick: onCloseClick),
            Expanded(
              child: Container(
                color: Colors.black.withAlpha(8),
                child: ListView.separated(
                  padding: EdgeInsets.all(AppSpacing.md),
                  itemBuilder: (_, index) => index == 0
                      ? Row(
                          children: [
                            chatAskState.isLoading
                                ? SizedBox(
                                    height: 64,
                                    child: Lottie.asset('assets/anim/sparkles_loop.json'),
                                  )
                                : SizedBox.shrink(),
                          ],
                        )
                      : ChatMessage(
                          message: messages[index - 1],
                          onProductItemClick: onProductItemClick,
                        ),
                  separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm),
                  itemCount: messages.length + 1,
                  reverse: true,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 64,
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: inputMessageController,
                      decoration: InputDecoration(hintText: localization.chatInputHint),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: onSendClick,
                    icon: SvgPicture.asset(
                      'assets/icons/send.svg',
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.onPrimary,
                        BlendMode.srcIn,
                      ),
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
}
