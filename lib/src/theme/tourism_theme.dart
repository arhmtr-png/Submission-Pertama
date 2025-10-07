import 'dart:io';
import 'package:flutter/material.dart';
import 'tourism_text_styles.dart';

class TourismTheme {
  static String platformFontFamily() {
    // Prefer the bundled IBM Plex Sans Condensed font included in assets.
    // If for some reason it's not available, fall back to platform fonts.
    try {
      if (Platform.isAndroid || Platform.isFuchsia || Platform.isLinux)
        return 'IBMPlexSansCondensed';
      if (Platform.isIOS) return 'IBMPlexSansCondensed';
      if (Platform.isMacOS) return 'IBMPlexSansCondensed';
      if (Platform.isWindows) return 'IBMPlexSansCondensed';
    } catch (_) {
      // If platform detection fails, default to the bundled font family name.
    }
    return 'IBMPlexSansCondensed';
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
