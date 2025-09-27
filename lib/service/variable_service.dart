import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:woodlabs_chatbot/model/variable.dart';
import 'package:woodlabs_chatbot/provider/hive_box_provider.dart';
import 'package:woodlabs_chatbot/provider/selected_profile_provider.dart';
import 'package:woodlabs_chatbot/provider/variables_provider.dart';

class VariableService {
  static int getNextVariableId(List<Variable> variables) {
    if (variables.isEmpty) return 1;
    var ids = variables.map((v) => v.id).toList();
    ids.sort();
    return ids.last + 1;
  }

  static void addVariable(WidgetRef ref, Variable variable) {
    var box = ref.read(hiveBoxProvider);
    var currentProfile = ref.read(selectedProfileProvider);
    if (currentProfile == null) return;

    variable.id = getNextVariableId(currentProfile.variables);

    currentProfile.variables.add(variable);
    box.put(
      'profile_${currentProfile.id}',
      jsonEncode(currentProfile.toJson()),
    );

    ref
        .read(selectedProfileProvider.notifier)
        .setSelectedProfile(currentProfile);

    ref.read(variablesProvider.notifier).updateVariables(currentProfile);
  }

  static void updateVariable(WidgetRef ref, Variable variable) {
    updateVariableC(ref.container, variable);
  }

  static void updateVariableC(ProviderContainer container, Variable variable) {
    var box = container.read(hiveBoxProvider);
    var currentProfile = container.read(selectedProfileProvider);
    if (currentProfile == null) return;

    var index = currentProfile.variables.indexWhere((v) => v.id == variable.id);
    if (index != -1) {
      currentProfile.variables[index] = variable;
      box.put(
        'profile_${currentProfile.id}',
        jsonEncode(currentProfile.toJson()),
      );

      container
          .read(selectedProfileProvider.notifier)
          .setSelectedProfile(currentProfile);

      container
          .read(variablesProvider.notifier)
          .updateVariables(currentProfile);
    }
  }

  static void deleteVariable(WidgetRef ref, int variableId) {
    var box = ref.read(hiveBoxProvider);
    var currentProfile = ref.read(selectedProfileProvider);
    if (currentProfile == null) return;

    currentProfile.variables.removeWhere((v) => v.id == variableId);
    box.put(
      'profile_${currentProfile.id}',
      jsonEncode(currentProfile.toJson()),
    );
    ref
        .read(selectedProfileProvider.notifier)
        .setSelectedProfile(currentProfile);

    ref.read(variablesProvider.notifier).updateVariables(currentProfile);
  }
}
