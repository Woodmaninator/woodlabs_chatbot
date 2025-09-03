import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:woodlabs_chatbot/model/profile.dart';

import 'hive_box_provider.dart';

part 'profiles_provider.g.dart';

@riverpod
class Profiles extends _$Profiles {
  @override
  List<Profile> build() {
    var box = ref.read(hiveBoxProvider);

    var profileString = box.get('profiles', defaultValue: '()');

    var profileIds = profileString
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll('[', '')
        .replaceAll(']', '')
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .map((e) => int.tryParse(e))
        .whereType<int>()
        .toList();

    List<Profile> profiles = profileIds
        .map((id) {
          var profileJson = box.get('profile_$id');
          if (profileJson != null) {
            return Profile.fromJson(jsonDecode(profileJson as String));
          }
          return null;
        })
        .whereType<Profile>()
        .toList();

    return profiles;
  }

  void updateProfiles(List<Profile> profiles) {
    state = [...profiles];
  }
}
