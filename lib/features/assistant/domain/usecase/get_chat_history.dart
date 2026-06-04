import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/assistant/data/repository/assistant_repository.dart';
import 'package:fruitstime/features/assistant/domain/entity/message_entity.dart';

final getChatHistoryProvider = Provider((ref) => GetChatHistory(ref.read(assistantRepository)));

class GetChatHistory {
  final AssistantRepository _repository;

  GetChatHistory(this._repository);

  Future<List<MessageEntity>> call() async {
    final dtos = await _repository.getHistory();
    return dtos.map((d) => d.toEntity()).toList();
  }
}
