import 'package:flutter/material.dart';

class CustomTextStyles extends ThemeExtension<CustomTextStyles> {
  /// Global [TextTheme]s defining custom sizing and styles for text.

  final TextStyle bodyRegular;
  final TextStyle statusBar;
  final TextStyle label;
  final TextStyle input;

  /// Additional text styles not present in the [TextTheme].
  const CustomTextStyles({
    required this.bodyRegular,
    required this.statusBar,
    required this.label,
    required this.input,
  });

  // Define sizing and styles, not colors.
  static const CustomTextStyles defaultTextStyles = CustomTextStyles(
    bodyRegular: TextStyle(
      fontFamily: "Inter",
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 17.0 / 14.0,
      leadingDistribution: TextLeadingDistribution.even,
      color: Colors.white,
    ),
    statusBar: TextStyle(
      fontFamily: "Inter",
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 14.0 / 12.0,
      leadingDistribution: TextLeadingDistribution.even,
      color: Colors.white,
    ),
    label: TextStyle(
      fontFamily: "Inter",
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 16.0 / 14.0,
      leadingDistribution: TextLeadingDistribution.even,
      color: Colors.white,
    ),
    input: TextStyle(
      fontFamily: "Inter",
      fontSize: 14,
      fontWeight: FontWeight.w300,
      height: 16.0 / 14.0,
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
  ThemeExtension<CustomTextStyles> copyWith({
    TextStyle? bodyRegular,
    TextStyle? statusBar,
    TextStyle? label,
    TextStyle? input,
  }) {
    return CustomTextStyles(
      bodyRegular: bodyRegular ?? this.bodyRegular,
      statusBar: statusBar ?? this.statusBar,
      label: label ?? this.label,
      input: input ?? this.input,
    );
  }

  @override
  ThemeExtension<CustomTextStyles> lerp(
    covariant ThemeExtension<CustomTextStyles>? other,
    double t,
  ) {
    if (other is! CustomTextStyles) return this;
    return CustomTextStyles(
      bodyRegular: TextStyle.lerp(bodyRegular, other.bodyRegular, t)!,
      statusBar: TextStyle.lerp(statusBar, other.statusBar, t)!,
      label: TextStyle.lerp(label, other.label, t)!,
      input: TextStyle.lerp(input, other.input, t)!,
    );
  }
}
