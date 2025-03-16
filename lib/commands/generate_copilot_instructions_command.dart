import 'dart:io';
import 'package:args/command_runner.dart';
import '../utils/file_utils.dart';
import 'package:path/path.dart' as path;

/// A command to generate copilot instructions by merging markdown files from .github/rules.
class GenerateCopilotInstructionsCommand extends Command<int> {
  @override
  final name = 'generate-copilot-instructions';

  @override
  final description =
      'Generate copilot instructions by merging markdown files from .github/rules';

  GenerateCopilotInstructionsCommand() {
    argParser
      ..addOption(
        'source-dir',
        abbr: 's',
        help: 'Source directory containing markdown files to merge',
        defaultsTo: '.github/rules',
      )
      ..addOption(
        'output-file',
        abbr: 'o',
        help: 'Output file path for the generated instructions',
        defaultsTo: '.github/copilot-instructions.md',
      )
      ..addFlag(
        'include-filenames',
        abbr: 'i',
        help: 'Whether to include original filenames as headers',
        defaultsTo: false,
      )
      ..addOption(
        'separator',
        help: 'Separator to insert between content from different files',
        defaultsTo: '\n\n',
      );
  }

  @override
  Future<int> run() async {
    final sourceDir = argResults!['source-dir'] as String;
    final outputFile = argResults!['output-file'] as String;
    final includeFilenames = argResults!['include-filenames'] as bool;
    final separator = argResults!['separator'] as String;

    try {
      // Read all markdown files from source directory
      print('Reading markdown files from $sourceDir...');
      final filesContent = await FileUtils.readMarkdownFiles(sourceDir);

      if (filesContent.isEmpty) {
        stderr.writeln('No markdown files found in $sourceDir');
        return 1;
      }

      print('Found ${filesContent.length} markdown files');

      // Merge file contents
      final buffer = StringBuffer();
      var isFirst = true;

      for (final entry in filesContent.entries) {
        if (!isFirst) {
          buffer.write(separator);
        }
        isFirst = false;

        if (includeFilenames) {
          final filename = path.basenameWithoutExtension(entry.key);
          buffer.writeln('# $filename\n');
        }

        buffer.write(entry.value.trim());
      }

      // Write the merged content to the output file
      print('Writing merged content to $outputFile...');
      await FileUtils.writeToFile(outputFile, buffer.toString());

      print('Successfully merged ${filesContent.length} files to $outputFile');
      return 0;
    } catch (e) {
      stderr.writeln('Error: $e');
      return 1;
    }
  }
}
