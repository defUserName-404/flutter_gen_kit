import 'dart:io';

enum Architecture {
  clean,
  mvvm,
}

enum StateManagement {
  provider,
  riverpod,
  bloc,
}

class GenKitConfig {
  final Architecture architecture;
  final StateManagement stateManagement;

  GenKitConfig({
    required this.architecture,
    required this.stateManagement,
  });

  factory GenKitConfig.fromJson(Map<String, dynamic> json) {
    return GenKitConfig(
      architecture: Architecture.values.firstWhere(
        (e) => e.name == json['architecture'],
        orElse: () => Architecture.clean,
      ),
      stateManagement: StateManagement.values.firstWhere(
        (e) => e.name == json['state_management'],
        orElse: () => StateManagement.provider,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'architecture': architecture.name,
      'state_management': stateManagement.name,
    };
  }

  static Future<GenKitConfig> load() async {
    final file = File('gen_kit.yaml');
    if (!await file.exists()) {
      // Default config if not found
      return GenKitConfig(
        architecture: Architecture.clean,
        stateManagement: StateManagement.provider,
      );
    }

    final lines = await file.readAsLines();
    final Map<String, dynamic> json = {};

    for (var line in lines) {
      final parts = line.split(':');
      if (parts.length == 2) {
        json[parts[0].trim()] = parts[1].trim();
      }
    }

    return GenKitConfig.fromJson(json);
  }

  Future<void> save() async {
    final file = File('gen_kit.yaml');
    final buffer = StringBuffer();
    buffer.writeln('architecture: ${architecture.name}');
    buffer.writeln('state_management: ${stateManagement.name}');
    await file.writeAsString(buffer.toString());
  }
}
