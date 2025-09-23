import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_size/window_size.dart';
import 'package:woodlabs_chatbot/app.dart';
import 'package:woodlabs_chatbot/chat/chat_bot.dart';
import 'package:woodlabs_chatbot/provider/profiles_provider.dart';
import 'package:woodlabs_chatbot/provider/selected_profile_provider.dart';

import 'model/command.dart';
import 'model/profile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Woodlabs Chatbot');
    setWindowMaxSize(const Size(1000, 600));
    setWindowMinSize(const Size(1000, 600));
  }

  var documentsPath = (await getApplicationDocumentsDirectory()).path;

  if (!await Directory("$documentsPath/WoodlabsChatbot/database").exists()) {
    await Directory(
      "$documentsPath/WoodlabsChatbot/database",
    ).create(recursive: true);
  }

  await Hive.openBox(
    'woodlabs_chatbot',
    path: "$documentsPath/WoodlabsChatbot/database",
  );

  // Ensure that there is a profile at the start
  var box = Hive.box('woodlabs_chatbot');
  var profileString = box.get('profiles', defaultValue: '()');

  // Get a ref from riverpod
  ProviderContainer container = ProviderContainer();

  var profiles = profileString
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

  if (profiles.isEmpty) {
    box.put('profiles', [1].toString());
    Profile defaultProfile = Profile(
      id: 1,
      name: 'Default Profile',
      channel: 'xxx',
      commands: [
        Command(
          command: "!ping",
          response: "Pong!",
          id: 1,
          isEnabled: true,
          globalCooldown: 0,
          userCooldown: 30,
        ),
      ],
      variables: [],
    );

    String profileJsonString = jsonEncode(defaultProfile.toJson());

    box.put('profile_${defaultProfile.id}', profileJsonString);

    container.read(profilesProvider.notifier).updateProfiles([defaultProfile]);
    container
        .read(selectedProfileProvider.notifier)
        .setSelectedProfile(defaultProfile);
  }

  // initialize the actual chat bot logic
  ChatBot.initialize(container);

  runApp(UncontrolledProviderScope(container: container, child: const App()));
}
