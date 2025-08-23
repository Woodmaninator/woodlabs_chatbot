import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:woodlabs_chatbot/components/woodlabs_button.dart';
import 'package:woodlabs_chatbot/components/woodlabs_slider.dart';
import 'package:woodlabs_chatbot/components/woodlabs_text_input.dart';
import 'package:woodlabs_chatbot/utils/extensions/context_extensions.dart';

class CommandEditPage extends ConsumerStatefulWidget {
  const CommandEditPage({super.key, required this.commandId});

  final int commandId; // -1 for new command

  @override
  ConsumerState<CommandEditPage> createState() => _CommandEditPageState();
}

class _CommandEditPageState extends ConsumerState<CommandEditPage> {
  final TextEditingController commandController = TextEditingController();
  final TextEditingController responseController = TextEditingController();

  bool isEnabled = true;

  @override
  void initState() {
    if (widget.commandId != -1) {
      // Load command data
      // TODO: load actual data
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 128.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WoodlabsTextInput(
            label: context.localizations.command_edit_command,
            hintText: context.localizations.command_edit_command_hint,
            controller: commandController,
          ),
          const SizedBox(height: 8.0),
          WoodlabsTextInput(
            label: context.localizations.command_edit_response,
            hintText: context.localizations.command_edit_response_hint,
            controller: responseController,
          ),
          const SizedBox(height: 8.0),
          Text(
            context.localizations.command_edit_enabled,
            style: context.customTextStyles.label,
          ),
          const SizedBox(height: 4.0),
          Switch(
            value: isEnabled,
            onChanged: _onEnabledChanged,
            activeTrackColor: context.customColors.attmayGreen,
            activeThumbColor: context.customColors.white100,
          ),
          const SizedBox(height: 8.0),
          WoodlabsSlider(
            min: 0,
            max: 300,
            value: 50,
            onChanged: _onSliderChanged,
            label: context.localizations.command_edit_user_cooldown,
          ),
          const SizedBox(height: 8.0),
          WoodlabsSlider(
            min: 0,
            max: 300,
            value: 50,
            onChanged: _onSliderChanged,
            label: context.localizations.command_edit_global_cooldown,
          ),
          const SizedBox(height: 24.0),
          Divider(
            color: context.customColors.attmayGreen,
            thickness: 1.0,
            height: 0.0,
          ),
          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WoodlabsButton(
                onPressed: () => _onSaveCommand(context),
                isDisabled: true, //TODO: UPDATE LATER
                width: 200,
                text: context.localizations.save,
                icon: TablerIcons.device_floppy,
              ),
              const SizedBox(width: 32.0),
              WoodlabsButton(
                onPressed: () => _onCancelCommand(context),
                isDisabled: false,
                width: 200,
                text: context.localizations.cancel,
                icon: TablerIcons.x,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onEnabledChanged(bool value) {
    setState(() {
      isEnabled = value;
    });
  }

  void _onSliderChanged(double value) {}

  void _onSaveCommand(BuildContext context) {}

  void _onCancelCommand(BuildContext context) {
    context.goRouter.pop();
  }
}
