import 'package:flutter/material.dart';
import 'package:woodlabs_chatbot/utils/extensions/context_extensions.dart';

class WoodlabsWindow extends StatelessWidget {
  final Widget child;

  WoodlabsWindow({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: context.customColors.background),
      child: Padding(padding: EdgeInsets.all(16.0), child: child),
    );
  }
}
