import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitch_chat/twitch_chat.dart';
import 'package:window_size/window_size.dart';
import 'package:woodlabs_chatbot/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Woodlabs Chatbot');
    setWindowMaxSize(const Size(1000, 600));
    setWindowMinSize(const Size(1000, 600));
  }

  //TODO: REMOVE THIS
  TwitchChat twitchChat = TwitchChat(
    'Woodmaninator',
    'WoodlabsChatbot',
    Platform.environment['WOODLABS_CHATBOT_ACCESS_TOKEN'] ?? '',
    clientId: Platform.environment['WOODLABS_CHATBOT_CLIENT_ID'],
    onConnected: () {
      print('Connected to Twitch Chat');
    },
    onError: () {
      print('Disconnected from Twitch Chat');
    },
    onDone: () {
      print('Twitch Chat connection done');
    },
  );

  twitchChat.connect();

  twitchChat.chatStream.listen((message) {
    print('${message.displayName}: ${message.message}');
    if (message.isSubscriber) {
      print('${message.displayName} is a subscriber!');
    }
    if (message.message == "!ping") {
      twitchChat.sendMessage('/me @${message.displayName} Pong!');
    }
  });

  //TODO: GET PROPER PATH FOR THIS
  await Hive.openBox('woodlabs_chatbot', path: Directory.current.path);

  //TODO: REMOVE THIS
  /*
  var box = Hive.box('woodlabs_chatbot');

  Profile testProfile = Profile(
    id: 1,
    name: 'Test Profile',
    channel: 'Woodmaninator',
    commands: [
      Command(
        command: "!test",
        response: "Test",
        id: 1,
        isEnabled: true,
        globalCooldown: 0,
        userCooldown: 30,
      ),
    ],
    variables: [],
  );

  String profileJsonString = jsonEncode(testProfile.toJson());

  box.put('profile_${testProfile.id}', profileJsonString);

  print('Profile saved!');

  Profile profile = Profile.fromJson(
    jsonDecode(box.get('profile_${testProfile.id}')),
  );
   */

  runApp(ProviderScope(child: const App()));
}
