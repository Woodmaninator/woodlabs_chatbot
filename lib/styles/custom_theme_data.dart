import 'package:flutter/material.dart';

import 'custom_colors.dart';
import 'custom_text_styles.dart';

class CustomThemeData {
  CustomThemeData._();

  static ThemeData _createTheme(
    ColorScheme colorScheme,
    CustomColors customColors,
    CustomTextStyles customTextStyles,
    Brightness brightness,
  ) => ThemeData(
    colorScheme: colorScheme,
    textTheme: CustomTextStyles.globalTextTheme,
    // fontFamily: 'Roboto', // TODO define font after including
    // fontFamily: FontFamily.inter, // When inter font is included in assets (flutter_gen)
    // fontFamilyFallback: const <String>['Roboto'],
    appBarTheme: const AppBarTheme(titleSpacing: 96, centerTitle: false),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        textStyle: WidgetStateProperty.all(
          CustomTextStyles.globalTextTheme.labelMedium,
        ), // Smaller than normal buttons
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      linearMinHeight: 8.0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colorScheme.error),
      ),
      contentPadding: const EdgeInsets.all(4),
      fillColor: colorScheme.secondary,
      filled: true,
      labelStyle: CustomTextStyles.globalTextTheme.bodySmall,
      hintStyle: CustomTextStyles.globalTextTheme.bodySmall,
      errorStyle: CustomTextStyles.globalTextTheme.bodySmall!.copyWith(
        color: colorScheme.error,
      ),
    ),
    dividerTheme: DividerThemeData(
      color: colorScheme.onSurface,
      thickness: 1.0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: customColors.transparent,
      indicatorColor: customColors.transparent,
      labelTextStyle: WidgetStateTextStyle.resolveWith(
        (state) => customTextStyles.bodyRegular.copyWith(
          color: state.contains(WidgetState.selected)
              ? customColors.attmayGreen
              : customColors.attmayGreen,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (state) => IconThemeData(
          // Highlight on selected with primary
          color: state.contains(WidgetState.selected)
              ? customColors.attmayGreen
              : customColors.attmayGreen,
        ),
      ),
    ),
    // Rail theme should match the [NavigationBarThemeData]
    navigationRailTheme: NavigationRailThemeData(
      groupAlignment: 0.0, // Means center, nice one NavigationRail devs
      backgroundColor: customColors.transparent,
      indicatorColor: Colors.transparent,
      selectedIconTheme: IconThemeData(color: colorScheme.primary),
      unselectedIconTheme: IconThemeData(color: colorScheme.onSurface),
      selectedLabelTextStyle: CustomTextStyles.globalTextTheme.labelSmall!
          .copyWith(color: colorScheme.primary),
      unselectedLabelTextStyle: CustomTextStyles.globalTextTheme.labelSmall!
          .copyWith(color: colorScheme.onSurface),
    ),
    snackBarTheme: SnackBarThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      behavior: SnackBarBehavior.floating,
    ),
    datePickerTheme: DatePickerThemeData(backgroundColor: colorScheme.surface),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: colorScheme.surface,
      hourMinuteTextColor: colorScheme.onSurface,
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(const Size(0, 0)),
        padding: WidgetStateProperty.all(EdgeInsets.all(4)),
        iconSize: WidgetStateProperty.all(16),
      ),
    ),
    extensions: [customColors, customTextStyles],
  );

  static final ThemeData light = _createTheme(
    CustomColors.lightColorScheme,
    CustomColors.light,
    CustomTextStyles.lightTextStyles,
    Brightness.light,
  );
  /*
  static final ThemeData dark = _createTheme(CustomColors.darkColorScheme, CustomColors.dark, CustomTextStyles.darkTextStyles, Brightness.dark);*/
}
