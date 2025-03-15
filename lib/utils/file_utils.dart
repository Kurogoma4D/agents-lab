import 'dart:io';
import 'package:path/path.dart' as path;

/// Utility class for file operations.
class FileUtils {
  /// Reads all markdown files from the given directory.
  ///
  /// Returns a map of file names to file contents.
  static Future<Map<String, String>> readMarkdownFiles(
    String directoryPath,
  ) async {
    final directory = Directory(directoryPath);
    if (!await directory.exists()) {
      throw Exception('Directory not found: $directoryPath');
    }

    final files =
        await directory
            .list()
            .where(
              (entity) =>
                  entity is File &&
                  path.extension(entity.path).toLowerCase() == '.md',
            )
            .cast<File>()
            .toList();

    // Sort files by name to maintain order
    files.sort(
      (a, b) => path.basename(a.path).compareTo(path.basename(b.path)),
    );

    final result = <String, String>{};
    for (final file in files) {
      final content = await file.readAsString();
      result[path.basename(file.path)] = content;
    }

    return result;
  }

  /// Creates a directory if it doesn't exist.
  static Future<void> createDirectoryIfNotExists(String directoryPath) async {
    final directory = Directory(directoryPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
  }

  /// Writes content to a file, creating directories as needed.
  static Future<void> writeToFile(String filePath, String content) async {
    final directory = path.dirname(filePath);
    await createDirectoryIfNotExists(directory);

    final file = File(filePath);
    await file.writeAsString(content);
  }
}
