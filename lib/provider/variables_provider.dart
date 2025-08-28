import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:woodlabs_chatbot/model/profile.dart';
import 'package:woodlabs_chatbot/model/variable.dart';
import 'package:woodlabs_chatbot/provider/selected_profile_provider.dart';

part 'variables_provider.g.dart';

@riverpod
class Variables extends _$Variables {
  @override
  List<Variable> build() {
    var selectedProfile = ref.read(selectedProfileProvider);
    if (selectedProfile != null) {
      return [...selectedProfile.variables];
    }
    return [];
  }

  void updateVariables(Profile p) {
    state = [...p.variables];
  }
}
