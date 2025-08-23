import 'package:flutter/material.dart';
import 'package:woodlabs_chatbot/utils/extensions/context_extensions.dart';

class WoodlabsButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool isPrimary;
  final bool isDisabled;
  final double width;
  final IconData icon;

  const WoodlabsButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isDisabled,
    required this.width,
    required this.icon,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: isDisabled ? null : () => onPressed(),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: width,
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isDisabled
                ? (isPrimary
                      ? context.customColors.attmayGreenLight
                      : context.customColors.attmayGreenLight)
                : (isPrimary
                      ? context.customColors.attmayGreen
                      : context.customColors.attmayGreen),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: context.customColors.white100, size: 20),
              const SizedBox(width: 8.0),
              Text(text, style: context.customTextStyles.bodyRegular),
            ],
          ),
        ),
      ),
    );
  }
}
