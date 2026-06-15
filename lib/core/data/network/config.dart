import 'package:flutter/foundation.dart';

const yandexMapsApiKey = '9b104dbc-7702-4a81-a7c4-e03acf385e52';
const yandexGeocoderApiKey = 'c4a38489-982d-4acf-bf1b-c7deea87a711';
const geocoderBaseUrl = 'https://geocode-maps.yandex.ru/1.x/';

final mainHostUrl = 'https://fruitstime.uz';
final testHostUrl = 'http://192.168.0.2:8000';

final hostUrl = kDebugMode ? testHostUrl : mainHostUrl;
// final hostUrl = mainHostUrl;

final baseApiUrl = '$hostUrl/api/';
final baseCdnUrl = '$hostUrl/public';
