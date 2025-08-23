import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:woodlabs_chatbot/model/command.dart';
import 'package:woodlabs_chatbot/model/profile.dart';
import 'package:woodlabs_chatbot/provider/selected_profile_provider.dart';

part 'commands_provider.g.dart';

@riverpod
class Commands extends _$Commands {
  @override
  List<Command> build() {
    var selectedProfile = ref.read(selectedProfileProvider);
    if (selectedProfile != null) {
      return [...selectedProfile.commands];
    }
    return [];
  }

  void updateCommands(Profile p) {
    state = [...p.commands];
  }
}
