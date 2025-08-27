import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:woodlabs_chatbot/components/woodlabs_button.dart';
import 'package:woodlabs_chatbot/components/woodlabs_icon_button.dart';
import 'package:woodlabs_chatbot/model/profile.dart';
import 'package:woodlabs_chatbot/utils/extensions/context_extensions.dart';

class ProfileBanner extends StatelessWidget {
  final Profile profile;
  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProfileBanner({
    super.key,
    required this.profile,
    required this.isSelected,
    required this.onSelect,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isSelected
              ? context.customColors.background
              : context.customColors.backgroundMedium,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: context.customColors.attmayGreen,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              profile.name,
              style: context.customTextStyles.navigationBar,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16.0),
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: context.customColors.backgroundLight,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Center(
                child: Icon(
                  getIconDataForProfileIcon(profile.icon),
                  size: 96,
                  color: isSelected
                      ? context.customColors.attmayGreen
                      : context.customColors.white100,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              context.localizations.profile_channel_name,
              style: context.customTextStyles.label,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4.0),
            Text(
              profile.channel,
              style: context.customTextStyles.bodyRegular,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: WoodlabsButton(
                    text: isSelected
                        ? context.localizations.profile_select_profile_selected
                        : context.localizations.profile_select_profile,
                    onPressed: onSelect,
                    isDisabled: isSelected,
                    width: double.infinity,
                  ),
                ),
                const SizedBox(width: 8.0),
                WoodlabsIconButton(
                  onPressed: onEdit,
                  icon: TablerIcons.edit,
                  backgroundColor: context.customColors.attmayGreen,
                ),
                const SizedBox(width: 8.0),
                WoodlabsIconButton(
                  onPressed: isSelected ? () => {} : onDelete,
                  icon: TablerIcons.trash,
                  backgroundColor: isSelected
                      ? context.customColors.attmayGreenComplementaryLight
                      : context.customColors.attmayGreenComplementary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
