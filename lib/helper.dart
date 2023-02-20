import 'dart:io';

import 'package:module_generator/exceptions/fs_exceptions.dart';
import 'package:path/path.dart' as p;

class PathHelper {
  const PathHelper();

  String resolve(String root, String file) {
    return p.join(root.toString(), file);
  }

  String canonicalize(String path) {
    return p.canonicalize(path);
  }

  String relative(String root, String fullpath) {
    return p.relative(fullpath, from: root);
  }

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

  String extention(String path) {
    
    return p.extension(path);
  }

  String getRelativeProjectPath(String importString) {
    
  }

  String toDartStandart(String path) {
    
  }
}

PathHelper createPathHelper() => const PathHelper();