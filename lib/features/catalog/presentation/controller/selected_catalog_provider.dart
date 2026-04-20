import 'package:flutter_riverpod/legacy.dart';
import 'package:fruitstime/features/catalog/domain/entity/catalog_entity.dart';

final selectedCatalogProvider = StateProvider<CatalogEntity?>((ref) => null);
