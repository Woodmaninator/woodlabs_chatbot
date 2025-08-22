import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:woodlabs_chatbot/model/profile.dart';
import 'package:woodlabs_chatbot/provider/selected_profile_provider.dart';
import 'package:woodlabs_chatbot/utils/extensions/context_extensions.dart';

class StatusBar extends ConsumerWidget {
  const StatusBar({super.key});

  static const double _spacing = 12.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Profile? selectedProfile = ref.watch(selectedProfileProvider);
    String selectedProfileText = selectedProfile == null
        ? context.localizations.status_bar_active_profile_no_profile
        : "${context.localizations.status_bar_active_profile}: ${selectedProfile.name}";

    return Container(
      height: 24.0,
      decoration: BoxDecoration(color: context.customColors.attmayGreen),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: _spacing,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: context.customColors.white100,
                  width: 1.0,
                ),
              ),
            ),
          ),
          Text(selectedProfileText, style: context.customTextStyles.statusBar),
          const SizedBox(width: _spacing),
          Container(
            width: _spacing,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: context.customColors.white100,
                  width: 1.0,
                ),
              ),
            ),
          ),
          Text(
            "${context.localizations.status_bar_connection_status}: ${context.localizations.status_bar_connection_status_connected}",
            style: context.customTextStyles.statusBar,
          ),
          const SizedBox(width: _spacing),
          Icon(
            TablerIcons.world_off,
            size: 16.0,
            color: context.customColors.white100,
          ),
          const SizedBox(width: _spacing),
        ],
      ),
    );
  }
}
