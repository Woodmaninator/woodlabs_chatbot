import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:woodlabs_chatbot/utils/extensions/context_extensions.dart';

part 'command.g.dart';

enum CommandPermissionType {
  @JsonValue("specificUsers")
  specificUsers,
  @JsonValue("everyone")
  everyone,
  @JsonValue("subscribers")
  subscribers,
  @JsonValue("vips")
  vips,
  @JsonValue("moderators")
  moderators,
}

List<String> getCommandPermissionTypeNames(BuildContext context) {
  return CommandPermissionType.values
      .map((type) => getCommandPermissionTypeName(context, type))
      .toList();
}

String getCommandPermissionTypeName(
  BuildContext context,
  CommandPermissionType type,
) {
  switch (type) {
    case CommandPermissionType.specificUsers:
      return context.localizations.command_permission_type_specific_users;
    case CommandPermissionType.everyone:
      return context.localizations.command_permission_type_everyone;
    case CommandPermissionType.subscribers:
      return context.localizations.command_permission_type_subscribers;
    case CommandPermissionType.vips:
      return context.localizations.command_permission_type_vips;
    case CommandPermissionType.moderators:
      return context.localizations.command_permission_type_mods;
  }
}

CommandPermissionType getCommandPermissionTypeFromName(
  BuildContext context,
  String name,
) {
  for (var type in CommandPermissionType.values) {
    if (getCommandPermissionTypeName(context, type) == name) {
      return type;
    }
  }
  return CommandPermissionType.everyone;
}

@JsonSerializable()
class Command {
  int id;
  String command;
  String response;
  bool isEnabled;
  int userCooldown;
  int globalCooldown;
  int usageCount;
  CommandPermissionType permissionType;
  List<String> specificUsers;

  Command({
    required this.id,
    required this.command,
    required this.response,
    this.isEnabled = true,
    this.userCooldown = 0,
    this.globalCooldown = 0,
    this.usageCount = 0,
    this.permissionType = CommandPermissionType.everyone,
    this.specificUsers = const [],
  });

  factory Command.fromJson(Map<String, dynamic> json) =>
      _$CommandFromJson(json);
  Map<String, dynamic> toJson() => _$CommandToJson(this);
}
