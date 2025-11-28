import 'dart:io';

class ShellUtils {
  static Future<void> runCommand(String command, List<String> arguments, {String? workingDirectory}) async {
    final process = await Process.run(
      command,
      arguments,
      runInShell: true,
      workingDirectory: workingDirectory,
    );

    if (process.exitCode != 0) {
      print('Error executing command: $command ${arguments.join(' ')}');
      print('Stdout: ${process.stdout}');
      print('Stderr: ${process.stderr}');
      throw Exception('Command failed with exit code ${process.exitCode}');
    } else {
      print('Command output:');
      print(process.stdout);
    }
  }
}