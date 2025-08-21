import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'routes.dart';

part 'router.g.dart';

// Inspired by https://github.com/lucavenir/go_router_riverpod/tree/master handling go_router + riverpod
/// Exposes a [GoRouter] that uses a [Listenable] to refresh its internal state.
/// To sync our app state with this our router, we simply update our listenable via `ref.listen`,
/// and pass it to GoRouter's `refreshListenable`.
@riverpod
GoRouter router(Ref ref) {
  final routerKey = GlobalKey<NavigatorState>(debugLabel: 'routerKey');
  final isAuthenticated = ValueNotifier<AsyncValue<bool>>(const AsyncLoading());

  final router = GoRouter(
    navigatorKey: routerKey,
    refreshListenable: isAuthenticated,
    redirect: (context, state) {
      //ex. check here if User is authenticated else redirect
      //if (Supabase.instance.client.auth.currentUser == null) {
      //  return const LoginRoute().location;
      //}
      return null;
    },
    debugLogDiagnostics: kDebugMode,
    initialLocation: const CommandsRoute().location,
    routes: $appRoutes,
    observers: [],
  );

  ref.onDispose(() {
    router.dispose();
    isAuthenticated.dispose();
  });

  return router;
}
