import 'package:freezed_annotation/freezed_annotation.dart';

part 'text_file.g.dart';

@JsonSerializable()
class TextFile {
  final String name;
  final List<String> lines;

  TextFile({required this.name, List<String>? lines}) : lines = lines ?? [];

  factory TextFile.fromJson(Map<String, dynamic> json) =>
      _$TextFileFromJson(json);
  Map<String, dynamic> toJson() => _$TextFileToJson(this);
}
