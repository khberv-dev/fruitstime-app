import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_radius.dart';

final _baseTheme = ThemeData.light();

final _baseColorScheme = _baseTheme.colorScheme.copyWith(
  primary: Color(0xfff5bd1f),
  onPrimary: Color(0xffffffff),
  secondary: Color(0xff5a8a3c),
  onSecondary: Color(0xffffffff),
  surface: Color(0xffffffff),
  onSurface: Color(0xff1a1a1a),
  onSurfaceVariant: Color(0xff6b7280),
);

final _baseTextTheme = GoogleFonts.interTextTheme();

final _appTheme = _baseTheme.copyWith(
  colorScheme: _baseColorScheme,
  textTheme: _baseTextTheme,
  scaffoldBackgroundColor: Color(0xfffafafa),
  progressIndicatorTheme: _baseTheme.progressIndicatorTheme.copyWith(
    borderRadius: BorderRadius.circular(AppRadius.round),
    color: _baseColorScheme.secondary,
    linearMinHeight: 8,
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      fixedSize: Size.fromHeight(56),
    ),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      backgroundColor: _baseColorScheme.surface,
      padding: EdgeInsets.all(AppSpacing.md),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.round),
        side: BorderSide(color: _baseColorScheme.onSurfaceVariant.withAlpha(100)),
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationThemeData(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      borderSide: BorderSide(color: _baseColorScheme.onSurfaceVariant.withAlpha(40)),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
    prefixIconColor: Colors.red,
    fillColor: _baseColorScheme.surface,
    filled: true,
  ),
  dividerTheme: DividerThemeData(color: _baseColorScheme.onSurfaceVariant.withAlpha(50)),
);

final appThemeProvider = Provider((ref) => _appTheme);
