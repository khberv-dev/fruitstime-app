import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/request_state.dart';
import 'package:fruitstime/features/assistant/domain/entity/message_entity.dart';
import 'package:fruitstime/features/assistant/domain/usecase/chat_ask.dart';

final chatAskStateProvider = NotifierProvider(_ChatAskNotifier.new);

class _ChatAskNotifier extends Notifier<RequestState<MessageEntity>> {
  @override
  RequestState<MessageEntity> build() => RequestState.idle();

  Future<void> ask(String message) async {
    try {
      state = RequestState.loading();

      final response = await ref.read(chatAskProvider).call(message);
      state = RequestState.data(response);
    } on DioException catch (e) {
      state = RequestState.error(e.message);
    }
  }
}
