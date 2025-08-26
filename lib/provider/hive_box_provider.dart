import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hive_box_provider.g.dart';

@riverpod
Box<dynamic> hiveBox(Ref ref) {
  return Hive.box('woodlabs_chatbot');
}
