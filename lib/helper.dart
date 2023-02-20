import 'dart:io';

import 'package:module_generator/exceptions/fs_exceptions.dart';
import 'package:path/path.dart' as p;

class PathHelper {
  const PathHelper();

  String resolve(String root, String file) => p.join(root.toString(), file);
  String canonicalize(String path) => p.canonicalize(path);
  String relative(String root, String fullpath) => p.relative(fullpath, from: root);
  String extention(String path) => p.extension(path);
  String basename(String root) => p.basename(root);

  Future<String?> getProjectRootDirectory(String currentRoot) {
    String rootPrefix = p.rootPrefix(currentRoot);
    return _getProjectRootDirectory(currentRoot, rootPrefix);
  }

  Future<String?> _getProjectRootDirectory(String rootDirectory, String rootPrefix) async {
    await for(final entity in Directory(rootDirectory).list()) {
      if(await FileSystemEntity.isFile(entity.path)) {
        if(basename(entity.path) == 'pubspec.yaml') return rootDirectory;        
      }
    }
    if(rootDirectory == rootPrefix) return null;
    return _getProjectRootDirectory(p.dirname(rootDirectory), rootPrefix);
  }

  String getRelativeProjectPath(String importString) {
    
    final 
  }

  String toDartStandart(String path) {
    return p.posix.normalize(path);
  }
}

PathHelper createPathHelper() => const PathHelper();