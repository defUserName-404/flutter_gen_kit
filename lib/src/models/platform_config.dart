/// Configuration for platform selection in Flutter project creation.
class PlatformConfig {
  final List<String> platforms;

  const PlatformConfig({required this.platforms});

  /// Whether the user selected specific platforms (vs. all platforms).
  bool get hasCustomPlatforms => platforms.isNotEmpty;

  /// Convert to Flutter create argument format.
  /// Returns the --platforms flag if custom platforms are selected.
  String? toFlutterCreateArg() {
    if (!hasCustomPlatforms) return null;
    return '--platforms=${platforms.join(',')}';
  }

  /// Create from JSON.
  factory PlatformConfig.fromJson(Map<String, dynamic> json) {
    return PlatformConfig(
      platforms: (json['platforms'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  /// Convert to JSON.
  Map<String, dynamic> toJson() {
    return {
      'platforms': platforms,
    };
  }

  /// Default configuration (all platforms).
  factory PlatformConfig.all() => const PlatformConfig(platforms: []);
}
