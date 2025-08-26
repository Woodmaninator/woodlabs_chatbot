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

enum CommandTriggerType {
  @JsonValue("starts-with")
  startsWith,
  @JsonValue("word-match")
  wordMatch,
  @JsonValue("contains")
  contains,
}

List<String> getCommandTriggerTypeNames(BuildContext context) {
  return CommandTriggerType.values
      .map((type) => getCommandTriggerTypeName(context, type))
      .toList();
}

String getCommandTriggerTypeName(
  BuildContext context,
  CommandTriggerType type,
) {
  switch (type) {
    case CommandTriggerType.startsWith:
      return context.localizations.command_trigger_type_starts_with;
    case CommandTriggerType.wordMatch:
      return context.localizations.command_trigger_type_word_match;
    case CommandTriggerType.contains:
      return context.localizations.command_trigger_type_contains;
  }
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
  CommandTriggerType triggerType;

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
    this.triggerType = CommandTriggerType.startsWith,
  });

  factory Command.fromJson(Map<String, dynamic> json) =>
      _$CommandFromJson(json);
  Map<String, dynamic> toJson() => _$CommandToJson(this);

  Command copyWith({
    int? id,
    String? command,
    String? response,
    bool? isEnabled,
    int? userCooldown,
    int? globalCooldown,
    int? usageCount,
    CommandPermissionType? permissionType,
    List<String>? specificUsers,
    CommandTriggerType? triggerType,
  }) {
    return Command(
      id: id ?? this.id,
      command: command ?? this.command,
      response: response ?? this.response,
      isEnabled: isEnabled ?? this.isEnabled,
      userCooldown: userCooldown ?? this.userCooldown,
      globalCooldown: globalCooldown ?? this.globalCooldown,
      usageCount: usageCount ?? this.usageCount,
      permissionType: permissionType ?? this.permissionType,
      specificUsers: specificUsers ?? this.specificUsers,
      triggerType: triggerType ?? this.triggerType,
    );
  }
}
