const String appProvidersTemplate = r'''
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../core/service_locator.dart';
import '../features/sample_feature/presentation/viewmodels/sample_viewmodel.dart'; // Example

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
