import 'package:flutter/material.dart';
import 'package:woodlabs_chatbot/utils/extensions/context_extensions.dart';

class WoodlabsNavigationBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const WoodlabsNavigationBarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? context.customColors.attmayGreen
                : context.customColors.attmayGreenLight,
            border: Border(
              bottom: BorderSide(
                color: context.customColors.black100.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
          ),
          height: 48,
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(icon, color: context.customColors.white100, size: 24),
              const SizedBox(width: 12),
              Text(label, style: context.customTextStyles.navigationBar),
            ],
          ),
        ),
      ),
    );
  }
}
