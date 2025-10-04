import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitch_chat/twitch_chat.dart';
import 'package:woodlabs_chatbot/model/command.dart';
import 'package:woodlabs_chatbot/model/profile.dart';
import 'package:woodlabs_chatbot/model/text_file.dart';
import 'package:woodlabs_chatbot/model/variable.dart';
import 'package:woodlabs_chatbot/provider/banned_users_provider.dart';
import 'package:woodlabs_chatbot/provider/command_received_provider.dart';
import 'package:woodlabs_chatbot/provider/commands_provider.dart';
import 'package:woodlabs_chatbot/provider/current_configuration_provider.dart';
import 'package:woodlabs_chatbot/provider/current_connection_status_provider.dart';
import 'package:woodlabs_chatbot/provider/selected_profile_provider.dart';
import 'package:woodlabs_chatbot/provider/text_files_provider.dart';
import 'package:woodlabs_chatbot/provider/variables_provider.dart';
import 'package:woodlabs_chatbot/service/variable_service.dart';

class ChatBot {
  static Random random = Random();

  static late ProviderContainer container;
  static late TwitchChat twitchChat;

  static bool _connected = false;

  static List<TextFile> _textFiles = [];

  static Map<(int, String), DateTime> userCommandTimestamps =
      {}; // map from command id and username to last used timestamp
  static Map<int, DateTime> globalCommandTimestamps =
      {}; // map from command id to last used timestamp

