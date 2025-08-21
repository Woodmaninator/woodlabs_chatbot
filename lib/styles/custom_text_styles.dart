import 'package:flutter/material.dart';

class CustomTextStyles extends ThemeExtension<CustomTextStyles> {
  /// Global [TextTheme]s defining custom sizing and styles for text.

  final TextStyle bodyRegular;

  /// Additional text styles not present in the [TextTheme].
  const CustomTextStyles({required this.bodyRegular});

  // Define sizing and styles, not colors.
  static const CustomTextStyles defaultTextStyles = CustomTextStyles(
    bodyRegular: TextStyle(
      fontFamily: "Inter",
      fontSize: 18,
      fontWeight: FontWeight.w400,
      height: 22.0 / 18.0,
      leadingDistribution: TextLeadingDistribution.even,
      color: Colors.white,
    ),
  );

  static TextTheme globalTextTheme = TextTheme(
    bodyLarge: defaultTextStyles.bodyRegular,
    bodyMedium: defaultTextStyles.bodyRegular,
    bodySmall: defaultTextStyles.bodyRegular,
    displayLarge: defaultTextStyles.bodyRegular,
    displayMedium: defaultTextStyles.bodyRegular,
    displaySmall: defaultTextStyles.bodyRegular,
    headlineLarge: defaultTextStyles.bodyRegular,
    headlineMedium: defaultTextStyles.bodyRegular,
    headlineSmall: defaultTextStyles.bodyRegular,
    titleLarge: defaultTextStyles.bodyRegular,
    titleMedium: defaultTextStyles.bodyRegular,
    titleSmall: defaultTextStyles.bodyRegular,
    labelLarge: defaultTextStyles.bodyRegular,
    labelMedium: defaultTextStyles.bodyRegular,
    labelSmall: defaultTextStyles.bodyRegular,
  );

  // May modify [defaultTextStyles] to create a light theme.
  static const CustomTextStyles lightTextStyles = defaultTextStyles;

  // May modify [defaultTextStyles] to create a dark theme.
  static const CustomTextStyles darkTextStyles = lightTextStyles;

  static CustomTextStyles of(BuildContext context) =>
      Theme.of(context).extension<CustomTextStyles>()!;

  @override
  ThemeExtension<CustomTextStyles> copyWith({TextStyle? bodyRegular}) {
    return CustomTextStyles(bodyRegular: bodyRegular ?? this.bodyRegular);
  }

  @override
  ThemeExtension<CustomTextStyles> lerp(
    covariant ThemeExtension<CustomTextStyles>? other,
    double t,
  ) {
    if (other is! CustomTextStyles) return this;
    return CustomTextStyles(
      bodyRegular: TextStyle.lerp(bodyRegular, other.bodyRegular, t)!,
    );
  }
}
