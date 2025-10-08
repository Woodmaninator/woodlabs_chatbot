import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:woodlabs_chatbot/components/woodlabs_button.dart';
import 'package:woodlabs_chatbot/components/woodlabs_icon_button.dart';
import 'package:woodlabs_chatbot/components/woodlabs_text_input.dart';
import 'package:woodlabs_chatbot/components/woodlabs_window.dart';
import 'package:woodlabs_chatbot/features/textFiles/widgets/text_file_banner.dart';
import 'package:woodlabs_chatbot/model/text_file.dart';
import 'package:woodlabs_chatbot/provider/text_files_provider.dart';
import 'package:woodlabs_chatbot/router/routes.dart';
import 'package:woodlabs_chatbot/utils/extensions/context_extensions.dart';

class TextFilesPage extends ConsumerStatefulWidget {
  const TextFilesPage({super.key});

  @override
  ConsumerState<TextFilesPage> createState() => _TextFilesPageState();
}

class _TextFilesPageState extends ConsumerState<TextFilesPage> {
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
    var textFiles = ref.watch(textFilesProvider).value;

    if (textFiles == null) {
      return WoodlabsWindow(
        child: Center(
          child: CircularProgressIndicator(
            color: context.customColors.attmayGreen,
          ),
        ),
      );
    }

    var filteredTextFiles = textFiles.where((textFile) {
      var filter = filterController.text.trim().toLowerCase();
      if (filter.isEmpty) {
        return true;
      }
      return textFile.name.toLowerCase().contains(filter);
    }).toList();

    filteredTextFiles.sort((a, b) => a.name.compareTo(b.name));

    var textFileBanners = <Widget>[];
    for (int i = 0; i < filteredTextFiles.length; i++) {
      var textFile = filteredTextFiles.elementAt(i);
      textFileBanners.add(
        Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16,
            bottom: i == filteredTextFiles.length - 1 ? 0 : 8.0,
          ),
          child: TextFileBanner(
            textFile: textFile.name,
            onEdit: () => {_onTextFileEdit(context, textFile)},
            onDelete: () => {_onTextFileDelete(context, textFile)},
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
                  label: context.localizations.text_files_filter,
                  hintText: "",
                  controller: filterController,
                ),
              ),
              const SizedBox(width: 16.0),
              WoodlabsIconButton(
                onPressed: () => _onAddTextFile(context),
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
                    ...textFileBanners,
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

  void _onTextFileEdit(BuildContext context, TextFile textFile) {
    EditTextFileRoute(fileName: textFile.name).go(context);
  }

  void _onAddTextFile(BuildContext context) {
    NewTextFileRoute().go(context);
  }

  void _onTextFileDelete(BuildContext context, TextFile textFile) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: EdgeInsets.all(16.0),
          title: Text(
            context.localizations.text_file_delete_title,
            style: context.customTextStyles.navigationBar,
          ),
          content: Text(
            context.localizations.text_file_delete_text,
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
              onPressed: () async {
                await ref
                    .read(textFilesProvider.notifier)
                    .deleteTextFile(textFile);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
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
}
