import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:woodlabs_chatbot/model/configuration.dart';
import 'package:woodlabs_chatbot/provider/current_configuration_provider.dart';
import 'package:woodlabs_chatbot/provider/hive_box_provider.dart';

class ConfigurationService {
  static void saveConfiguration(WidgetRef ref, Configuration config) {
    var box = ref.read(hiveBoxProvider);

    box.put('configuration', jsonEncode(config.toJson()));
    ref.read(currentConfigurationProvider.notifier).updateConfiguration(config);
  }
}
