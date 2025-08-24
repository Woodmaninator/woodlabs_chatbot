import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:woodlabs_chatbot/components/woodlabs_navigation_bar.dart';
import 'package:woodlabs_chatbot/features/home/status_bar.dart';

import '../../router/routes.dart';
import '../../utils/extensions/context_extensions.dart';

class HomePageIndices {
  static const int profiles = 0;
  static const int commands = 1;
  static const int variables = 2;
}

/// Common class for [NavigationRail] and [NavigationBar] destinations to avoid redundancy
class HomeDestination {
  final IconData icon;
  final String label;
  final String location;

  const HomeDestination({
    required this.icon,
    required this.label,
    required this.location,
  });
}

/// Home page handles navigation and scroll-to-top for its nested [StatefulShellBranch] routes.
class HomePage extends HookConsumerWidget {
  const HomePage({super.key, required this.child, required this.index});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destinations = [
      HomeDestination(
        icon: TablerIcons.user,
        label: context.localizations.nav_profiles,
        location: ProfilesRoute().location,
      ),
      HomeDestination(
        icon: TablerIcons.settings_exclamation,
        label: context.localizations.nav_commands,
        location: CommandsRoute().location,
      ),
      HomeDestination(
        icon: TablerIcons.math_xy,
        label: context.localizations.nav_variables,
        location: VariablesRoute().location,
      ),
    ];

    /// Handles navigation and scroll-to-top through [NavigationRail] or [NavigationBar]
    void onDestinationSelected(int i) {
      if (index == i) {
        if (context.goRouter.canPop()) {
          // Pop one page if same page and not scrolled
          context.goRouter.pop();
        }
        return;
      }

      // Navigate to new or top page
      switch (i) {
        case HomePageIndices.profiles:
          const ProfilesRoute().go(context);
          break;
        case HomePageIndices.commands:
          const CommandsRoute().go(context);
          break;
        case HomePageIndices.variables:
          const VariablesRoute().go(context);
          break;
      }
    }

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(color: context.customColors.background),
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: context.customColors.attmayGreen.withValues(
                            alpha: 1.0,
                          ),
                          width: 3.0,
                        ),
                      ),
                    ),
                    width: 175.0,
                    child: WoodlabsNavigationBar(
                      trailing: Column(
                        children: [
                          const SizedBox(height: 16.0),
                          Center(
                            child: Image.asset(
                              "assets/img/woodlabs_800.png",
                              fit: BoxFit.contain,
                              height: 64,
                              width: 64,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                        ],
                      ),
                      icons: destinations.map((d) => d.icon).toList(),
                      labels: destinations.map((d) => d.label).toList(),
                      locations: destinations.map((d) => d.location).toList(),
                      selectedIndex: index,
                    ),
                  ),
                  Expanded(child: child),
                ],
              ),
            ),
            StatusBar(),
          ],
        ),
      ),
    );
  }
}
