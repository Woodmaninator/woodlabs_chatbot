import 'package:freezed_annotation/freezed_annotation.dart';

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
