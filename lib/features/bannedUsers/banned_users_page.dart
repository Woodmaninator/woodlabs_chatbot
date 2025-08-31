import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:woodlabs_chatbot/components/woodlabs_window.dart';

class BannedUsersPage extends ConsumerStatefulWidget {
  const BannedUsersPage({super.key});

  @override
  ConsumerState<BannedUsersPage> createState() => _BannedUsersPageState();
}

class _BannedUsersPageState extends ConsumerState<BannedUsersPage> {
  @override
  Widget build(BuildContext context) {
    return WoodlabsWindow(child: Center(child: Text('Banned Users Page')));
  }
}
