String formatNumber(int number) {
  String str = number.toString();
  RegExp reg = RegExp(r'(\d)(?=(\d{3})+(?!\d))');

  return str.replaceAllMapped(reg, (Match m) => '${m[1]} ');
}

String extractDigits(String input) {
  return input.replaceAll(RegExp(r'\D'), '');
}

String formatPhoneNumber(String input) {
  final digits = input.replaceAll(RegExp(r'\D'), '');

  if (digits.length != 12) return input;

  return '${digits.substring(0, 3)} ${digits.substring(3, 5)} ${digits.substring(5, 8)} ${digits.substring(8, 10)} ${digits.substring(10, 12)}';
}
