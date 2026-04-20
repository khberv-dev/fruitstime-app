import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/network/request_state.dart';
import 'package:fruitstime/features/auth/domain/usecase/check_phone_number.dart';
import 'package:fruitstime/features/auth/domain/usecase/send_phone_otp.dart';

final sendOtpProvider = NotifierProvider(_SendOtpNotifier.new);

class _SendOtpNotifier extends Notifier<RequestState<String>> {
  @override
  RequestState<String> build() => RequestState.idle();

  Future<void> sendOtp(String phoneNumber) async {
    try {
      state = RequestState.loading();

      final isPhoneNumberAvailable = await ref.read(checkPhoneNumberProvider).call(phoneNumber);

      if (!isPhoneNumberAvailable) {
        throw DioException(
          message: "Boshqa telefon raqam kiriting",
          requestOptions: RequestOptions(),
        );
      }

      final otpSessionId = await ref.read(sendPhoneOtpProvider).call(phoneNumber);

      state = RequestState.data(otpSessionId);
    } on DioException catch (e) {
      state = RequestState.error(e.message);
    }
  }
}
