import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:woodlabs_chatbot/components/woodlabs_button.dart';
import 'package:woodlabs_chatbot/components/woodlabs_text_input.dart';
import 'package:woodlabs_chatbot/components/woodlabs_window.dart';
import 'package:woodlabs_chatbot/features/profiles/widgets/profile_icon_picker.dart';
import 'package:woodlabs_chatbot/model/command.dart';
import 'package:woodlabs_chatbot/model/profile.dart';
import 'package:woodlabs_chatbot/model/variable.dart';
import 'package:woodlabs_chatbot/provider/profiles_provider.dart';
import 'package:woodlabs_chatbot/service/profile_service.dart';
import 'package:woodlabs_chatbot/utils/extensions/context_extensions.dart';

class ProfileEditPage extends ConsumerStatefulWidget {
  final int profileId; // -1 for new profile

  const ProfileEditPage({super.key, required this.profileId});

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController channelController = TextEditingController();

  late ProfileIcon icon;

  late List<Command> commands;
  late List<Variable> variables;

  bool isEditorValid = false;

  @override
  void initState() {
    commands = [];
    variables = [];

    if (widget.profileId != -1) {
      // Load profile data
      var profile = ref
          .read(profilesProvider)
          .firstWhere((p) => p.id == widget.profileId);

      nameController.text = profile.name;
      channelController.text = profile.channel;
      icon = profile.icon;
      commands = profile.commands;
      variables = profile.variables;
    } else {
      icon = ProfileIcon.user;
    }

    nameController.addListener(() {
      setState(() {
        isEditorValid = _getValidity();
      });
    });

    channelController.addListener(() {
      setState(() {
        isEditorValid = _getValidity();
      });
    });

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
              label: context.localizations.profile_edit_profile_name,
              hintText: "",
              controller: nameController,
            ),
            SizedBox(height: 16.0),
            WoodlabsTextInput(
              label: context.localizations.profile_edit_channel_name,
              hintText: "",
              controller: channelController,
            ),
            SizedBox(height: 16.0),
            ProfileIconPicker(
              onIconSelected: _onIconSelected,
              selectedIcon: icon,
              label: context.localizations.profile_edit_icon,
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
                  onPressed: () => _onSaveProfile(),
                  isDisabled: !isEditorValid,
                  isPrimary: true,
                  width: 200,
                  text: context.localizations.save,
                  icon: TablerIcons.device_floppy,
                ),
                const SizedBox(width: 32.0),
                WoodlabsButton(
                  onPressed: () => _onCancel(),
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
    // check name is not empty
    if (nameController.text.trim().isEmpty) {
      return false;
    }

    // check channel not empty
    if (channelController.text.trim().isEmpty) {
      return false;
    }

    return true;
  }

  void _onIconSelected(ProfileIcon selectedIcon) {
    setState(() {
      icon = selectedIcon;
    });
  }

  void _onSaveProfile() {
    if (!_getValidity()) return;

    var profile = Profile(
      id: widget.profileId,
      name: nameController.text.trim(),
      channel: channelController.text.trim(),
      icon: icon,
      commands: commands,
      variables: variables,
    );

    if (widget.profileId == -1) {
      // New profile
      ProfileService.addProfile(ref, profile);
    } else {
      // Update existing profile
      ProfileService.updateProfile(ref, profile);
    }

    context.goRouter.pop();
  }

  void _onCancel() {
    context.goRouter.pop();
  }
}
