import 'package:freezed_annotation/freezed_annotation.dart';

part 'command.g.dart';

@JsonSerializable()
class Command {
  String command;
  String response;
  bool isEnabled;

  Command({
    required this.command,
    required this.response,
    this.isEnabled = true,
  });

  factory Command.fromJson(Map<String, dynamic> json) =>
      _$CommandFromJson(json);
  Map<String, dynamic> toJson() => _$CommandToJson(this);
}
