import 'package:flutter/material.dart';

class CustomColors extends ThemeExtension<CustomColors> {
  static ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF006666), // Main color
    brightness: Brightness.light,
  );

  const CustomColors({
    required this.transparent,
    required this.attmayGreen,
    required this.attmayGreenLight,
    required this.attmayGreenComplementary,
    required this.attmayGreenComplementaryLight,
    required this.background,
    required this.backgroundLight,
    required this.backgroundMedium,
    required this.white100,
    required this.black100,
  });

  final Color transparent;
  final Color attmayGreen;
  final Color attmayGreenLight;
  final Color attmayGreenComplementary;
  final Color attmayGreenComplementaryLight;
  final Color background;
  final Color backgroundLight;
  final Color backgroundMedium;
  final Color white100;
  final Color black100;

  static const CustomColors light = CustomColors(
    transparent: Color(0x00FFFFFF),
    attmayGreen: Color(0xFF006666),
    attmayGreenLight: Color(0xFF446666),
    attmayGreenComplementary: Color(0xFF66004B),
    attmayGreenComplementaryLight: Color(0xFF66446B),
    background: Color(0xFF333333),
    backgroundLight: Color(0xFF6F6F6F),
    backgroundMedium: Color(0xFF4F4F4F),
    white100: Color(0xFFFFFFFF),
    black100: Color(0xFF000000),
  );

  static CustomColors of(BuildContext context) =>
      Theme.of(context).extension<CustomColors>()!;

  @override
  ThemeExtension<CustomColors> copyWith({
    Color? transparent,
    Color? attmayGreen,
    Color? attmayGreenLight,
    Color? attmayGreenComplementary,
    Color? attmayGreenComplementaryLight,
    Color? background,
    Color? backgroundLight,
    Color? backgroundMedium,
    Color? white100,
    Color? black100,
  }) {
    return CustomColors(
      transparent: transparent ?? this.transparent,
      attmayGreen: attmayGreen ?? this.attmayGreen,
      attmayGreenLight: attmayGreenLight ?? this.attmayGreenLight,
      attmayGreenComplementary:
          attmayGreenComplementary ?? this.attmayGreenComplementary,
      attmayGreenComplementaryLight:
          attmayGreenComplementaryLight ?? this.attmayGreenComplementaryLight,
      background: background ?? this.background,
      backgroundLight: backgroundLight ?? this.backgroundLight,
      backgroundMedium: backgroundMedium ?? this.backgroundMedium,
      white100: white100 ?? this.white100,
      black100: black100 ?? this.black100,
    );
  }

  @override
  ThemeExtension<CustomColors> lerp(
    covariant ThemeExtension<CustomColors>? other,
    double t,
  ) {
    if (other is! CustomColors) return this;
    return CustomColors(
      transparent: Color.lerp(transparent, other.transparent, t)!,
      attmayGreen: Color.lerp(attmayGreen, other.attmayGreen, t)!,
      attmayGreenLight: Color.lerp(
        attmayGreenLight,
        other.attmayGreenLight,
        t,
      )!,
      attmayGreenComplementary: Color.lerp(
        attmayGreenComplementary,
        other.attmayGreenComplementary,
        t,
      )!,
      attmayGreenComplementaryLight: Color.lerp(
        attmayGreenComplementaryLight,
        other.attmayGreenComplementaryLight,
        t,
      )!,
      background: Color.lerp(background, other.background, t)!,
      backgroundLight: Color.lerp(backgroundLight, other.backgroundLight, t)!,
      backgroundMedium: Color.lerp(
        backgroundMedium,
        other.backgroundMedium,
        t,
      )!,
      white100: Color.lerp(white100, other.white100, t)!,
      black100: Color.lerp(black100, other.black100, t)!,
    );
  }
}

extension CustomColorExtension on Color {
  MaterialColor get materialColor {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = red, g = green, b = blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(value, swatch);
  }

  Color get inverted {
    final r = 255 - red;
    final g = 255 - green;
    final b = 255 - blue;

    return Color.fromARGB((opacity * 255).round(), r, g, b);
  }
}
