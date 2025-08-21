import 'package:flutter/material.dart';

enum SnacksBehavior {
  /// By default the SnackBar will be shown after the last one is closed
  queue,

  /// Closes the last SnackBar and shows the new one in its place
  replace,

  /// Ignores the new SnackBar if one is already shown
  ignore,
}

// Just a funny name for managing SnackBars
class Snacks {
  static bool _currentlyShown = false;
  static const _maxLines = 5;

  /// ScaffoldMessengerKey for the main scaffold to be used in the outermost widget, acts as a fallback if context ScaffoldMessenger is not available.
  static final GlobalKey<ScaffoldMessengerState> mainScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  /// Shows a SnackBar with the given text and adequate maxLines of _maxLines.
  /// Returns a [Future] that completes when the [SnackBar] is closed.
  static Future<void> showTextSnack(
    BuildContext context,
    String text, [
    SnacksBehavior behavior = SnacksBehavior.ignore,
  ]) async {
    await _tryShowingSnackBar(
      ScaffoldMessenger.of(context),
      SnackBar(content: Text(text, maxLines: _maxLines)),
      behavior,
    );
  }

  /// Shows the given SnackBar.
  /// Returns a [Future] that completes when the [SnackBar] is closed.
  static Future<void> showSnackBar(
    BuildContext context,
    SnackBar snackBar, [
    SnacksBehavior behavior = SnacksBehavior.ignore,
  ]) async {
    await _tryShowingSnackBar(
      ScaffoldMessenger.of(context),
      snackBar,
      behavior,
    );
  }

  /// Shows a SnackBar with the given text and a custom icon in a row.
  static Future<void> showIconSnackBar(
    BuildContext context,
    String text,
    Widget icon,
  ) {
    return showSnackBar(
      context,
      SnackBar(
        content: Row(
          children: [
            icon,
            const SizedBox(width: 32),
            Flexible(child: Text(text, maxLines: _maxLines)),
          ],
        ),
      ),
    );
  }

  static Future<void> _tryShowingSnackBar(
    ScaffoldMessengerState? scaffoldMessengerState,
    SnackBar snackBar,
    SnacksBehavior behavior,
  ) async {
    scaffoldMessengerState ??= mainScaffoldMessengerKey.currentState;
    if (scaffoldMessengerState == null) {
      return;
    }

    switch (behavior) {
      case SnacksBehavior.ignore:
        // Do nothing if a SnackBar is already shown
        if (_currentlyShown) {
          return;
        }
      case SnacksBehavior.replace:
        // Remove the current SnackBar if one is shown
        scaffoldMessengerState.removeCurrentSnackBar();
        break;
      default:
        break;
    }

    _currentlyShown = true;
    await scaffoldMessengerState.showSnackBar(snackBar).closed;
    _currentlyShown = false;
  }
}
