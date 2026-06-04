import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/request_state.dart';
import 'package:fruitstime/features/assistant/domain/entity/message_entity.dart';
import 'package:fruitstime/features/assistant/domain/usecase/get_chat_history.dart';

final chatHistoryProvider =
    NotifierProvider<_ChatHistoryNotifier, RequestState<List<MessageEntity>>>(
      _ChatHistoryNotifier.new,
    );

class _ChatHistoryNotifier extends Notifier<RequestState<List<MessageEntity>>> {
  @override
  RequestState<List<MessageEntity>> build() => RequestState.idle();

  Future<void> load() async {
    try {
      state = RequestState.loading();
      final messages = await ref.read(getChatHistoryProvider).call();
      state = RequestState.data(messages);
    } on DioException catch (e) {
      state = RequestState.error(e.message);
    }
  }
}
