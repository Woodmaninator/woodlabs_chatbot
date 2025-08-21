import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../router/routes.dart';
import '../../utils/extensions/context_extensions.dart';

class HomePageIndices {
  static const int profiles = 0;
  static const int commands = 1;
  static const int variables = 2;
}

/// Common class for [NavigationRail] and [NavigationBar] destinations to avoid redundancy
class HomeDestination {
  final Widget icon;
  final String label;

  const HomeDestination({required this.icon, required this.label});
}

/// Home page handles navigation and scroll-to-top for its nested [StatefulShellBranch] routes.
class HomePage extends HookConsumerWidget {
  const HomePage({super.key, required this.child, required this.index});

  final Widget child;
  final int index;

  List<NavigationDestination> fromHomeDestinations(
    List<HomeDestination> destinations,
  ) {
    return destinations
        .map((d) => NavigationDestination(icon: d.icon, label: d.label))
        .toList(growable: false);
  }

  List<NavigationRailDestination> railFromHomeDestinations(
    List<HomeDestination> destinations,
  ) {
    return destinations
        .map(
          (d) => NavigationRailDestination(icon: d.icon, label: Text(d.label)),
        )
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destinations = [
      HomeDestination(icon: Icon(TablerIcons.abacus), label: "A"),
      HomeDestination(icon: Icon(TablerIcons.abacus), label: "B"),
      HomeDestination(icon: Icon(TablerIcons.abacus), label: "C"),
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
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: context.customColors.transparent,
            selectedIndex: index,
            onDestinationSelected: onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            destinations: railFromHomeDestinations(destinations),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
