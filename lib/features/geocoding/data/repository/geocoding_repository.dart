import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/geocoding/data/dto/geocode_dto.dart';
import 'package:yandex_maps_mapkit/mapkit.dart' show Point;
import 'package:yandex_maps_mapkit/search.dart' as search;

final geocodingRepositoryProvider = Provider((ref) => GeocodingRepository());

/// Reverse geocoding through the native Yandex MapKit Search module. It reuses
/// the same MapKit API key initialized in main.dart — no separate Geocoder
/// HTTP API key is required.
class GeocodingRepository {
  search.SearchManager? _manager;

  // Sessions must be kept alive until their callback fires, otherwise MapKit
  // cancels the request. Held here and removed on completion.
  final _sessions = <search.SearchSession>{};

  search.SearchManager get _searchManager => _manager ??= search.SearchFactory.instance
      .createSearchManager(search.SearchManagerType.Online);

  Future<GeocodeDto> reverseGeocode({required double lat, required double long}) {
    final completer = Completer<GeocodeDto>();
    late final search.SearchSession session;

    void finish(GeocodeDto result) {
      _sessions.remove(session);
      if (!completer.isCompleted) completer.complete(result);
    }

    final listener = search.SearchSessionSearchListener(
      onSearchResponse: (response) => finish(GeocodeDto.fromResponse(response)),
      onSearchError: (_) => finish(GeocodeDto(name: '')),
    );

    session = _searchManager.submitPoint(
      Point(latitude: lat, longitude: long),
      search.SearchOptions(searchTypes: search.SearchType.Geo),
      listener,
      zoom: 16,
    );
    _sessions.add(session);

    return completer.future;
  }
}
