import 'dart:math';

import 'package:module_generator/models/file_info.dart';
import 'package:module_generator/models/module_generator/lib_file_generator.dart';
import 'package:module_generator/models/source/source_file.dart';
import 'package:module_generator/services/file_finder.dart';
import 'package:module_generator/services/file_parser.dart';
import 'package:module_generator/services/file_service.dart';

abstract class ModuleGeneratorModel {
  Future<void> refactor(Uri rootDirectory, {String? libname});
}

class RefactorModelImpl implements ModuleGeneratorModel {
  RefactorModelImpl(this.fileParser, this.fileFinder, this.fileService, this.libFileGenerator);

  final FileParser fileParser;
  final FileFinder fileFinder;
  final FileService fileService;
  final LibFileGenerator libFileGenerator;

  @override
  Future<void> refactor(Uri rootDirectory, {String? libname}) async {
    final filesInfo = await fileFinder.getTargetFiles(rootDirectory);
    final sourceFiles = await _getSourceFiles(filesInfo);

    final filename = await _getFileName(rootDirectory);
    libname ??= filename;

    final libContent = libFileGenerator.generateLibFile(sourceFiles, libname);
    final fileContentPairs = sourceFiles.map((f) => _InfoContentPair(f.info, libFileGenerator.generateSourceFile(f.content, libname!)));

    await Future.wait([
      _writeLibFile(libContent, rootDirectory, filename),
      _writeSourceFiles(fileContentPairs),
    ]);
  }

  String _toDartFile(String filename) => '$filename.dart'; 

  Future<String> _getFileName(Uri rootDirectory) async {
    final f = rootDirectory.toFilePath();
    final name = f.substring(f.lastIndexOf('/') + 1);

    if(await fileService.existFile(_toDartFile(name))) return '$name${Random().nextInt(100)}';
    return name;
  }

  Future<void> _writeLibFile(Iterable<String> libSrc, Uri rootDirectory, String filename) async {
    var path = '${rootDirectory.toFilePath()}/$filename.dart';
    return fileService.write(libSrc, path);
  }

  Future<void> _writeSourceFiles(Iterable<_InfoContentPair> files) async {
    await Future.wait(files.map((f) => fileService.write(f.content, f.info.filePath)));
  }

  Future<List<SourceFile>> _getSourceFiles(List<FileInfo> filesInfo) async {
    final fileRawContentList = await Future.wait(filesInfo.map((i) => fileService.read(i.filePath)));
    return _getFiles(filesInfo, fileRawContentList).toList();
  }

  Iterable<SourceFile> _getFiles(List<FileInfo> filesInfo, List<List<String>> content) sync* {
    if(filesInfo.length != content.length) throw Exception();
    for(int i = 0; i < filesInfo.length; i++) {
      yield SourceFile(filesInfo[i], fileParser.parse(content[i]));
    }
  }
}

class _InfoContentPair {
  final FileInfo info;
  final Iterable<String> content;

  _InfoContentPair(this.info, this.content);
}