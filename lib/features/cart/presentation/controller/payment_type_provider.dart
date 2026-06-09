import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PaymentType { cash, card }

final paymentTypeProvider = NotifierProvider<_PaymentTypeNotifier, PaymentType>(
  _PaymentTypeNotifier.new,
);

class _PaymentTypeNotifier extends Notifier<PaymentType> {
  @override
  PaymentType build() => PaymentType.cash;

  void select(PaymentType type) => state = type;
}
