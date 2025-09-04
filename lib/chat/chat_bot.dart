import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitch_chat/twitch_chat.dart';

class ChatBot {
  static late ProviderContainer container;
  static late TwitchChat twitchChat;

  static void initialize(ProviderContainer provContainer) {
    container = provContainer;
    twitchChat = TwitchChat(
      'Woodmaninator',
      'WoodlabsChatbot',
      '', // Access token should be securely provided
      clientId: '', // Client ID should be securely provided
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
  }
}
