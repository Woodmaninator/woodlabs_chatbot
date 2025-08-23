import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:woodlabs_chatbot/model/profile.dart';
import 'package:woodlabs_chatbot/provider/hive_box_provider.dart';

part 'selected_profile_provider.g.dart';

@riverpod
class SelectedProfile extends _$SelectedProfile {
  @override
  Profile? build() {
    var box = hiveBoxProvider(ref);
    var profiles = box.get('profiles', defaultValue: []) as List<int>;
    if (profiles.isNotEmpty) {
      return Profile.fromJson(
        jsonDecode(box.get('profile_${profiles[0]}') as String),
      );
    }
    return null; // init with null
  }

  void setSelectedProfile(Profile p) {
    state = p;
  }
}
