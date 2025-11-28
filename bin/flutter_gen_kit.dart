import 'package:args/command_runner.dart';
import 'package:flutter_gen_kit/src/commands/init_command.dart';
import 'package:flutter_gen_kit/src/commands/feature_command.dart';

Future<void> main(List<String> arguments) async {
  final runner = CommandRunner<void>('flutter_gen_kit',
      'A CLI tool to generate Flutter projects with Clean Architecture.')
    ..addCommand(InitCommand())..addCommand(FeatureCommand());

  try {
    await runner.run(arguments);
  } on UsageException catch (e) {
    print(e.message);
    print(e.usage);
  } catch (e) {
    print('An unexpected error occurred: $e');
  }
}
