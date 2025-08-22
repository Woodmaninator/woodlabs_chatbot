import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
Box<dynamic> hiveBoxProvider(Ref ref) {
  return Hive.box('woodlabs_chatbot');
}
