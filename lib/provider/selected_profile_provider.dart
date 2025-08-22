import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:woodlabs_chatbot/model/profile.dart';

part 'selected_profile_provider.g.dart';

@riverpod
class SelectedProfile extends _$SelectedProfile {
  @override
  Profile? build() {
    return null; // init with null
  }

  void setSelectedProfile(Profile p) {
    state = p;
  }
}
