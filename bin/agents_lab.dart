import 'dart:io';

import 'package:agents_lab/commands/command_runner.dart';

void main(List<String> args) async {
  // Create the command runner
  final runner = createCommandRunner();

  try {
    // Parse the args and run the command
    final exitCode = await runner.run(args);
    exit(exitCode ?? 0);
  } on FormatException catch (e) {
    // Invalid command usage
    stderr.writeln(e.message);
    stderr.writeln();
    stderr.writeln('Usage: ${runner.executableName} ${runner.usage}');
    exit(64); // Exit code 64 indicates command line usage error
  } catch (e) {
    stderr.writeln('Error: $e');
    exit(1);
  }
}
