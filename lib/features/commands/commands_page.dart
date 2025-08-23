import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:woodlabs_chatbot/components/woodlabs_icon_button.dart';
import 'package:woodlabs_chatbot/components/woodlabs_text_input.dart';
import 'package:woodlabs_chatbot/features/commands/widgets/command_banner.dart';
import 'package:woodlabs_chatbot/model/command.dart';
import 'package:woodlabs_chatbot/provider/commands_provider.dart';
import 'package:woodlabs_chatbot/utils/extensions/context_extensions.dart';

class CommandsPage extends ConsumerStatefulWidget {
  const CommandsPage({super.key});

  @override
  ConsumerState<CommandsPage> createState() => _CommandsPageState();
}

class _CommandsPageState extends ConsumerState<CommandsPage> {
  final TextEditingController filterController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    filterController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var commands = ref.watch(commandsProvider);

    // Filter commands based on the text input
    var filteredCommands = commands.where((command) {
      if (filterController.text.isEmpty) {
        return true;
      }

      return command.command.toLowerCase().contains(
        filterController.text.toLowerCase(),
      );
    }).toList();

    filteredCommands = [...filteredCommands];

    //TODO: DELETE THIS
    if (filteredCommands.isNotEmpty) {
      for (int i = 0; i < 20; i++) {
        filteredCommands.add(filteredCommands[0]);
      }
    }

    var commandBanners = <Widget>[];
    for (int i = 0; i < filteredCommands.length; i++) {
      var command = filteredCommands.elementAt(i);
      commandBanners.add(
        Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16,
            bottom: i == filteredCommands.length - 1 ? 0 : 8.0,
          ),
          child: CommandBanner(
            command: command.command,
            response: command.response,
            isEnabled: command.isEnabled,
            onActiveChanged: (value) =>
                _onCommandActiveChanged(context, command, value),
            onDelete: () => {_onCommandDelete(context, command)},
            onEdit: () => {_onCommandEdit(context, command)},
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: WoodlabsTextInput(
                  label: context.localizations.commands_filter,
                  hintText: "",
                  controller: filterController,
                ),
              ),
              const SizedBox(width: 16.0),
              WoodlabsIconButton(
                onPressed: () => _onAddCommand(context),
                icon: TablerIcons.plus,
                backgroundColor: context.customColors.backgroundMedium,
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColors.backgroundLight,
                borderRadius: BorderRadius.circular(16.0),
                border: BoxBorder.fromBorderSide(
                  BorderSide(
                    color: context.customColors.attmayGreen,
                    width: 1.0,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Scrollbar(
                  controller: scrollController,
                  child: ListView(
                    controller: scrollController,
                    children: [...commandBanners],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    filterController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _onAddCommand(BuildContext context) {
    context.go('/commands/new');
  }

  void _onCommandActiveChanged(
    BuildContext context,
    Command command,
    bool value,
  ) {
    setState(() {
      command.isEnabled = value;
    });
  }

  void _onCommandDelete(BuildContext context, Command command) {}
  void _onCommandEdit(BuildContext context, Command command) {}
}
