import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData light({Color? seed}) {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: seed ?? Colors.blue),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(centerTitle: true),
    );
    return base.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme)
          .apply(bodyColor: Colors.black87, displayColor: Colors.black87)
          .copyWith(
            headlineSmall: GoogleFonts.poppins(
              textStyle: base.textTheme.headlineSmall,
            ).copyWith(color: Colors.black87, fontWeight: FontWeight.w700),
            titleLarge: GoogleFonts.poppins(
              textStyle: base.textTheme.titleLarge,
            ).copyWith(color: Colors.black87, fontWeight: FontWeight.w600),
          ),
      snackBarTheme: base.snackBarTheme.copyWith(
        contentTextStyle: GoogleFonts.poppins(
          textStyle: base.textTheme.bodyMedium,
        ).copyWith(color: Colors.white),
        backgroundColor: Colors.black87.withAlpha((0.9 * 255).toInt()),
      ),
    );
  }

  static ThemeData dark({Color? seed}) {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed ?? Colors.indigo,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(centerTitle: true),
    );
    return base.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme)
          .apply(bodyColor: Colors.white, displayColor: Colors.white)
          .copyWith(
            headlineSmall: GoogleFonts.poppins(
              textStyle: base.textTheme.headlineSmall,
            ).copyWith(color: Colors.white, fontWeight: FontWeight.w700),
            titleLarge: GoogleFonts.poppins(
              textStyle: base.textTheme.titleLarge,
            ).copyWith(color: Colors.white, fontWeight: FontWeight.w600),
          ),
      snackBarTheme: base.snackBarTheme.copyWith(
        contentTextStyle: GoogleFonts.poppins(
          textStyle: base.textTheme.bodyMedium,
        ).copyWith(color: Colors.white),
        backgroundColor: Colors.black87.withAlpha((0.85 * 255).toInt()),
      ),
    );
  }
}
