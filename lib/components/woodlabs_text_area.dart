import 'package:flutter/material.dart';
import 'package:woodlabs_chatbot/utils/extensions/context_extensions.dart';

class WoodlabsTextArea extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;

  const WoodlabsTextArea({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.customTextStyles.label),
        const SizedBox(height: 4),
        Expanded(
          child: TextField(
            expands: true,
            maxLines: null,
            textAlignVertical: TextAlignVertical(y: -1),
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: context.customTextStyles.input.copyWith(
                color: context.customColors.white100.withValues(alpha: 0.5),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            style: context.customTextStyles.input,
            cursorColor: context.customColors.white100,
          ),
        ),
      ],
    );
  }
}
