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
import 'package:yandex_mapkit/yandex_mapkit.dart';

class LocationPickerScreen extends ConsumerStatefulWidget {
  static const path = '/location-picker';

  final OrderAddressEntity? initial;

  const LocationPickerScreen({super.key, this.initial});

  @override
  ConsumerState<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends ConsumerState<LocationPickerScreen> {
  static const _tashkent = Point(latitude: 41.2995, longitude: 69.2401);

  YandexMapController? _controller;
  Timer? _debounce;
  int _requestId = 0;

  late Point _currentTarget;
  String? _addressName;
  bool _resolving = false;
  bool _locating = false;

  @override
  void initState() {
    super.initState();
    _currentTarget = _initialPoint;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Point get _initialPoint {
    final initial = widget.initial;
    return initial != null ? Point(latitude: initial.lat, longitude: initial.long) : _tashkent;
  }

  void _onMapCreated(YandexMapController controller) {
    _controller = controller;
    controller.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _initialPoint, zoom: 16, azimuth: 0, tilt: 0),
      ),
    );
    _scheduleGeocode(_initialPoint);
  }

  void _onCameraChanged(CameraPosition position, CameraUpdateReason reason, bool finished) {
    _currentTarget = position.target;
    if (!finished) return;
    _scheduleGeocode(position.target);
  }

  void _scheduleGeocode(Point point) {
    _debounce?.cancel();
    if (!_resolving) setState(() => _resolving = true);
    _debounce = Timer(const Duration(milliseconds: 400), () => _geocode(point));
  }

  Future<void> _geocode(Point point) async {
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
      final point = Point(latitude: position.lat, longitude: position.long);
      _controller?.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: point, zoom: 17, azimuth: 0, tilt: 0),
        ),
      );
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
    context.pop(
      OrderAddressEntity(
        lat: _currentTarget.latitude,
        long: _currentTarget.longitude,
        name: _addressName,
      ),
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
          YandexMap(onMapCreated: _onMapCreated, onCameraPositionChanged: _onCameraChanged),
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
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(Icons.my_location, size: 22, color: theme.colorScheme.primary),
        ),
      ),
    );
  }
}
