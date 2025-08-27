import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:woodlabs_chatbot/components/woodlabs_icon_button.dart';
import 'package:woodlabs_chatbot/utils/extensions/context_extensions.dart';

class CommandBanner extends StatelessWidget {
  final String command;
  final String response;
  final bool isEnabled;
  final ValueChanged<bool> onActiveChanged;
  final Function onDelete;
  final Function onEdit;

  const CommandBanner({
    super.key,
    required this.command,
    required this.response,
    required this.isEnabled,
    required this.onActiveChanged,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: context.customColors.background,
        border: Border.all(color: context.customColors.attmayGreen, width: 1.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 16.0),
          SizedBox(
            width: 200,
            child: Text(
              command,
              style: context.customTextStyles.bodyRegular,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              response,
              style: context.customTextStyles.bodyRegular,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 12.0),
          Switch(
            value: isEnabled,
            onChanged: onActiveChanged,
            activeTrackColor: context.customColors.attmayGreen,
            activeThumbColor: context.customColors.white100,
          ),
          const SizedBox(width: 12.0),
          WoodlabsIconButton(
            onPressed: onEdit,
            icon: TablerIcons.edit,
            backgroundColor: context.customColors.attmayGreen,
          ),
          const SizedBox(width: 8.0),
          WoodlabsIconButton(
            onPressed: onDelete,
            icon: TablerIcons.trash,
            backgroundColor: context.customColors.attmayGreenComplementary,
          ),
          const SizedBox(width: 16.0),
        ],
      ),
    );
  }
}