  static void initialize(ProviderContainer provContainer) {
    container = provContainer;

    var configuration = container.read(currentConfigurationProvider);
    var profile = container.read(selectedProfileProvider);

    container.read(textFilesProvider.future).then((value) {
      _textFiles = value;
    });

    _resetCooldowns();

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

      _resetCooldowns();
    }
  }

  static void updateTextFiles(List<TextFile> textFiles) {
    _textFiles = textFiles;
  }

  static void _resetCooldowns() {
    userCommandTimestamps = {};
    globalCommandTimestamps = {};
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

      if (_isUserBanned(message.displayName)) {
        return;
      }

      var profile = container.read(selectedProfileProvider);

      if (profile == null) {
        // This should never happen as there is a default profile at all times
        return;
      }

      var commands = container.read(commandsProvider);

      // The process is going to be the following: The commands will be grouped by their permission level.
      // (This could easily be done at instantiation but needs to be redone for every command added/removed/updated.
      // For now, it will be done for every command and will only be optimized later if the response time is too long.)
      // Then, based on the user's permission level (subscription status, moderator, vip, etc.), all appropriate commands will be collected.
      // These commands will then be grouped into their trigger type (starts with, word match, contains).
      // The precedence will be starts with > word match > contains. First command that applies will be executed.
      // If there is a command, it will be executed (with commands and all)

      var specificUsersCommands = <Command>[];
      var everyoneCommands = <Command>[];
      var subscriberCommands = <Command>[];
      var vipCommands = <Command>[];
      var moderatorCommands = <Command>[];
      var broadcasterCommands = <Command>[];

      for (var command in commands) {
        switch (command.permissionType) {
          case CommandPermissionType.specificUsers:
            specificUsersCommands.add(command);
            break;
          case CommandPermissionType.everyone:
            everyoneCommands.add(command);
            break;
          case CommandPermissionType.subscribers:
            subscriberCommands.add(command);
            break;
          case CommandPermissionType.vips:
            vipCommands.add(command);
            break;
          case CommandPermissionType.moderators:
            moderatorCommands.add(command);
            break;
          case CommandPermissionType.broadcaster:
            broadcasterCommands.add(command);
            break;
        }
      }

      // This is ugly as fuck but who gives a shit
      var userCommands = <Command>[];
      if (profile.channel.toLowerCase() == message.username.toLowerCase()) {
        userCommands = [
          ...broadcasterCommands,
          ...moderatorCommands,
          ...vipCommands,
          ...subscriberCommands,
          ...everyoneCommands,
          ...specificUsersCommands.where(
            (cmd) => cmd.specificUsers
                .map((e) => e.toLowerCase())
                .contains(message.username.toLowerCase()),
          ),
        ];
      } else if (message.isModerator) {
        userCommands = [
          ...moderatorCommands,
          ...vipCommands,
          ...subscriberCommands,
          ...everyoneCommands,
          ...specificUsersCommands.where(
            (cmd) => cmd.specificUsers
                .map((e) => e.toLowerCase())
                .contains(message.username.toLowerCase()),
          ),
        ];
      } else if (message.isVip) {
        userCommands = [
          ...vipCommands,
          ...subscriberCommands,
          ...everyoneCommands,
          ...specificUsersCommands.where(
            (cmd) => cmd.specificUsers
                .map((e) => e.toLowerCase())
                .contains(message.username.toLowerCase()),
          ),
        ];
      } else if (message.isSubscriber) {
        userCommands = [
          ...subscriberCommands,
          ...everyoneCommands,
          ...specificUsersCommands.where(
            (cmd) => cmd.specificUsers
                .map((e) => e.toLowerCase())
                .contains(message.username.toLowerCase()),
          ),
        ];
      } else {
        userCommands = [
          ...everyoneCommands,
          ...specificUsersCommands.where(
            (cmd) => cmd.specificUsers
                .map((e) => e.toLowerCase())
                .contains(message.username.toLowerCase()),
          ),
        ];
      }

      userCommands = userCommands.where((cmd) => cmd.isEnabled).toList();

      // Group commands by trigger type
      var startsWithCommands = userCommands
          .where((cmd) => cmd.triggerType == CommandTriggerType.startsWith)
          .toList();
      var wordMatchCommands = userCommands
          .where((cmd) => cmd.triggerType == CommandTriggerType.wordMatch)
          .toList();
      var containsCommands = userCommands
          .where((cmd) => cmd.triggerType == CommandTriggerType.contains)
          .toList();

      Command? commandToExecute;

      for (var cmd in startsWithCommands) {
        if (message.message.toLowerCase().startsWith(
          cmd.command.toLowerCase(),
        )) {
          commandToExecute = cmd;
          break;
        }
      }

      if (commandToExecute == null) {
        for (var cmd in wordMatchCommands) {
          var words = message.message.toLowerCase().split(' ');
          if (words.contains(cmd.command.toLowerCase())) {
            commandToExecute = cmd;
            break;
          }
        }
      }

      if (commandToExecute == null) {
        for (var cmd in containsCommands) {
          if (message.message.toLowerCase().contains(
            cmd.command.toLowerCase(),
          )) {
            commandToExecute = cmd;
            break;
          }
        }
      }

      if (commandToExecute == null) {
        return;
      }

      var username = message.username.toLowerCase();
      var commandId = commandToExecute.id;
      var now = DateTime.now();

      // Check user cooldown
      var userLastUsed =
          userCommandTimestamps[(commandId, username)] ??
          DateTime.fromMillisecondsSinceEpoch(0);
      if (now.difference(userLastUsed).inSeconds <
          commandToExecute.userCooldown) {
        return; // User is still on cooldown for this command
      }

      // Check global cooldown
      var globalLastUsed =
          globalCommandTimestamps[commandId] ??
          DateTime.fromMillisecondsSinceEpoch(0);
      if (now.difference(globalLastUsed).inSeconds <
          commandToExecute.globalCooldown) {
        return; // Command is still on global cooldown
      }

      // Update timestamps
      userCommandTimestamps[(commandId, username)] = now;
      globalCommandTimestamps[commandId] = now;

      var variables = container.read(variablesProvider);

      var response = _interpretCommand(
        profile,
        _textFiles,
        variables,
        commandToExecute,
        message,
      );

      if (response.isNotEmpty) {
        twitchChat.sendMessage(response);
      }

      container.read(commandReceivedProvider.notifier).setCommandReceived(true);

      Future.delayed(Duration(seconds: 2), () {
        container
            .read(commandReceivedProvider.notifier)
            .setCommandReceived(false);
      });
    } catch (e) {
      // Handle any errors that occur during message processing
      print('Error processing message: $e');
    }
  }

  static bool _isUserBanned(String user) {
    return container
        .read(bannedUsersProvider)
        .map((e) => e.toLowerCase())
        .contains(user.toLowerCase());
  }

  static String _interpretCommand(
    Profile profile,
    List<TextFile> textFiles,
    List<Variable> variables,
    Command cmd,
    ChatMessage message,
  ) {
    var currentIndex = 0;
    var responseTemplate = cmd.response;
    var builtResponse = "";
    while (currentIndex < responseTemplate.length) {
      var nextFunctionStart = responseTemplate.indexOf("\$", currentIndex);

      if (nextFunctionStart == -1) {
        // no more commands
        builtResponse += responseTemplate.substring(currentIndex);
        break;
      }

      if (nextFunctionStart >= currentIndex) {
        builtResponse += responseTemplate.substring(
          currentIndex,
          nextFunctionStart,
        );

        // Get the entire command string (until the next closed parenthesis)
        var nextFunctionEnd = responseTemplate.indexOf(")", nextFunctionStart);
        if (nextFunctionEnd == -1) {
          // no closing parenthesis, invalid command
          builtResponse += "\$";
          currentIndex = nextFunctionStart + 1;
        }

        var functionString = responseTemplate.substring(
          nextFunctionStart,
          nextFunctionEnd + 1,
        );

        builtResponse += _interpretFunction(
          profile,
          textFiles,
          variables,
          message,
          functionString,
        );
        currentIndex = nextFunctionEnd + 1;
      }
    }

    return builtResponse;
  }

  static String _interpretFunction(
    Profile profile,
    List<TextFile> textFiles,
    List<Variable> variables,
    ChatMessage message,
    String functionString,
  ) {
    // available functions: $getrandline(textfile), $randnum(param, param), $username(), $mychannel(), $incvariable(boing)
    var functionNames = [
      "getrandline",
      "randnum",
      "username",
      "mychannel",
      "incvariable",
    ];

    var startingParenthesisIndex = functionString.indexOf("(");
    if (startingParenthesisIndex == -1) {
      return ""; // invalid function
    }
    var functionName = functionString.substring(1, startingParenthesisIndex);

    if (!functionNames.contains(functionName)) {
      return ""; // invalid function
    }

    var paramsString = functionString.substring(
      startingParenthesisIndex + 1,
      functionString.length - 1,
    );
    var params = paramsString.split(",").map((e) => e.trim()).toList();

    switch (functionName) {
      case "getrandline":
        return _interpretGetRandLineFunction(textFiles, params);
      case "randnum":
        return _interpretRandNumFunction(params);
      case "username":
        return _interpretUsernameFunction(message);
      case "mychannel":
        return _interpretMyChannelFunction(profile);
      case "incvariable":
        return _interpretIncVariableFunction(variables, params[0]);
    }

    return "";
  }

  static String _interpretGetRandLineFunction(
    List<TextFile> textFiles,
    List<String> params,
  ) {
    if (params.isEmpty) {
      return "";
    }

    var fileName = params[0];

    var textFile = textFiles.where((e) => e.name == fileName).firstOrNull;
    if (textFile == null) {
      return "";
    }

    if (textFile.lines.isEmpty) {
      return "";
    }

    return textFile.lines[random.nextInt(textFile.lines.length)];
  }

  static String _interpretRandNumFunction(List<String> params) {
    if (params.length < 2) {
      return "";
    }

    var min = int.tryParse(params[0]);
    var max = int.tryParse(params[1]);

    if (min == null || max == null) {
      return "";
    }

    if (min >= max) {
      return "";
    }

    return (min + random.nextInt(max - min + 1)).toString();
  }

  static String _interpretUsernameFunction(ChatMessage message) {
    return message.displayName;
  }

  static String _interpretMyChannelFunction(Profile profile) {
    return profile.channel;
  }

  static String _interpretIncVariableFunction(
    List<Variable> variables,
    String varName,
  ) {
    var variable = variables.where((e) => e.name == varName).firstOrNull;
    if (variable == null) {
      return "";
    }

    variable.value += 1;

    VariableService.updateVariableC(container, variable);

    return variable.value.toString();
  }
}
