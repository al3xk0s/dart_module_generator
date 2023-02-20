import 'dart:math';

import 'package:module_generator/models/file_info.dart';
import 'package:module_generator/models/module_generator/lib_file_generator.dart';
import 'package:module_generator/models/module_generator/module_generation_result.dart';
import 'package:module_generator/models/source/source_file.dart';
import 'package:module_generator/services/file_finder.dart';
import 'package:module_generator/services/file_parser.dart';
import 'package:module_generator/services/file_service.dart';

abstract class ModuleGenerator {
  Future<ModuleGenerationResult> generate(Uri rootDirectory, {String? libname, String? filename});
}

class ModuleGeneratorImpl implements ModuleGenerator {
  ModuleGeneratorImpl(this.fileParser, this.fileFinder, this.fileService, this.libFileGenerator);

  final FileParser fileParser;
  final FileFinder fileFinder;
  final FileService fileService;
  final LibFileGenerator libFileGenerator;

  @override
  Future<ModuleGenerationResult> generate(Uri rootDirectory, {String? libname, String? filename}) async {
    filename ??= _getDefaultFilename();
    libname ??= _getDefaultLibname(rootDirectory);

    await _validateFileName(rootDirectory, filename);

    final filesInfo = await fileFinder.getTargetFiles(rootDirectory);
    final sourceFiles = await _getSourceFiles(filesInfo);

    final libContent = libFileGenerator.generateLibFile(sourceFiles, libname);
    final fileContentPairs = sourceFiles.map((f) => RefactoredSourceFile(f.info, libFileGenerator.generateSourceFile(f.content, libname!)));

    final path = _resolveFile(rootDirectory, filename);

    return ModuleGenerationResult(
      IndexFile(path, libContent),
      fileContentPairs, 
    );
  }

  Future<void> _validateFileName(Uri rootDirectory, String filename) async {
    if(await fileService.existFile(_resolveFile(rootDirectory, filename))) throw Exception('File $filename already exist');
  }

  String _getDefaultFilename() => 'index';

  String _getDefaultLibname(Uri root) {
    final f = root.toFilePath();
    return f.substring(f.lastIndexOf('/') + 1);
  }

  String _resolveFile(Uri rootDirectory, String filename)
    => '${rootDirectory.toFilePath()}/$filename.dart';

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
