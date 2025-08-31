import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:woodlabs_chatbot/components/woodlabs_window.dart';

class ConfigurationPage extends ConsumerStatefulWidget {
  const ConfigurationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfigurationPageState();
}

class _ConfigurationPageState extends ConsumerState<ConfigurationPage> {
  @override
  Widget build(BuildContext context) {
    return WoodlabsWindow(child: Center(child: Text('Configuration Page')));
  }
}
