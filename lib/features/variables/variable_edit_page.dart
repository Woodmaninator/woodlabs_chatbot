import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:woodlabs_chatbot/components/woodlabs_button.dart';
import 'package:woodlabs_chatbot/components/woodlabs_text_input.dart';
import 'package:woodlabs_chatbot/components/woodlabs_window.dart';
import 'package:woodlabs_chatbot/model/variable.dart';
import 'package:woodlabs_chatbot/provider/variables_provider.dart';
import 'package:woodlabs_chatbot/service/variable_service.dart';
import 'package:woodlabs_chatbot/utils/extensions/context_extensions.dart';

class VariableEditPage extends ConsumerStatefulWidget {
  final int variableId; // -1 for new variable

  const VariableEditPage({super.key, required this.variableId});

  @override
  ConsumerState<VariableEditPage> createState() => _VariableEditPageState();
}

class _VariableEditPageState extends ConsumerState<VariableEditPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController valueController = TextEditingController();

  bool isEditorValid = false;

  @override
  void initState() {
    if (widget.variableId != -1) {
      // Load variable data
      var variable = ref
          .read(variablesProvider)
          .firstWhere((v) => v.id == widget.variableId);

      nameController.text = variable.name;
      valueController.text = variable.value.toString();
    }

    nameController.addListener(() {
      setState(() {
        isEditorValid = _getValidity();
      });
    });

    valueController.addListener(() {
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
        padding: const EdgeInsets.symmetric(horizontal: 128.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WoodlabsTextInput(
              label: context.localizations.variable_edit_name,
              hintText: "ragecount",
              controller: nameController,
            ),
            const SizedBox(height: 8.0),
            WoodlabsTextInput(
              label: context.localizations.variable_edit_value,
              hintText: "24",
              controller: valueController,
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
                  onPressed: () => _onSaveVariable(),
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
    return nameController.text.trim().isNotEmpty &&
        valueController.text.trim().isNotEmpty &&
        int.tryParse(valueController.text.trim()) != null;
  }

  void _onSaveVariable() {
    if (!isEditorValid) return;

    Variable newVariable = Variable(
      id: widget.variableId,
      value: int.parse(valueController.text.trim()),
      name: nameController.text.trim(),
    );

    if (widget.variableId == -1) {
      VariableService.addVariable(ref, newVariable);
    } else {
      VariableService.updateVariable(ref, newVariable);
    }

    context.goRouter.pop();
  }

  void _onCancel() {
    Navigator.of(context).pop();
  }
}
