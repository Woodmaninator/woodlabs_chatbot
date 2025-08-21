import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:woodlabs_chatbot/l10n/app_localizations.dart';
import 'package:woodlabs_chatbot/router/router.dart';
import 'package:woodlabs_chatbot/styles/custom_theme_data.dart';
import 'package:woodlabs_chatbot/utils/snacks.dart';
import 'package:woodlabs_chatbot/values/config_values.dart';

class App extends HookConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: ConfigValues.appName,
      theme: CustomThemeData.light,
      themeMode: ThemeMode
          .system, // Uses dark or light depending on system, or only light when dark is not defined
      // darkTheme: CustomThemeData.dark,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
      scaffoldMessengerKey: Snacks.mainScaffoldMessengerKey,
    );
  }
}
