import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:woodlabs_chatbot/app.dart';

Future<void> main() async {
  runApp(ProviderScope(child: const App()));
}
