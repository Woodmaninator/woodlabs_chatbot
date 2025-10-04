import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:woodlabs_chatbot/chat/chat_bot.dart';
import 'package:woodlabs_chatbot/model/profile.dart';
import 'package:woodlabs_chatbot/provider/banned_users_provider.dart';
import 'package:woodlabs_chatbot/provider/commands_provider.dart';
import 'package:woodlabs_chatbot/provider/hive_box_provider.dart';
import 'package:woodlabs_chatbot/provider/profiles_provider.dart';
import 'package:woodlabs_chatbot/provider/selected_profile_provider.dart';
import 'package:woodlabs_chatbot/provider/variables_provider.dart';

class ProfileService {
  static int getNextProfileId(List<Profile> profiles) {
    if (profiles.isEmpty) return 1;
    var ids = profiles.map((p) => p.id).toList();
    ids.sort();
    return ids.last + 1;
  }

  static void addProfile(WidgetRef ref, Profile profile) {
    var box = ref.read(hiveBoxProvider);
    profile.id = getNextProfileId(ref.read(profilesProvider));
    var profiles = ref.read(profilesProvider);
    profiles.add(profile);
    box.put('profiles', profiles.map((p) => p.id).toString());
    box.put('profile_${profile.id}', jsonEncode(profile.toJson()));
    ref.read(profilesProvider.notifier).updateProfiles(profiles);
  }

  static void updateProfile(WidgetRef ref, Profile profile) {
    var box = ref.read(hiveBoxProvider);
    var profiles = ref.read(profilesProvider);
    var index = profiles.indexWhere((p) => p.id == profile.id);
    if (index != -1) {
      if (ref.watch(selectedProfileProvider)?.id == profile.id) {
        if (ref.read(selectedProfileProvider)?.channel != profile.channel) {
          ChatBot.disconnect();
          ChatBot.connect();
        }
      }

      profiles[index] = profile;
      box.put('profile_${profile.id}', jsonEncode(profile.toJson()));
      ref.read(profilesProvider.notifier).updateProfiles(profiles);
    }
  }

  static void deleteProfile(WidgetRef ref, int profileId) {
    var box = ref.read(hiveBoxProvider);
    var profiles = ref.read(profilesProvider);

    profiles.removeWhere((p) => p.id == profileId);
    box.put('profiles', profiles.map((p) => p.id).toString());
    box.delete('profile_$profileId');

    ref.read(profilesProvider.notifier).updateProfiles(profiles);
  }

  static void setSelectedProfile(WidgetRef ref, Profile profile) {
    ChatBot.disconnect();

    ref.read(selectedProfileProvider.notifier).setSelectedProfile(profile);
    ref.read(commandsProvider.notifier).updateCommands(profile);
    ref.read(variablesProvider.notifier).updateVariables(profile);
    ref.read(bannedUsersProvider.notifier).updateBannedUsers(profile);

    ChatBot.connect();
  }
}
