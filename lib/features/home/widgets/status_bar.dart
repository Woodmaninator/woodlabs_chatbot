import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:woodlabs_chatbot/model/profile.dart';
import 'package:woodlabs_chatbot/provider/current_connection_status_provider.dart';
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

    var connectionStatusString = switch (ref.watch(
      currentConnectionStatusProvider,
    )) {
      ConnectionStatus.connected =>
        "${context.localizations.status_bar_connection_status_connected}: ${selectedProfile?.channel ?? ""}",
      ConnectionStatus.connecting =>
        context.localizations.status_bar_connection_status_connecting,
      ConnectionStatus.disconnected =>
        context.localizations.status_bar_connection_status_disconnected,
      ConnectionStatus.configuration_missing =>
        context.localizations.status_bar_missing_configuration,
      ConnectionStatus.invalid_channel_name =>
        "${context.localizations.status_bar_invalid_channel}: ${selectedProfile?.channel ?? ""}",
    };

    var connectionStatusIcon = switch (ref.watch(
      currentConnectionStatusProvider,
    )) {
      ConnectionStatus.connected => TablerIcons.world,
      ConnectionStatus.connecting => TablerIcons.refresh,
      ConnectionStatus.disconnected => TablerIcons.world_off,
      ConnectionStatus.configuration_missing => TablerIcons.alert_circle,
      ConnectionStatus.invalid_channel_name => TablerIcons.alert_circle,
    };

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
            "${context.localizations.status_bar_connection_status} - $connectionStatusString",
            style: context.customTextStyles.statusBar,
          ),
          const SizedBox(width: _spacing),
          Icon(
            connectionStatusIcon,
            size: 16.0,
            color: context.customColors.white100,
          ),
          const SizedBox(width: _spacing),
        ],
      ),
    );
  }
}
