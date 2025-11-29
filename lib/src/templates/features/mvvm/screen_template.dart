import '../../../models/gen_kit_config.dart';

String getSampleMVVMScreenTemplate(GenKitConfig config) {
  if (config.stateManagement == StateManagement.riverpod) {
    return r'''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/sample_feature_viewmodel.dart';

class SampleScreen extends ConsumerStatefulWidget {
  const SampleScreen({super.key});

  @override
  ConsumerState<SampleScreen> createState() => _SampleScreenState();
}

class _SampleScreenState extends ConsumerState<SampleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sampleViewModelProvider.notifier).fetchSampleData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sampleViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('MVVM Feature')),
      body: state.when(
        data: (data) {
          if (data == null) return const Center(child: Text('Press button'));
          return Center(child: Text('Data: ${data.name}'));
        },
        error: (err, stack) => Center(child: Text('Error: $err')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            ref.read(sampleViewModelProvider.notifier).fetchSampleData(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
''';
  }

  // Default Provider
  return r'''
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/sample_feature_viewmodel.dart';

class SampleScreen extends StatefulWidget {
  const SampleScreen({super.key});

  @override
  State<SampleScreen> createState() => _SampleScreenState();
}

class _SampleScreenState extends State<SampleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SampleViewModel>().fetchSampleData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MVVM Feature'),
      ),
      body: Consumer<SampleViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (viewModel.errorMessage != null) {
            return Center(
              child: Text('Error: ${viewModel.errorMessage}'),
            );
          } else if (viewModel.sampleData != null) {
            return Center(
              child: Text('Data: ${viewModel.sampleData!.name}'),
            );
          }
          return const Center(
            child: Text('Press the button to fetch data.'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<SampleViewModel>().fetchSampleData(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
''';
}
