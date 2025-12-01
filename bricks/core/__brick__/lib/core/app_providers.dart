{{#bloc}}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

import 'service_locator.dart';
// import '../features/sample_feature/presentation/bloc/sample_bloc.dart'; // Example

class AppProviders {
  static List<BlocProvider> providers = [
    // Register global Blocs here
    // BlocProvider(create: (_) => ServiceLocator.instance<SampleBloc>()),
  ];
}
{{/bloc}}
{{^bloc}}
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'service_locator.dart';
import '../features/sample_feature/presentation/viewmodels/sample_viewmodel.dart';

class AppProviders {
  static List<SingleChildWidget> providers = [
    // Register global providers here
    ChangeNotifierProvider(
      create: (_) => ServiceLocator.instance<SampleViewModel>(),
    ),
    // ... other providers
  ];
}
{{/bloc}}
