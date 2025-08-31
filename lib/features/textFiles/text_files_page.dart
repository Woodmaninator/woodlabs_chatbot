import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:woodlabs_chatbot/components/woodlabs_window.dart';

class TextFilesPage extends ConsumerStatefulWidget {
  const TextFilesPage({super.key});

  @override
  ConsumerState<TextFilesPage> createState() => _TextFilesPageState();
}

class _TextFilesPageState extends ConsumerState<TextFilesPage> {
  @override
  Widget build(BuildContext context) {
    return WoodlabsWindow(child: Center(child: Text('Text Files Page')));
  }
}
