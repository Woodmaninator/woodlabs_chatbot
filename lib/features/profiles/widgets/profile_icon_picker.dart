import 'package:flutter/material.dart';
import 'package:woodlabs_chatbot/model/profile.dart';
import 'package:woodlabs_chatbot/utils/extensions/context_extensions.dart';

class ProfileIconPicker extends StatelessWidget {
  final ProfileIcon selectedIcon;
  final Function(ProfileIcon) onIconSelected;
  final String label;

  const ProfileIconPicker({
    super.key,
    required this.selectedIcon,
    required this.onIconSelected,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    var icons = ProfileIcon.values;
    var iconsPerRow = 8;

    var iconRows = <Widget>[];
    for (var i = 0; i < icons.length / iconsPerRow; i += 1) {
      var rowIcons = <Widget>[];
      for (var j = 0; j < iconsPerRow; j += 1) {
        var index = i * iconsPerRow + j;
        if (index >= icons.length) {
          break;
        }

        var icon = icons[index];
        rowIcons.add(
          Flexible(
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(8.0),
                onTap: () => onIconSelected(icon),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedIcon == icon
                          ? context.customColors.attmayGreen
                          : context.customColors.backgroundMedium,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Icon(
                      size: 48,
                      _getIconData(icon),
                      color: context.customColors.white100,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        // spacing after every icon except the last one
        if (j < iconsPerRow - 1 && index < icons.length - 1) {
          rowIcons.add(const SizedBox(width: 8.0));
        }
      }

      var row = Row(children: rowIcons);

      iconRows.add(row);

      // spacing after every row except the last one
      if (i < (icons.length / iconsPerRow).ceil() - 1) {
        iconRows.add(const SizedBox(height: 8.0));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.customTextStyles.label),
        const SizedBox(height: 4.0),
        Column(children: iconRows),
      ],
    );
  }

  IconData _getIconData(ProfileIcon icon) {
    return getIconDataForProfileIcon(icon);
  }
}
