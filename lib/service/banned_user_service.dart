import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:woodlabs_chatbot/provider/banned_users_provider.dart';
import 'package:woodlabs_chatbot/provider/hive_box_provider.dart';
import 'package:woodlabs_chatbot/provider/selected_profile_provider.dart';

class BannedUserService {
  static void addBannedUser(WidgetRef ref, String username) {
    var box = ref.read(hiveBoxProvider);
    var currentProfile = ref.read(selectedProfileProvider);
    if (currentProfile == null) return;

    if (!currentProfile.bannedUsers.contains(username)) {
      currentProfile.bannedUsers.add(username);
      box.put(
        'profile_${currentProfile.id}',
        jsonEncode(currentProfile.toJson()),
      );

      ref
          .read(selectedProfileProvider.notifier)
          .setSelectedProfile(currentProfile);

      ref.read(bannedUsersProvider.notifier).updateBannedUsers(currentProfile);
    }
  }

  static void removeBannedUser(WidgetRef ref, String username) {
    var box = ref.read(hiveBoxProvider);
    var currentProfile = ref.read(selectedProfileProvider);
    if (currentProfile == null) return;

    if (currentProfile.bannedUsers.contains(username)) {
      currentProfile.bannedUsers.remove(username);
      box.put(
        'profile_${currentProfile.id}',
        jsonEncode(currentProfile.toJson()),
      );

      ref
          .read(selectedProfileProvider.notifier)
          .setSelectedProfile(currentProfile);

      ref.read(bannedUsersProvider.notifier).updateBannedUsers(currentProfile);
    }
  }
}
