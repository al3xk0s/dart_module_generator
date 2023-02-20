import 'dart:io';

import 'package:module_generator/exceptions/fs_exceptions.dart';
import 'package:module_generator/helper.dart';
import 'package:module_generator/models/file/file_info.dart';
import 'package:module_generator/services/file_info_parser.dart';

class FileFoundResult {
  const FileFoundResult(this.projectRoot, this.fileInfoList, this.moduleRoot);

  final String? projectRoot;
  final String moduleRoot;
  final List<FileInfo> fileInfoList;
}

abstract class FileFinder {
  Future<FileFoundResult> getTargetFiles(String rootDirectory);
}

class FileFinderImpl implements FileFinder {
  const FileFinderImpl(this.pathHelper, this.infoParser);

  final PathHelper pathHelper;
  final FileInfoParser infoParser;

  @override
  Future<FileFoundResult> getTargetFiles(String rootDirectory) async {
    final projectRoot = await pathHelper.getProjectRootDirectory(rootDirectory);
    final paths = await _getAllFilePaths(rootDirectory).toList();
    final fileInfoList = paths
      .where(_isTargetFile)
      .map((fullpath) => infoParser.parse(projectRoot, rootDirectory, fullpath))
      .toList();

    return FileFoundResult(
      projectRoot,
      fileInfoList,
      rootDirectory,
    );
  }

  Stream<String> _getAllFilePaths(String rootDirectory) async* {
    await for(final entity in Directory(rootDirectory).list()) {
      if(await FileSystemEntity.isDirectory(entity.path)) yield* _getAllFilePaths(entity.path);
      if(await FileSystemEntity.isFile(entity.path)) yield entity.path;
    }
  }

  bool _isTargetFile(String filepath) {
    const ext = '.dart';
    return pathHelper.extention(filepath) == ext;
  }
}