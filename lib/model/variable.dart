import 'package:freezed_annotation/freezed_annotation.dart';

part 'variable.g.dart';

@JsonSerializable()
class Variable {
  String name;
  int value;

  Variable({required this.name, required this.value});

  factory Variable.fromJson(Map<String, dynamic> json) =>
      _$VariableFromJson(json);
  Map<String, dynamic> toJson() => _$VariableToJson(this);
}
