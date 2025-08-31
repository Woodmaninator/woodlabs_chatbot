import 'package:flutter/cupertino.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:woodlabs_chatbot/model/command.dart';
import 'package:woodlabs_chatbot/model/variable.dart';

part 'profile.g.dart';

enum ProfileIcon {
  @JsonValue('user')
  user,
  @JsonValue('message')
  message,
  @JsonValue('robot')
  robot,
  @JsonValue('flower')
  flower,
  @JsonValue('wood')
  wood,
  @JsonValue('leaf')
  leaf,
  @JsonValue('maple-leaf')
  mapleLeaf,
  @JsonValue('cat')
  cat,
  @JsonValue('dog')
  dog,
  @JsonValue('paw')
  paw,
  @JsonValue('fish')
  fish,
  @JsonValue('pig')
  pig,
  @JsonValue('meeple')
  meeple,
  @JsonValue('alien')
  alien,
  @JsonValue('ghost')
  ghost,
  @JsonValue('skull')
  skull,
  @JsonValue('pumpkin')
  pumpkin,
  @JsonValue('snowman')
  snowman,
  @JsonValue('cookieMan')
  cookieMan,
  @JsonValue('amongus')
  amongus,
  @JsonValue('circle')
  circle,
  @JsonValue('school')
  school,
  @JsonValue('moustache')
  moustache,
  @JsonValue('gamepad')
  gamepad,
}

IconData getIconDataForProfileIcon(ProfileIcon icon) {
  switch (icon) {
    case ProfileIcon.user:
      return TablerIcons.user;
    case ProfileIcon.cookieMan:
      return TablerIcons.cookie_man;
    case ProfileIcon.amongus:
      return TablerIcons.brand_among_us;
    case ProfileIcon.robot:
      return TablerIcons.robot;
    case ProfileIcon.wood:
      return TablerIcons.wood;
    case ProfileIcon.leaf:
      return TablerIcons.leaf;
    case ProfileIcon.mapleLeaf:
      return TablerIcons.leaf_2;
    case ProfileIcon.cat:
      return TablerIcons.cat;
    case ProfileIcon.dog:
      return TablerIcons.dog;
    case ProfileIcon.paw:
      return TablerIcons.paw;
    case ProfileIcon.fish:
      return TablerIcons.fish;
    case ProfileIcon.meeple:
      return TablerIcons.meeple;
    case ProfileIcon.alien:
      return TablerIcons.alien;
    case ProfileIcon.ghost:
      return TablerIcons.ghost;
    case ProfileIcon.skull:
      return TablerIcons.skull;
    case ProfileIcon.snowman:
      return TablerIcons.snowman;
    case ProfileIcon.pumpkin:
      return TablerIcons.pumpkin_scary;
    case ProfileIcon.flower:
      return TablerIcons.flower;
    case ProfileIcon.circle:
      return TablerIcons.circle;
    case ProfileIcon.pig:
      return TablerIcons.pig;
    case ProfileIcon.message:
      return TablerIcons.message_chatbot;
    case ProfileIcon.school:
      return TablerIcons.school;
    case ProfileIcon.moustache:
      return TablerIcons.moustache;
    case ProfileIcon.gamepad:
      return TablerIcons.device_gamepad;
  }
}

@JsonSerializable()
class Profile {
  int id = 0;

  String name;
  String channel;
  ProfileIcon icon;

  List<Command> commands;
  List<Variable> variables;
  List<String> bannedUsers;

  Profile({
    this.id = 0,
    required this.name,
    required this.channel,
    this.icon = ProfileIcon.user,
    List<Command>? commands,
    List<Variable>? variables,
    List<String>? bannedUsers,
  }) : commands = commands ?? [],
       variables = variables ?? [],
       bannedUsers = bannedUsers ?? [];

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
