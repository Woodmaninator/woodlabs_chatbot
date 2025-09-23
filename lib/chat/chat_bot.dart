import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitch_chat/twitch_chat.dart';
import 'package:woodlabs_chatbot/provider/current_configuration_provider.dart';
import 'package:woodlabs_chatbot/provider/current_connection_status_provider.dart';
import 'package:woodlabs_chatbot/provider/selected_profile_provider.dart';

class ChatBot {
  static late ProviderContainer container;
  static late TwitchChat twitchChat;

  static bool _connected = false;

  static void initialize(ProviderContainer provContainer) {
    container = provContainer;

    var configuration = container.read(currentConfigurationProvider);
    var profile = container.read(selectedProfileProvider);

    if (configuration == null || profile == null) {
      return;
    }

    connect();
  }

  static void disconnect() {
    if (_connected) {
      twitchChat.close();
      _connected = false;
      container
          .read(currentConnectionStatusProvider.notifier)
          .setStatus(ConnectionStatus.disconnected);
    }
  }

  static void connect() {
    var configuration = container.read(currentConfigurationProvider);
    var profile = container.read(selectedProfileProvider);

    if (_connected) {
      return;
    }

    if (configuration == null || profile == null) {
      container
          .read(currentConnectionStatusProvider.notifier)
          .setStatus(ConnectionStatus.configuration_missing);
      return;
    }

    container
        .read(currentConnectionStatusProvider.notifier)
        .setStatus(ConnectionStatus.connecting);

    twitchChat = TwitchChat(
      profile.channel,
      configuration.username,
      configuration.oauthToken,
      clientId: configuration.clientId,
      onConnected: () {
        _onConnected();
      },
      onError: () {
        _onError();
      },
      onDone: () {
        _onDisconnected();
      },
    );

    // Check if the channel actually exists
    TwitchApi.getTwitchUserChannelId(
          profile.channel,
          configuration.oauthToken,
          configuration.clientId,
        )
        .onError((error, stackTrace) {
          container
              .read(currentConnectionStatusProvider.notifier)
              .setStatus(ConnectionStatus.invalid_channel_name);

          return Future.value(null);
        })
        .then((value) {
          try {
            if (container.read(currentConnectionStatusProvider) ==
                ConnectionStatus.invalid_channel_name) {
              return;
            }

            twitchChat.connect();
          } catch (e) {
            _onError();
            return;
          }

          twitchChat.chatStream.listen(
            _onMessage,
            onDone: _onDisconnected,
            onError: _onMessageError,
            cancelOnError: true,
          );
        });
  }

  static void _onConnected() {
    _connected = true;
    container
        .read(currentConnectionStatusProvider.notifier)
        .setStatus(ConnectionStatus.connected);
  }

  static void _onDisconnected() {
    _connected = false;
    container
        .read(currentConnectionStatusProvider.notifier)
        .setStatus(ConnectionStatus.disconnected);
  }

  static void _onError() {
    _connected = false;
    container
        .read(currentConnectionStatusProvider.notifier)
        .setStatus(ConnectionStatus.disconnected);

    connect();
  }

  static void _onMessageError(Object error) {
    _connected = false;
    container
        .read(currentConnectionStatusProvider.notifier)
        .setStatus(ConnectionStatus.disconnected);

    connect();
  }

  static void _onMessage(ChatMessage message) {
    try {
      // Process the incoming message
      print('Received message from ${message.displayName}: ${message.message}');
    } catch (e) {
      // Handle any errors that occur during message processing
      print('Error processing message: $e');
    }
  }
}
