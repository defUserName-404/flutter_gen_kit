extension StringCasingExtension on String {
  String toPascalCase() {
    if (isEmpty) return '';
    return split(RegExp(r'[_-]|\s'))
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
              : '',
        )
        .join();
  }

  String toCamelCase() {
    if (isEmpty) return '';
    final pascalCase = toPascalCase();
    return '${pascalCase[0].toLowerCase()}${pascalCase.substring(1)}';
  }

  String toSnakeCase() {
    if (isEmpty) return '';
    return toLowerCase()
        .replaceAllMapped(
          RegExp(r'[A-Z]'),
          (match) => '_${match.group(0)?.toLowerCase() ?? ''}',
        )
        .replaceAll(RegExp(r'[\s-]'), '_')
        .replaceAll(
          RegExp(r'_{2,}'),
          '_',
        ) // Replace multiple underscores with a single one
        .trimLeft()
        .trimRight();
  }
}
