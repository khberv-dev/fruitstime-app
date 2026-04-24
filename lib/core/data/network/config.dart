import 'package:flutter/foundation.dart';

final mainHostUrl = 'https://fruitstime.uz';
final testHostUrl = 'http://172.20.10.3:8000';

final hostUrl = kDebugMode ? testHostUrl : mainHostUrl;

final baseApiUrl = '$hostUrl/api/';
final baseCdnUrl = '$hostUrl/public';
