import 'package:freezed_annotation/freezed_annotation.dart';

part 'configuration.g.dart';

@JsonSerializable()
class Configuration {
  final String username;
  final String oauthToken;
  final String clientId;

  Configuration({
    required this.username,
    required this.oauthToken,
    required this.clientId,
  });

  factory Configuration.fromJson(Map<String, dynamic> json) =>
      _$ConfigurationFromJson(json);
  Map<String, dynamic> toJson() => _$ConfigurationToJson(this);
}
