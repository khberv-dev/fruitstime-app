class RegisterSession {
  final String sessionId;
  final String firstName;
  final String phoneNumber;
  final String password;
  final String? referralCode;

  RegisterSession({
    required this.sessionId,
    required this.firstName,
    required this.phoneNumber,
    required this.password,
    this.referralCode,
  });
}
