import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/assistant/data/repository/assistant_repository.dart';
import 'package:fruitstime/features/assistant/domain/entity/message_entity.dart';

final chatAskProvider = Provider((ref) => ChatAskProvider(ref.read(assistantRepository)));

class ChatAskProvider {
  final AssistantRepository _repository;

  ChatAskProvider(this._repository);

  Future<MessageEntity> call(String message) async {
    final responseMessage = await _repository.ask(message);

    return responseMessage.toEntity();
  }
}
