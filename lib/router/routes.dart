import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:woodlabs_chatbot/features/bannedUsers/banned_users_page.dart';
import 'package:woodlabs_chatbot/features/commands/command_edit_page.dart';
import 'package:woodlabs_chatbot/features/commands/commands_page.dart';
import 'package:woodlabs_chatbot/features/configuration/configuration_page.dart';
import 'package:woodlabs_chatbot/features/home/home_page.dart';
import 'package:woodlabs_chatbot/features/profiles/profile_edit_page.dart';
import 'package:woodlabs_chatbot/features/profiles/profiles_page.dart';
import 'package:woodlabs_chatbot/features/textFiles/text_file_edit_page.dart';
import 'package:woodlabs_chatbot/features/textFiles/text_files_page.dart';
import 'package:woodlabs_chatbot/features/variables/variable_edit_page.dart';
import 'package:woodlabs_chatbot/features/variables/variables_page.dart';

part 'routes.g.dart';

class CustomSlideTransitionPage<T> extends CustomTransitionPage<T> {
  const CustomSlideTransitionPage({required super.child, super.key})
    : super(
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: _transitionsBuilder,
      );

  static Widget _transitionsBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(1.0, 0.0); // Start off the screen to the right
    const end = Offset.zero; // End at the original position
    const curve = Curves.easeInOut;

    final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(position: animation.drive(tween), child: child);
  }
}

@TypedStatefulShellRoute<HomeShellRoute>(
  branches: [
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<ProfilesRoute>(
          path: '/profiles',
          routes: [
            TypedGoRoute<NewProfileRoute>(path: 'new'),
            TypedGoRoute<EditProfileRoute>(path: 'edit/:profileId'),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<CommandsRoute>(
          path: '/commands',
          routes: [
            TypedGoRoute<NewCommandRoute>(path: 'new'),
            TypedGoRoute<EditCommandRoute>(path: 'edit/:commandId'),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<VariablesRoute>(
          path: '/variables',
          routes: [
            TypedGoRoute<NewVariableRoute>(path: 'new'),
            TypedGoRoute<EditVariableRoute>(path: 'edit/:variableId'),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [TypedGoRoute<BannedUsersRoute>(path: '/bannedUsers')],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<TextFilesRoute>(
          path: '/textFiles',
          routes: [
            TypedGoRoute<NewTextFileRoute>(path: 'new'),
            TypedGoRoute<EditTextFileRoute>(path: 'edit/:fileName'),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [TypedGoRoute<ConfigurationRoute>(path: '/configuration')],
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
  Widget build(context, state) => const ProfilesPage();
}

class NewProfileRoute extends GoRouteData with _$NewProfileRoute {
  const NewProfileRoute();
  @override
  Widget build(context, state) => const ProfileEditPage(profileId: -1);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomSlideTransitionPage(child: build(context, state));
  }
}

class EditProfileRoute extends GoRouteData with _$EditProfileRoute {
  final int profileId;

  const EditProfileRoute({required this.profileId});

  @override
  Widget build(context, state) => ProfileEditPage(profileId: profileId);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomSlideTransitionPage(child: build(context, state));
  }
}

class CommandsRoute extends GoRouteData with _$CommandsRoute {
  const CommandsRoute();
  @override
  Widget build(context, state) => const CommandsPage();
}

class NewCommandRoute extends GoRouteData with _$NewCommandRoute {
  const NewCommandRoute();
  @override
  Widget build(context, state) => CommandEditPage(commandId: -1);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomSlideTransitionPage(child: build(context, state));
  }
}

class EditCommandRoute extends GoRouteData with _$EditCommandRoute {
  final int commandId;
  const EditCommandRoute({required this.commandId});
  @override
  Widget build(context, state) => CommandEditPage(commandId: commandId);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomSlideTransitionPage(child: build(context, state));
  }
}

class VariablesRoute extends GoRouteData with _$VariablesRoute {
  const VariablesRoute();
  @override
  Widget build(context, state) => const VariablesPage();
}

class NewVariableRoute extends GoRouteData with _$NewVariableRoute {
  const NewVariableRoute();
  @override
  Widget build(context, state) => const VariableEditPage(variableId: -1);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomSlideTransitionPage(child: build(context, state));
  }
}

class EditVariableRoute extends GoRouteData with _$EditVariableRoute {
  final int variableId;
  const EditVariableRoute({required this.variableId});
  @override
  Widget build(context, state) => VariableEditPage(variableId: variableId);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomSlideTransitionPage(child: build(context, state));
  }
}

class BannedUsersRoute extends GoRouteData with _$BannedUsersRoute {
  const BannedUsersRoute();

  @override
  Widget build(context, state) => const BannedUsersPage();
}

class TextFilesRoute extends GoRouteData with _$TextFilesRoute {
  const TextFilesRoute();

  @override
  Widget build(context, state) => const TextFilesPage();
}

class NewTextFileRoute extends GoRouteData with _$NewTextFileRoute {
  const NewTextFileRoute();

  @override
  Widget build(context, state) => const TextFileEditPage(textFileName: '');

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomSlideTransitionPage(child: build(context, state));
  }
}

class EditTextFileRoute extends GoRouteData with _$EditTextFileRoute {
  final String fileName;

  const EditTextFileRoute({required this.fileName});

  @override
  Widget build(context, state) => TextFileEditPage(textFileName: fileName);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomSlideTransitionPage(child: build(context, state));
  }
}

class ConfigurationRoute extends GoRouteData with _$ConfigurationRoute {
  const ConfigurationRoute();

  @override
  Widget build(context, state) => const ConfigurationPage();
}
