import 'dart:math';

import 'package:module_generator/models/file_info.dart';
import 'package:module_generator/models/module_generator/lib_file_generator.dart';
import 'package:module_generator/models/source/source_file.dart';
import 'package:module_generator/services/file_finder.dart';
import 'package:module_generator/services/file_parser.dart';
import 'package:module_generator/services/file_service.dart';

abstract class ModuleGeneratorModel {
  Future<void> refactor(Uri rootDirectory, {String? libname, String? filename});
}

class RefactorModelImpl implements ModuleGeneratorModel {
  RefactorModelImpl(this.fileParser, this.fileFinder, this.fileService, this.libFileGenerator);

  final FileParser fileParser;
  final FileFinder fileFinder;
  final FileService fileService;
  final LibFileGenerator libFileGenerator;

  @override
  Future<void> refactor(Uri rootDirectory, {String? libname, String? filename}) async {
    filename ??= _getFileName(rootDirectory);
    libname ??= filename;

    await _validateFileName(rootDirectory, filename);

    final filesInfo = await fileFinder.getTargetFiles(rootDirectory);
    final sourceFiles = await _getSourceFiles(filesInfo);

    final libContent = libFileGenerator.generateLibFile(sourceFiles, libname);
    final fileContentPairs = sourceFiles.map((f) => _InfoContentPair(f.info, libFileGenerator.generateSourceFile(f.content, libname!)));

    final path = _resolveFile(rootDirectory, filename);

    await Future.wait([
      _writeLibFile(libContent, path),
      _writeSourceFiles(fileContentPairs),
    ]);
  }

  String _toDartFile(String filename) => '$filename.dart'; 

  Future<void> _validateFileName(Uri rootDirectory, String filename) async {
    if(await fileService.existFile(_resolveFile(rootDirectory, filename))) throw Exception('File $filename already exist');
  }

  String _getFileName(Uri rootDirectory) {
    final f = rootDirectory.toFilePath();
    return '${f.substring(f.lastIndexOf('/') + 1)}_api';
  }

  String _resolveFile(Uri rootDirectory, String filename)
    => _toDartFile('${rootDirectory.toFilePath()}/$filename');

  Future<void> _writeLibFile(Iterable<String> libSrc, String filepath) async {
    return fileService.write(libSrc, filepath);
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