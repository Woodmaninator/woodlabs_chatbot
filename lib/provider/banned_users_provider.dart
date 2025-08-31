import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:woodlabs_chatbot/model/profile.dart';
import 'package:woodlabs_chatbot/provider/selected_profile_provider.dart';

part 'banned_users_provider.g.dart';

@riverpod
class BannedUsers extends _$BannedUsers {
  @override
  List<String> build() {
    var selectedProfile = ref.read(selectedProfileProvider);
    if (selectedProfile != null) {
      return [...selectedProfile.bannedUsers];
    }
    return [];
  }

  void updateBannedUsers(Profile p) {
    state = [...p.bannedUsers];
  }
}
