import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../styles/custom_colors.dart';
import '../../styles/custom_text_styles.dart';

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colorScheme => theme.colorScheme;

  CustomColors get customColors => theme.extension<CustomColors>()!;

  CustomTextStyles get customTextStyles => theme.extension<CustomTextStyles>()!;

  NavigatorState get navigator => Navigator.of(this);

  NavigatorState get rootNavigator => Navigator.of(this, rootNavigator: true);

  GoRouter get goRouter => GoRouter.of(this);

  AppLocalizations get localizations => AppLocalizations.of(this)!;

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  TextScaler get mediaQueryTextScaler => MediaQuery.textScalerOf(this);

  Size get screenSize => MediaQuery.sizeOf(this);

  FocusScopeNode get focusScope => FocusScope.of(this);

  /// Workaround for iOS and ScrollToTop issues of nested navigators (shell routes etc.)
  /// This is the controller which gets the ScrollToTop signal.
  /// https://github.com/flutter/flutter/issues/85603
  ScrollController get globalScrollController =>
      PrimaryScrollController.of(rootNavigator.context);

  String get lastMatchedLocation =>
      goRouter.routerDelegate.currentConfiguration.last.matchedLocation;
}

extension BuildContextPositionExtension on BuildContext {
  /// Returns the bottom position of this context's render object in global coordinates
  Offset get bottomLeftPosition {
    final RenderBox renderBox = findRenderObject() as RenderBox;
    final Offset topLeftPosition = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    return Offset(topLeftPosition.dx, topLeftPosition.dy + size.height);
  }

  /// Returns the bottom position of this context's render object in global coordinates
  Offset get bottomRightPosition {
    final RenderBox renderBox = findRenderObject() as RenderBox;
    final Offset topLeftPosition = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    return Offset(
      topLeftPosition.dx + size.width,
      topLeftPosition.dy + size.height,
    );
  }

  /// Returns the top left position of this context's render object in global coordinates
  Offset get topLeftPosition {
    final RenderBox renderBox = findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero);
  }

  /// Returns the top right position of this context's render object in global coordinates
  Offset get topRightPosition {
    final RenderBox renderBox = findRenderObject() as RenderBox;
    final Offset topLeftPosition = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    return Offset(topLeftPosition.dx + size.width, topLeftPosition.dy);
  }

  /// Returns the center position of this context's render object in global coordinates
  Offset get centerPosition {
    final RenderBox renderBox = findRenderObject() as RenderBox;
    final Offset topLeftPosition = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    return Offset(
      topLeftPosition.dx + size.width / 2,
      topLeftPosition.dy + size.height / 2,
    );
  }
}
