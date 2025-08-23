import 'package:flutter/material.dart';

class WoodlabsIconButton extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const WoodlabsIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.backgroundColor,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8.0),
      child: InkWell(
        onTap: () => onPressed(),
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(child: Icon(icon, color: iconColor, size: 24)),
        ),
      ),
    );
  }
}
