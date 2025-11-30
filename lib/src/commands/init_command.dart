import 'package:args/command_runner.dart';
import 'package:flutter_gen_kit/src/models/gen_kit_config.dart';
import 'package:flutter_gen_kit/src/services/post_init_setup_service.dart';
import 'package:flutter_gen_kit/src/services/project_creation_service.dart';
import 'package:flutter_gen_kit/src/services/user_prompt_service.dart';

/// Command to initialize a new Flutter project with best practices.
class InitCommand extends Command<void> {
  @override
  final name = 'init';
  
  @override
  final description =
      'Initializes a new Flutter project with Clean Architecture and other best practices.';

  InitCommand() {
    argParser.addOption(
      'name',
      abbr: 'n',
      help: 'The name of the Flutter project to create.',
      mandatory: true,
    );
  }

  @override
  Future<void> run() async {
    final projectName = argResults!['name'] as String;

    print('Initializing new Flutter project: $projectName...\n');

    // Gather configuration from user
    final platforms = UserPromptService.promptPlatforms();
    final architecture = UserPromptService.promptArchitecture();
    final stateManagement = UserPromptService.promptStateManagement();

    final config = GenKitConfig(
      architecture: architecture,
      stateManagement: stateManagement,
      platformConfig: platforms,
    );

    // Create Flutter project
    await ProjectCreationService.createFlutterProject(projectName, platforms);

    // Save configuration
    await config.save();
    print('Configuration saved to gen_kit.yaml');

    // Apply architectural setup
    await ProjectCreationService.setupArchitecture(projectName, config);

    // Install dependencies
    await ProjectCreationService.installDependencies(config);

    print('\nProject "$projectName" initialized successfully!');

    // Post-initialization interactive setup
    await PostInitSetupService.runAllSetups();
  }
}
