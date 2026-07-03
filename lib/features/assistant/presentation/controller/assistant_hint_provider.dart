import 'package:flutter_riverpod/flutter_riverpod.dart';

final assistantHintVisibleProvider = NotifierProvider(_AssistantHintNotifier.new);

class _AssistantHintNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void dismiss() => state = false;
}
