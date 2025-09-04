import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:woodlabs_chatbot/model/configuration.dart';

import 'hive_box_provider.dart';

part 'current_configuration_provider.g.dart';

@riverpod
class CurrentConfiguration extends _$CurrentConfiguration {
  @override
  Configuration? build() {
    var box = ref.read(hiveBoxProvider);

    var configString = box.get('configuration', defaultValue: '');

    if (configString == '') {
      return null;
    }

    Configuration config = Configuration.fromJson(jsonDecode(configString));

    return config;
  }

  void updateConfiguration(Configuration newConfig) {
    state = newConfig;
    var box = ref.read(hiveBoxProvider);
    box.put('configuration', jsonEncode(newConfig.toJson()));
  }
}
