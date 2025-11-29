extension NameExtractionExtension on String {
  String extractBaseName() {
    // Remove suffixes like Model, Entity, Repository, etc.
    return replaceAll(
      RegExp(
        r'(Model|Entity|Repository|ViewModel|Screen|Dto|DataSource|UseCase|Impl)$',
      ),
      '',
    );
  }
}
