import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:woodlabs_chatbot/components/woodlabs_button.dart';
import 'package:woodlabs_chatbot/components/woodlabs_text_input.dart';
import 'package:woodlabs_chatbot/components/woodlabs_window.dart';
import 'package:woodlabs_chatbot/model/configuration.dart';
import 'package:woodlabs_chatbot/provider/current_configuration_provider.dart';
import 'package:woodlabs_chatbot/service/configuration_service.dart';
import 'package:woodlabs_chatbot/utils/extensions/context_extensions.dart';

class ConfigurationPage extends ConsumerStatefulWidget {
  const ConfigurationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfigurationPageState();
}

class _ConfigurationPageState extends ConsumerState<ConfigurationPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController oauthTokenController = TextEditingController();
  final TextEditingController clientIdController = TextEditingController();

  final _controllerTopCenter = ConfettiController(
    duration: const Duration(seconds: 1),
  );
  final _controllerTopRight = ConfettiController(
    duration: const Duration(seconds: 1),
  );
  final _controllerTopLeft = ConfettiController(
    duration: const Duration(seconds: 1),
  );

  bool isEditorValid = false;

  @override
  void initState() {
    super.initState();

    var config = ref.read(currentConfigurationProvider);

    if (config != null) {
      usernameController.text = config.username;
      oauthTokenController.text = config.oauthToken;
      clientIdController.text = config.clientId;
    }

    usernameController.addListener(() {
      setState(() {
        isEditorValid = validateEditor();
      });
    });

    oauthTokenController.addListener(() {
      setState(() {
        isEditorValid = validateEditor();
      });
    });

    clientIdController.addListener(() {
      setState(() {
        isEditorValid = validateEditor();
      });
    });

    isEditorValid = validateEditor();

    // Load existing configuration from storage or environment variables
  }

  bool validateEditor() {
    return usernameController.text.isNotEmpty &&
        oauthTokenController.text.isNotEmpty &&
        clientIdController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WoodlabsWindow(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 128.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                WoodlabsTextInput(
                  label: context.localizations.configuration_username,
                  hintText: "WoodlabsChatbot",
                  controller: usernameController,
                ),
                SizedBox(height: 16),
                WoodlabsTextInput(
                  label: context.localizations.configuration_oauth_token,
                  hintText: "",
                  controller: oauthTokenController,
                  obscureText: true,
                ),
                SizedBox(height: 16),
                WoodlabsTextInput(
                  label: context.localizations.configuration_client_id,
                  hintText: "",
                  controller: clientIdController,
                  obscureText: true,
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
                      onPressed: () => _onSaveConfiguration(),
                      isDisabled: !isEditorValid,
                      isPrimary: true,
                      width: 200,
                      text: context.localizations.save,
                      icon: TablerIcons.device_floppy,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
            confettiController: _controllerTopCenter,
            blastDirectionality: BlastDirectionality.directional,
            blastDirection: -3.14 / 2,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
            ],
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: ConfettiWidget(
            confettiController: _controllerTopRight,
            blastDirectionality: BlastDirectionality.directional,
            blastDirection: -3.14,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
            ],
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: ConfettiWidget(
            confettiController: _controllerTopLeft,
            blastDirectionality: BlastDirectionality.directional,
            blastDirection: 0,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    oauthTokenController.dispose();
    clientIdController.dispose();

    _controllerTopCenter.dispose();
    _controllerTopRight.dispose();
    _controllerTopLeft.dispose();

    super.dispose();
  }

  void _onSaveConfiguration() {
    if (!isEditorValid) return;

    ConfigurationService.saveConfiguration(
      ref,
      Configuration(
        username: usernameController.text,
        oauthToken: oauthTokenController.text,
        clientId: clientIdController.text,
      ),
    );

    _controllerTopCenter.play();
    _controllerTopRight.play();
    _controllerTopLeft.play();
  }
}
