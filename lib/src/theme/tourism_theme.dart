import 'dart:io';
import 'package:flutter/material.dart';
import 'tourism_text_styles.dart';

class TourismTheme {
  static String platformFontFamily() {
    // Prefer bundled custom font 'Poppins' if included in assets.
    // If Poppins is not bundled, fall back to sensible platform fonts.
    try {
      if (Platform.isAndroid || Platform.isFuchsia || Platform.isLinux)
        return 'Poppins';
      if (Platform.isIOS) return 'SF Pro Text';
      if (Platform.isMacOS) return '.AppleSystemUIFont';
      if (Platform.isWindows) return 'Segoe UI';
    } catch (_) {
      // If platform detection fails for any reason, default to Poppins.
    }
    return 'Poppins';
  }

  static ThemeData light({Color seed = const Color(0xFF2A5BB1)}) {
    final base = ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.light,
      ),
    );
    // Apply platform font to the text theme using TextTheme.apply
    final themedText = TourismTextStyles.build(
      base.textTheme,
    ).apply(fontFamily: platformFontFamily());
    return base.copyWith(
      useMaterial3: true,
      textTheme: themedText,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: seed,
        foregroundColor: base.colorScheme.onPrimary,
      ),
    );
  }

  static ThemeData dark({Color seed = const Color(0xFF2A5BB1)}) {
    final base = ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.dark,
      ),
    );
    final themedText = TourismTextStyles.build(
      base.textTheme,
    ).apply(fontFamily: platformFontFamily());
    return base.copyWith(
      useMaterial3: true,
      textTheme: themedText,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: const Color(0xFF121216),
        foregroundColor: base.colorScheme.onPrimary,
      ),
    );
  }
}
