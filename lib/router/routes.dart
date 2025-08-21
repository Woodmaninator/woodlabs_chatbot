import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:woodlabs_chatbot/features/home/home_page.dart';

part 'routes.g.dart';

@TypedStatefulShellRoute<HomeShellRoute>(
  branches: [
    TypedStatefulShellBranch(
      routes: [TypedGoRoute<ProfilesRoute>(path: '/profiles')],
    ),
    TypedStatefulShellBranch(
      routes: [TypedGoRoute<CommandsRoute>(path: '/commands')],
    ),
    TypedStatefulShellBranch(
      routes: [TypedGoRoute<VariablesRoute>(path: '/variables')],
    ),
  ],
)
class HomeShellRoute extends StatefulShellRouteData {
  const HomeShellRoute();
  @override
  Widget builder(context, state, navigationShell) {
    return HomePage(
      index: navigationShell.currentIndex,
      child: navigationShell,
    );
  }
}

class ProfilesRoute extends GoRouteData with _$ProfilesRoute {
  const ProfilesRoute();
  @override
  Widget build(context, state) => const Placeholder(color: Colors.red);
}

class CommandsRoute extends GoRouteData with _$CommandsRoute {
  const CommandsRoute();
  @override
  Widget build(context, state) => const Placeholder(color: Colors.blue);
}

class VariablesRoute extends GoRouteData with _$VariablesRoute {
  const VariablesRoute();
  @override
  Widget build(context, state) => const Placeholder(color: Colors.green);
}
