import 'dart:io';

import 'package:module_generator/models/file_info.dart';


abstract class FileFinder {
  Future<List<FileInfo>> getTargetFiles(Uri rootDirectory);
}

class FileFinderImpl implements FileFinder {
  @override
  Future<List<FileInfo>> getTargetFiles(Uri rootDirectory) async {
    final root = rootDirectory.toFilePath();
    final paths = await _getTargetFilePaths(root).toList();
    return paths
      .where(_isTargetFile)
      .map((fullpath) => FileInfo(filePath: fullpath, relative: _getRelative(fullpath, root)))
      .toList();
  }

  Stream<String> _getTargetFilePaths(String rootDirectory) async* {
    await for(final entity in Directory(rootDirectory).list()) {
      if(await FileSystemEntity.isDirectory(entity.path)) yield* _getTargetFilePaths(entity.path);
      if(await FileSystemEntity.isFile(entity.path)) yield entity.path;
    }
  }

  String _getRelative(String full, String base) {
    base = base.endsWith('/') ? base : '$base/';
    return full.replaceFirst(base, '');
  }

  bool _isTargetFile(String filepath) {
    const ext = '.dart';
    return filepath.endsWith(ext);
  }
}