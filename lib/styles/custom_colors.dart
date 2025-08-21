import 'package:flutter/material.dart';

class CustomColors extends ThemeExtension<CustomColors> {
  static ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF006666), // Main color
    brightness: Brightness.light,
  );

  const CustomColors({required this.transparent, required this.attmayGreen});

  final Color transparent;
  final Color attmayGreen;

  static const CustomColors light = CustomColors(
    transparent: Color(0x00FFFFFF),
    attmayGreen: Color(0xFF006666),
  );

  static CustomColors of(BuildContext context) =>
      Theme.of(context).extension<CustomColors>()!;

  @override
  ThemeExtension<CustomColors> copyWith({
    Color? transparent,
    Color? attmayGreen,
  }) {
    return CustomColors(
      transparent: transparent ?? this.transparent,
      attmayGreen: attmayGreen ?? this.attmayGreen,
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
