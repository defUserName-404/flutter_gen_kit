{{#riverpod}}import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/{{feature_name}}_viewmodel.dart';

class {{feature_pascal}}Screen extends ConsumerStatefulWidget {
  const {{feature_pascal}}Screen({super.key});

  @override
  ConsumerState<{{feature_pascal}}Screen> createState() => _{{feature_pascal}}ScreenState();
}

class _{{feature_pascal}}ScreenState extends ConsumerState<{{feature_pascal}}Screen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read({{feature_camel}}ViewModelProvider.notifier).fetch{{feature_pascal}}Data();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch({{feature_camel}}ViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('{{feature_pascal}} Feature')),
      body: state.when(
        data: (data) {
          if (data == null) return const Center(child: Text('Press button'));
          return Center(child: Text('Data: ${data.name}'));
        },
        error: (err, stack) => Center(child: Text('Error: $err')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read({{feature_camel}}ViewModelProvider.notifier).fetch{{feature_pascal}}Data(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
{{/riverpod}}{{^riverpod}}import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/widgets/loading_indicator.dart';
import '../viewmodels/{{feature_name}}_viewmodel.dart';

class {{feature_pascal}}Screen extends StatefulWidget {
  const {{feature_pascal}}Screen({super.key});

  @override
  State<{{feature_pascal}}Screen> createState() => _{{feature_pascal}}ScreenState();
}

class _{{feature_pascal}}ScreenState extends State<{{feature_pascal}}Screen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<{{feature_pascal}}ViewModel>().fetch{{feature_pascal}}Data();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('{{feature_pascal}} Feature'),
      ),
      body: Consumer<{{feature_pascal}}ViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (viewModel.errorMessage != null) {
            return Center(
              child: Text('Error: ${viewModel.errorMessage}'),
            );
          } else if (viewModel.{{feature_camel}}Data != null) {
            return Center(
              child: Text('Data: ${viewModel.{{feature_camel}}Data!.name}'),
            );
          }
          return const Center(
            child: Text('Press the button to fetch data.'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<{{feature_pascal}}ViewModel>().fetch{{feature_pascal}}Data(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
{{/riverpod}}
