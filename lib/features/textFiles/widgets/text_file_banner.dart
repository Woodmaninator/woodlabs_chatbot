import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:woodlabs_chatbot/components/woodlabs_icon_button.dart';
import 'package:woodlabs_chatbot/utils/extensions/context_extensions.dart';

class TextFileBanner extends StatelessWidget {
  final String textFile;
  final Function onDelete;
  final Function onEdit;

  const TextFileBanner({
    super.key,
    required this.textFile,
    required this.onEdit,
    required this.onDelete,
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
          Expanded(
            child: Text(
              textFile,
              style: context.customTextStyles.bodyRegular,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.start,
            ),
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
