import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light({Color? seed}) {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: seed ?? Colors.blue),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(centerTitle: true),
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(bodyColor: Colors.black87, displayColor: Colors.black87),
      snackBarTheme: base.snackBarTheme.copyWith(
        contentTextStyle: base.textTheme.bodyMedium?.copyWith(color: Colors.white),
        backgroundColor: base.colorScheme.primary,
      ),
    );
  }

  static ThemeData dark({Color? seed}) {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: seed ?? Colors.indigo, brightness: Brightness.dark),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(centerTitle: true),
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(bodyColor: Colors.white70, displayColor: Colors.white70),
      snackBarTheme: base.snackBarTheme.copyWith(
        contentTextStyle: base.textTheme.bodyMedium?.copyWith(color: Colors.black),
        backgroundColor: base.colorScheme.secondary,
      ),
    );
  }
}
