import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:woodlabs_chatbot/model/command.dart';
import 'package:woodlabs_chatbot/model/variable.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
  int id = 0;

  String name;
  String channel;

  List<Command> commands;
  List<Variable> variables;

  Profile({
    this.id = 0,
    required this.name,
    required this.channel,
    List<Command>? commands,
    List<Variable>? variables,
  }) : commands = commands ?? [],
       variables = variables ?? [];

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
