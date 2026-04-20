import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/api_client.dart';
import 'package:fruitstime/features/assistant/data/dto/message_dto.dart';

final assistantRepository = Provider((ref) => AssistantRepository(ref.read(apiClientProvider)));

class AssistantRepository {
  final Dio _client;

  AssistantRepository(this._client);

  Future<MessageDto> ask(String message) async {
    final response = await _client.post('assistant/ask', data: {'text': message});

    final data = response.data as Map<String, dynamic>;

    return MessageDto.parse(data);
  }
}
