import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:woodlabs_chatbot/model/profile.dart';
import 'package:woodlabs_chatbot/provider/hive_box_provider.dart';

part 'selected_profile_provider.g.dart';

@riverpod
class SelectedProfile extends _$SelectedProfile {
  @override
  Profile? build() {
    var box = ref.read(hiveBoxProvider);
    var selectedProfileId = box.get('selected_profile_id') as int?;

    var profileString = box.get('profiles', defaultValue: '()');

    var profiles = profileString
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '')
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .map((e) => int.tryParse(e))
        .whereType<int>()
        .toList();

    if (selectedProfileId == null && profiles.isNotEmpty) {
      return Profile.fromJson(
        jsonDecode(box.get('profile_${profiles[0]}') as String),
      );
    } else if (selectedProfileId != null) {
      var profileJson = box.get('profile_$selectedProfileId');
      if (profileJson != null) {
        return Profile.fromJson(jsonDecode(profileJson as String));
      }
    }
    return null; // init with null
  }

  void setSelectedProfile(Profile p) {
    var box = ref.read(hiveBoxProvider);

    box.put('selected_profile_id', p.id);

    state = p;
  }
}
