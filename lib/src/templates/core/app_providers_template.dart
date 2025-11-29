import '../../models/architecture_config.dart';
import '../../models/gen_kit_config.dart';

String getAppProvidersTemplate(GenKitConfig config) {
  final archConfig = ArchitectureConfig.fromGenKitConfig(config);
  final viewmodelPath = archConfig.getViewModelImportPath('sample');

  return '''
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../core/service_locator.dart';
import '$viewmodelPath'; // Example

class AppProviders {
  static List<SingleChildWidget> providers = [
    // Register global providers here
    ChangeNotifierProvider(
      create: (_) => ServiceLocator.instance<SampleViewModel>(), // Example ViewModel
    ),
    // ... other providers
  ];
}
''';
}
