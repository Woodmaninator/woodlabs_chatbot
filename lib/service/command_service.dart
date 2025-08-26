import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:woodlabs_chatbot/model/command.dart';
import 'package:woodlabs_chatbot/provider/commands_provider.dart';
import 'package:woodlabs_chatbot/provider/hive_box_provider.dart';
import 'package:woodlabs_chatbot/provider/selected_profile_provider.dart';

class CommandService {
  static int getNextCommandId(List<Command> commands) {
    if (commands.isEmpty) return 1;
    var ids = commands.map((c) => c.id).toList();
    ids.sort();
    return ids.last + 1;
  }

  static void addCommand(WidgetRef ref, Command command) {
    var box = ref.read(hiveBoxProvider);
    var currentProfile = ref.read(selectedProfileProvider);
    if (currentProfile == null) return;

    command.id = getNextCommandId(currentProfile.commands);

    currentProfile.commands.add(command);
    box.put(
      'profile_${currentProfile.id}',
      jsonEncode(currentProfile.toJson()),
    );
    ref
        .read(selectedProfileProvider.notifier)
        .setSelectedProfile(currentProfile);
    ref.read(commandsProvider.notifier).updateCommands(currentProfile);
  }

  static void updateCommand(WidgetRef ref, Command command) {
    var box = ref.read(hiveBoxProvider);
    var currentProfile = ref.read(selectedProfileProvider);
    if (currentProfile == null) return;

    var index = currentProfile.commands.indexWhere((c) => c.id == command.id);
    if (index != -1) {
      currentProfile.commands[index] = command;
      box.put(
        'profile_${currentProfile.id}',
        jsonEncode(currentProfile.toJson()),
      );
      ref
          .read(selectedProfileProvider.notifier)
          .setSelectedProfile(currentProfile);
      ref.read(commandsProvider.notifier).updateCommands(currentProfile);
    }
  }

  static void deleteCommand(WidgetRef ref, int commandId) {
    var box = ref.read(hiveBoxProvider);
    var currentProfile = ref.read(selectedProfileProvider);
    if (currentProfile == null) return;

    currentProfile.commands.removeWhere((c) => c.id == commandId);
    box.put(
      'profile_${currentProfile.id}',
      jsonEncode(currentProfile.toJson()),
    );
    ref
        .read(selectedProfileProvider.notifier)
        .setSelectedProfile(currentProfile);
    ref.read(commandsProvider.notifier).updateCommands(currentProfile);
  }
}
