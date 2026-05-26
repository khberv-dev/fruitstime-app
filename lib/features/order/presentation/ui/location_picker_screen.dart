import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/geocoding/domain/usecase/get_current_position.dart';
import 'package:fruitstime/features/geocoding/domain/usecase/reverse_geocode.dart';
import 'package:fruitstime/features/order/domain/entity/order_address_entity.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:fruitstime/utils/messanger.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_maps_mapkit/mapkit.dart' as ymk;
import 'package:yandex_maps_mapkit/mapkit_factory.dart';
import 'package:yandex_maps_mapkit/yandex_map.dart';

class LocationPickerScreen extends ConsumerStatefulWidget {
  static const path = '/location-picker';

  final OrderAddressEntity? initial;

  const LocationPickerScreen({super.key, this.initial});

  @override
  ConsumerState<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends ConsumerState<LocationPickerScreen> {
  static const _tashkent = ymk.Point(latitude: 41.2995, longitude: 69.2401);

  ymk.MapWindow? _mapWindow;
  late final _CameraListener _cameraListener;
  Timer? _debounce;
  int _requestId = 0;

  String? _addressName;
  bool _resolving = false;
  bool _locating = false;

  @override
  void initState() {
    super.initState();
    mapkit.onStart();
    _cameraListener = _CameraListener(_onCameraChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _mapWindow?.map.removeCameraListener(_cameraListener);
    mapkit.onStop();
    super.dispose();
  }

  ymk.Point get _initialPoint {
    final initial = widget.initial;
    return initial != null ? ymk.Point(latitude: initial.lat, longitude: initial.long) : _tashkent;
  }

  void _onMapCreated(ymk.MapWindow mapWindow) {
    _mapWindow = mapWindow;
    mapWindow.map.move(ymk.CameraPosition(_initialPoint, zoom: 16, azimuth: 0, tilt: 0));
    mapWindow.map.addCameraListener(_cameraListener);
    _scheduleGeocode(_initialPoint);
  }

  void _onCameraChanged(ymk.CameraPosition position, bool finished) {
    if (!finished) return;
    _scheduleGeocode(position.target);
  }

  void _scheduleGeocode(ymk.Point point) {
    _debounce?.cancel();
    if (!_resolving) setState(() => _resolving = true);
    _debounce = Timer(const Duration(milliseconds: 400), () => _geocode(point));
  }

  Future<void> _geocode(ymk.Point point) async {
    final id = ++_requestId;
    try {
      final name = await ref
          .read(reverseGeocodeProvider)
          .call(lat: point.latitude, long: point.longitude);
      if (!mounted || id != _requestId) return;
      setState(() {
        if (name.isNotEmpty) _addressName = name;
        _resolving = false;
      });
    } catch (_) {
      if (!mounted || id != _requestId) return;
      setState(() => _resolving = false);
    }
  }

  Future<void> _onMyLocation() async {
    if (_locating) return;
    setState(() => _locating = true);
    try {
      final position = await ref.read(getCurrentPositionProvider).call();
      final point = ymk.Point(latitude: position.lat, longitude: position.long);
      _mapWindow?.map.move(ymk.CameraPosition(point, zoom: 17, azimuth: 0, tilt: 0));
      _scheduleGeocode(point);
    } on LocationException catch (e) {
      if (!mounted) return;
      final localization = AppLocalizations.of(context)!;
      showErrorMessage(
        context,
        e.failure == LocationFailure.serviceDisabled
            ? localization.locationServiceDisabled
            : localization.locationPermissionDenied,
      );
    } catch (_) {
      if (!mounted) return;
      showErrorMessage(context, AppLocalizations.of(context)!.locationUnavailable);
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  void _onConfirm() {
    final target = _mapWindow?.map.cameraPosition.target;
    if (target == null) return;
    context.pop(
      OrderAddressEntity(lat: target.latitude, long: target.longitude, name: _addressName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localization.selectLocationTitle)),
      body: Stack(
        alignment: Alignment.center,
        children: [
          YandexMap(onMapCreated: _onMapCreated),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Icon(Icons.location_on, size: 48, color: theme.colorScheme.primary),
          ),
          Positioned(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: AppSpacing.lg,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: _MyLocationButton(locating: _locating, onTap: _onMyLocation),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _AddressBanner(
                    resolving: _resolving,
                    name: _addressName,
                    placeholder: localization.resolvingAddress,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FilledButton(
                    onPressed: _onConfirm,
                    child: Text(
                      localization.confirmLocationButton,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressBanner extends StatelessWidget {
  final bool resolving;
  final String? name;
  final String placeholder;

  const _AddressBanner({required this.resolving, required this.name, required this.placeholder});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Icon(Icons.location_on_outlined, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              name ?? placeholder,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          if (resolving) ...[
            const SizedBox(width: AppSpacing.sm),
            const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
          ],
        ],
      ),
    );
  }
}

class _MyLocationButton extends StatelessWidget {
  final bool locating;
  final VoidCallback onTap;

  const _MyLocationButton({required this.locating, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: locating ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: locating
              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
              : Icon(Icons.my_location, size: 22, color: theme.colorScheme.primary),
        ),
      ),
    );
  }
}

class _CameraListener implements ymk.MapCameraListener {
  final void Function(ymk.CameraPosition position, bool finished) onChanged;

  _CameraListener(this.onChanged);

  @override
  void onCameraPositionChanged(
    ymk.Map map,
    ymk.CameraPosition cameraPosition,
    ymk.CameraUpdateReason cameraUpdateReason,
    bool finished,
  ) => onChanged(cameraPosition, finished);
}
