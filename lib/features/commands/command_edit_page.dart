import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:woodlabs_chatbot/components/woodlabs_button.dart';
import 'package:woodlabs_chatbot/components/woodlabs_combobox.dart';
import 'package:woodlabs_chatbot/components/woodlabs_slider.dart';
import 'package:woodlabs_chatbot/components/woodlabs_text_input.dart';
import 'package:woodlabs_chatbot/components/woodlabs_window.dart';
import 'package:woodlabs_chatbot/model/command.dart';
import 'package:woodlabs_chatbot/service/command_service.dart';
import 'package:woodlabs_chatbot/utils/extensions/context_extensions.dart';

import '../../provider/commands_provider.dart';

class CommandEditPage extends ConsumerStatefulWidget {
  const CommandEditPage({super.key, required this.commandId});

  final int commandId; // -1 for new command

  @override
  ConsumerState<CommandEditPage> createState() => _CommandEditPageState();
}

class _CommandEditPageState extends ConsumerState<CommandEditPage> {
  final TextEditingController commandController = TextEditingController();
  final TextEditingController responseController = TextEditingController();
  final TextEditingController specificUsersController = TextEditingController();

  late bool isEnabled;
  late CommandPermissionType permissionType;
  late CommandTriggerType triggerType;
  late int userCooldown;
  late int globalCooldown;

  bool isEditorValid = false;

  @override
  void initState() {
    if (widget.commandId != -1) {
      // Load command data
      var command = ref
          .read(commandsProvider)
          .firstWhere((cmd) => cmd.id == widget.commandId);

      commandController.text = command.command;
      responseController.text = command.response;
      specificUsersController.text = command.specificUsers.isNotEmpty
          ? command.specificUsers[0]
          : "";
      permissionType = command.permissionType;
      triggerType = command.triggerType;
      userCooldown = command.userCooldown;
      globalCooldown = command.globalCooldown;
      isEnabled = command.isEnabled;
    } else {
      isEnabled = true;
      permissionType = CommandPermissionType.everyone;
      triggerType = CommandTriggerType.startsWith;
      userCooldown = 0;
      globalCooldown = 30;
    }

    commandController.addListener(() {
      setState(() {
        isEditorValid = _getValidity();
      });
    });

    responseController.addListener(() {
      setState(() {
        isEditorValid = _getValidity();
      });
    });

    specificUsersController.addListener(() {
      setState(() {
        isEditorValid = _getValidity();
      });
    });

    isEditorValid = _getValidity();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WoodlabsWindow(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 128.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WoodlabsTextInput(
              label: context.localizations.command_edit_command,
              hintText: context.localizations.command_edit_command_hint,
              controller: commandController,
            ),
            const SizedBox(height: 8.0),
            WoodlabsComboBox(
              items: CommandTriggerType.values,
              itemLabels: getCommandTriggerTypeNames(context),
              label: context.localizations.command_edit_trigger,
              selectedItem: triggerType,
              onChanged: _onTriggerTypeChanged,
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
              value: userCooldown.toDouble(),
              onChanged: _onUserCooldownChanged,
              label: context.localizations.command_edit_user_cooldown,
            ),
            const SizedBox(height: 8.0),
            WoodlabsSlider(
              min: 0,
              max: 300,
              value: globalCooldown.toDouble(),
              onChanged: _onGlobalCooldownChanged,
              label: context.localizations.command_edit_global_cooldown,
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: WoodlabsComboBox(
                    items: CommandPermissionType.values,
                    itemLabels: getCommandPermissionTypeNames(context),
                    selectedItem: permissionType,
                    label: context.localizations.command_edit_permission,
                    onChanged: _onPermissionTypeChanged,
                  ),
                ),
                const SizedBox(width: 32.0),
                Flexible(
                  flex: 1,
                  child: permissionType == CommandPermissionType.specificUsers
                      ? WoodlabsTextInput(
                          label: context
                              .localizations
                              .command_permission_type_specific_users,
                          controller: specificUsersController,
                          hintText: "Woodmaninator",
                        )
                      : const SizedBox.shrink(),
                ),
              ],
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
                  onPressed: () => _onSaveCommand(),
                  isDisabled: !isEditorValid,
                  isPrimary: true,
                  width: 200,
                  text: context.localizations.save,
                  icon: TablerIcons.device_floppy,
                ),
                const SizedBox(width: 32.0),
                WoodlabsButton(
                  onPressed: () => _onCancelCommand(),
                  isDisabled: false,
                  width: 200,
                  text: context.localizations.cancel,
                  icon: TablerIcons.x,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _getValidity() {
    // Check if command not empty
    if (commandController.text.trim().isEmpty) {
      return false;
    }

    // Check if response not empty
    if (responseController.text.trim().isEmpty) {
      return false;
    }

    if (permissionType == CommandPermissionType.specificUsers &&
        specificUsersController.text.trim().isEmpty) {
      return false;
    }

    return true;
  }

  void _onEnabledChanged(bool value) {
    setState(() {
      isEnabled = value;
      isEditorValid = _getValidity();
    });
  }

  void _onUserCooldownChanged(double value) {
    setState(() {
      userCooldown = value.round();
      isEditorValid = _getValidity();
    });
  }

  void _onGlobalCooldownChanged(double value) {
    setState(() {
      globalCooldown = value.round();
      isEditorValid = _getValidity();
    });
  }

  void _onPermissionTypeChanged(CommandPermissionType value) {
    setState(() {
      permissionType = value;
      isEditorValid = _getValidity();
    });
  }

  void _onTriggerTypeChanged(CommandTriggerType value) {
    setState(() {
      triggerType = value;
      isEditorValid = _getValidity();
    });
  }

  void _onSaveCommand() {
    if (!isEditorValid) return;

    Command newCommand = Command(
      id: widget.commandId,
      command: commandController.text.trim(),
      response: responseController.text.trim(),
      isEnabled: isEnabled,
      userCooldown: userCooldown,
      globalCooldown: globalCooldown,
      permissionType: permissionType,
      specificUsers: [specificUsersController.text.trim()],
      triggerType: triggerType,
    );

    if (widget.commandId == -1) {
      CommandService.addCommand(ref, newCommand);
    } else {
      CommandService.updateCommand(ref, newCommand);
    }

    context.goRouter.pop();
  }

  void _onCancelCommand() {
    context.goRouter.pop();
  }

  @override
  void dispose() {
    commandController.dispose();
    responseController.dispose();
    specificUsersController.dispose();

    super.dispose();
  }
}
