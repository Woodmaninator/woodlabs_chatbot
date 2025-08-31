import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:woodlabs_chatbot/components/woodlabs_button.dart';
import 'package:woodlabs_chatbot/components/woodlabs_text_area.dart';
import 'package:woodlabs_chatbot/components/woodlabs_text_input.dart';
import 'package:woodlabs_chatbot/components/woodlabs_window.dart';
import 'package:woodlabs_chatbot/model/text_file.dart';
import 'package:woodlabs_chatbot/provider/text_files_provider.dart';
import 'package:woodlabs_chatbot/utils/extensions/context_extensions.dart';

class TextFileEditPage extends ConsumerStatefulWidget {
  final String textFileName; // empty string for new file

  const TextFileEditPage({super.key, required this.textFileName});

  @override
  ConsumerState<TextFileEditPage> createState() => _TextFileEditPageState();
}

class _TextFileEditPageState extends ConsumerState<TextFileEditPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  late String oldName = '';
  late String oldText = '';
  late List<String> existingTextFileNames = [];

  late bool _isEditorValid;

  bool loading = true;

  @override
  void initState() {
    super.initState();

    _initTextFile();

    textController.addListener(() {
      setState(() {
        _isEditorValid = _validateEditor();
      });
    });

    nameController.addListener(() {
      setState(() {
        _isEditorValid = _validateEditor();
      });
    });

    _isEditorValid = _validateEditor();
  }

  Future<void> _initTextFile() async {
    // Read the file if editing an existing one
    if (widget.textFileName.isNotEmpty) {
      var documentDirectory = await getApplicationDocumentsDirectory();
      var filePath =
          '${documentDirectory.path}/${TextFiles.directoryPath}/${widget.textFileName}.txt';

      var content = await File(filePath).readAsString();

      oldName = widget.textFileName;
      oldText = content;

      nameController.text = widget.textFileName;
      textController.text = content;
    }

    var existingFiles = Directory(
      '${(await getApplicationDocumentsDirectory()).path}/${TextFiles.directoryPath}',
    ).listSync().whereType<File>().where((file) => file.path.endsWith('.txt'));

    existingTextFileNames = existingFiles
        .map(
          (file) => file.path
              .split(Platform.pathSeparator)
              .last
              .substring(
                0,
                file.path.split(Platform.pathSeparator).last.length - 4,
              ),
        )
        .where((name) => name != oldName) // Exclude the current file name
        .toList();

    setState(() {
      loading = false;
    });
  }

  bool _validateEditor() {
    if (nameController.text.trim().isEmpty) {
      return false;
    }

    if (textController.text.trim().isEmpty) {
      return false;
    }

    if (existingTextFileNames.contains(nameController.text.trim())) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return WoodlabsWindow(
        child: Center(
          child: CircularProgressIndicator(
            color: context.customColors.attmayGreen,
          ),
        ),
      );
    }

    return WoodlabsWindow(
      child: Center(
        child: Column(
          children: [
            WoodlabsTextInput(
              label: context.localizations.text_file_edit_name,
              hintText: "Jokes",
              controller: nameController,
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: WoodlabsTextArea(
                label: context.localizations.text_file_edit_content,
                hintText: "Two hunters meet - both are dead.",
                controller: textController,
              ),
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
                  onPressed: () => _onSaveTextFile(),
                  isDisabled: !_isEditorValid,
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

  Future<void> _onSaveTextFile() async {
    if (!_isEditorValid) return;

    if (widget.textFileName.isEmpty) {
      // New file
      await ref
          .read(textFilesProvider.notifier)
          .addTextFile(
            TextFile(
              name: nameController.text.trim(),
              lines: textController.text
                  .split('\n')
                  .where((line) => line.isNotEmpty)
                  .toList(),
            ),
          );
    } else {
      await ref
          .read(textFilesProvider.notifier)
          .updateTextFile(
            TextFile(
              name: oldName,
              lines: oldText
                  .split('\n')
                  .where((line) => line.isNotEmpty)
                  .toList(),
            ),
            TextFile(
              name: nameController.text.trim(),
              lines: textController.text
                  .split('\n')
                  .where((line) => line.isNotEmpty)
                  .toList(),
            ),
          );
    }

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  void _onCancel() {
    Navigator.of(context).pop();
  }
}
