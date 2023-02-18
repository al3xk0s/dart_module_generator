import 'dart:io';

abstract class FileService {
  Future<void> write(Iterable<String> src, String path);
  Future<List<String>> read(String path);
  Future<bool> existFile(String path);
}

class FileServiceImpl implements FileService {
  final FileMode writeMode;

  const FileServiceImpl(this.writeMode);

  @override
  Future<bool> existFile(String path) {
    return File(path).exists();
  }

  @override
  Future<List<String>> read(String path) {
    return File(path).readAsLines();
  }

  @override
  Future<void> write(Iterable<String> src, String path) {
    final content = src.join('\n');
    return File(path).writeAsString(content, mode: writeMode);
  }
}
