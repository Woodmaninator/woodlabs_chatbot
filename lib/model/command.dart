import 'package:freezed_annotation/freezed_annotation.dart';

part 'command.g.dart';

@JsonSerializable()
class Command {
  int id;
  String command;
  String response;
  bool isEnabled;
  int userCooldown;
  int globalCooldown;
  int usageCount;

  Command({
    required this.id,
    required this.command,
    required this.response,
    this.isEnabled = true,
    this.userCooldown = 0,
    this.globalCooldown = 0,
    this.usageCount = 0,
  });

  factory Command.fromJson(Map<String, dynamic> json) =>
      _$CommandFromJson(json);
  Map<String, dynamic> toJson() => _$CommandToJson(this);
}
