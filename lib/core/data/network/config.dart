import 'package:flutter/foundation.dart';

final mainHostUrl = 'https://fruitstime.uz';
final testHostUrl = 'http://192.168.0.2:8000';

// final hostUrl = kDebugMode ? testHostUrl : mainHostUrl;
final hostUrl = mainHostUrl;

final baseApiUrl = '$hostUrl/api/';
final baseCdnUrl = '$hostUrl/public';
