import 'dart:io';

class FileUtils {
  static Future<void> createDirectories(List<String> paths) async {
    for (var path in paths) {
      final directory = Directory(path);
      if (!(await directory.exists())) {
        await directory.create(recursive: true);
        print('Created directory: $path');
      }
    }
  }

  static Future<void> writeFile(String path, String content) async {
    final file = File(path);
    await file.writeAsString(content);
    print('Wrote file: $path');
  }
}
