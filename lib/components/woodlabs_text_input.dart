import 'package:flutter/material.dart';
import 'package:woodlabs_chatbot/utils/extensions/context_extensions.dart';

class WoodlabsTextInput extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;

  const WoodlabsTextInput({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.customTextStyles.label),
        const SizedBox(height: 4),
        SizedBox(
          height: 32,
          child: TextField(
            controller: controller,
            obscureText: obscureText,
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
            onTapOutside: (event) {},
          ),
        ),
      ],
    );
  }
}
