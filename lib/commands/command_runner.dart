import 'package:args/command_runner.dart';

import 'generate_copilot_instructions_command.dart';

/// Create a command runner for the CLI application.
CommandRunner<int> createCommandRunner() {
  return CommandRunner<int>('agents_lab', 'CLI tools for agents-lab project')
    // Add all available commands here
    ..addCommand(GenerateCopilotInstructionsCommand());
}
