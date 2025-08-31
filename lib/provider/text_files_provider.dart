import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:woodlabs_chatbot/model/text_file.dart';

part 'text_files_provider.g.dart';

@riverpod
class TextFiles extends _$TextFiles {
  static final String directoryPath = 'WoodlabsChatbot/TextFiles';

  @override
  Future<List<TextFile>> build() async {
    // Get the directory where text files are stored (AppData/Local/WoodlabsChatbot/text_files)
    // and load all text files from there.
    final directory = await getApplicationDocumentsDirectory();
    final textFilesDir = '${directory.path}/$directoryPath';
    if (!await Directory(textFilesDir).exists()) {
      await Directory(textFilesDir).create(recursive: true);
    }

    final files = Directory(
      textFilesDir,
    ).listSync().whereType<File>().where((file) => file.path.endsWith('.txt'));

    return files.map((file) {
      final fileName = file.path
          .split(Platform.pathSeparator)
          .last
          .substring(
            0,
            file.path.split(Platform.pathSeparator).last.length - 4,
          );
      final content = file.readAsStringSync();
      final lines = content
          .split('\n')
          .where((line) => line.isNotEmpty)
          .toList();
      return TextFile(name: fileName, lines: lines);
    }).toList();
  }

  Future<void> reload() async {
    state = await AsyncValue.guard(() => build());
  }

  Future<void> updateTextFiles(List<TextFile> textFiles) async {
    state = AsyncValue.data([...textFiles]);

    // Save text files to the directory
    final directory = await getApplicationDocumentsDirectory();
    final textFilesDir = '${directory.path}/$directoryPath';
    if (!await Directory(textFilesDir).exists()) {
      await Directory(textFilesDir).create(recursive: true);
    }
    for (var textFile in textFiles) {
      final filePath = '$textFilesDir/${textFile.name}.txt';
      final file = File(filePath);
      await file.writeAsString(
        textFile.lines.where((line) => line.isNotEmpty).join('\n'),
      );
    }
  }

  Future<void> addTextFile(TextFile textFile) async {
    final currentFiles = state.value ?? [];
    final updatedFiles = [...currentFiles, textFile];
    await updateTextFiles(updatedFiles);
  }

  Future<void> deleteTextFile(TextFile textFile) async {
    final currentFiles = state.value ?? [];
    final updatedFiles = currentFiles
        .where((file) => file.name != textFile.name)
        .toList();
    await updateTextFiles(updatedFiles);

    // Also delete the file from the directory
    final directory = await getApplicationDocumentsDirectory();
    final textFilesDir = '${directory.path}/$directoryPath';
    final filePath = '$textFilesDir/${textFile.name}.txt';
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> updateTextFile(TextFile oldFile, TextFile newFile) async {
    final currentFiles = state.value ?? [];
    final updatedFiles = currentFiles.map((file) {
      if (file.name == oldFile.name) {
        return newFile;
      }
      return file;
    }).toList();
    await updateTextFiles(updatedFiles);

    // Also update the file in the directory
    final directory = await getApplicationDocumentsDirectory();
    final textFilesDir = '${directory.path}/$directoryPath';
    final oldFilePath = '$textFilesDir/${oldFile.name}.txt';
    final newFilePath = '$textFilesDir/${newFile.name}.txt';

    final oldFileObj = File(oldFilePath);
    if (await oldFileObj.exists()) {
      await oldFileObj.delete();
    }

    final newFileObj = File(newFilePath);
    await newFileObj.writeAsString(
      newFile.lines.where((line) => line.isNotEmpty).join('\n'),
    );
  }
}
