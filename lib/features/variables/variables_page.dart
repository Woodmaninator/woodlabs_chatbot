import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:woodlabs_chatbot/components/woodlabs_button.dart';
import 'package:woodlabs_chatbot/components/woodlabs_icon_button.dart';
import 'package:woodlabs_chatbot/components/woodlabs_text_input.dart';
import 'package:woodlabs_chatbot/components/woodlabs_window.dart';
import 'package:woodlabs_chatbot/features/variables/widgets/variable_banner.dart';
import 'package:woodlabs_chatbot/model/variable.dart';
import 'package:woodlabs_chatbot/provider/variables_provider.dart';
import 'package:woodlabs_chatbot/router/routes.dart';
import 'package:woodlabs_chatbot/service/variable_service.dart';
import 'package:woodlabs_chatbot/utils/extensions/context_extensions.dart';

class VariablesPage extends ConsumerStatefulWidget {
  const VariablesPage({super.key});

  @override
  ConsumerState<VariablesPage> createState() => _VariablesPageState();
}

class _VariablesPageState extends ConsumerState<VariablesPage> {
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
    var variables = ref.watch(variablesProvider);

    // Filter commands based on the text input
    var filteredVariables = variables.where((variable) {
      if (filterController.text.isEmpty) {
        return true;
      }

      return variable.name.toLowerCase().contains(
        filterController.text.toLowerCase(),
      );
    }).toList();

    var variableBanners = <Widget>[];
    for (int i = 0; i < filteredVariables.length; i++) {
      var variable = filteredVariables.elementAt(i);
      variableBanners.add(
        Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16,
            bottom: i == filteredVariables.length - 1 ? 0 : 8.0,
          ),
          child: VariableBanner(
            variable: variable,
            onDelete: () => {_onVariableDelete(context, variable)},
            onEdit: () => {_onVariableEdit(context, variable)},
          ),
        ),
      );
    }

    return WoodlabsWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: WoodlabsTextInput(
                  label: context.localizations.variables_filter,
                  hintText: "",
                  controller: filterController,
                ),
              ),
              const SizedBox(width: 16.0),
              WoodlabsIconButton(
                onPressed: () => _onAddVariable(context),
                icon: TablerIcons.plus,
                backgroundColor: context.customColors.attmayGreen,
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
              child: Scrollbar(
                controller: scrollController,
                child: ListView(
                  controller: scrollController,
                  children: [
                    SizedBox(height: 8.0),
                    ...variableBanners,
                    SizedBox(height: 8.0),
                  ],
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

  void _onAddVariable(BuildContext context) {
    NewVariableRoute().go(context);
  }

  void _onVariableDelete(BuildContext context, Variable variable) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: EdgeInsets.all(16.0),
          title: Text(
            context.localizations.variable_delete_title,
            style: context.customTextStyles.navigationBar,
          ),
          content: Text(
            context.localizations.variable_delete_text,
            style: context.customTextStyles.bodyRegular,
          ),
          backgroundColor: context.customColors.backgroundMedium,
          actions: [
            WoodlabsButton(
              icon: TablerIcons.trash,
              text: context.localizations.delete,
              isPrimary: false,
              isDisabled: false,
              width: 150,
              onPressed: () {
                VariableService.deleteVariable(ref, variable.id);
                Navigator.of(context).pop();
              },
            ),
            WoodlabsButton(
              icon: TablerIcons.x,
              text: context.localizations.cancel,
              isPrimary: true,
              isDisabled: false,
              width: 150,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onVariableEdit(BuildContext context, Variable variable) {
    EditVariableRoute(variableId: variable.id).go(context);
  }
}
