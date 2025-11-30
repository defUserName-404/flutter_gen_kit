import 'package:args/command_runner.dart';
import 'package:flutter_gen_kit/src/models/gen_kit_config.dart';
import 'package:flutter_gen_kit/src/services/feature_generation_service.dart';
import 'package:flutter_gen_kit/src/services/user_prompt_service.dart';

/// Command to generate a new feature with the selected architecture.
class FeatureCommand extends Command<void> {
  @override
  final name = 'feature';

  @override
  final description = 'Generates a new feature with the selected architecture.';

  FeatureCommand() {
    argParser.addOption(
      'name',
      abbr: 'n',
      help: 'The name of the feature to generate.',
      mandatory: true,
    );
    argParser.addFlag(
      'interactive',
      abbr: 'i',
      help: 'Enable interactive mode to customize generation options',
      defaultsTo: false,
    );
  }

  @override
  Future<void> run() async {
    final featureName = argResults!['name'] as String;
    final interactive = argResults!['interactive'] as bool;

    // Load config
    final config = await GenKitConfig.load();

    // Get generation options
    final options = interactive
        ? FeatureGenerationOptions.prompt()
        : FeatureGenerationOptions.defaults();

    // Generate feature
    await FeatureGenerationService.generateFeature(
      featureName,
      config,
      options,
    );
  }
}
