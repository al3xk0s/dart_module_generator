import 'dart:io';

import 'package:module_generator/exceptions/fs_exceptions.dart';
import 'package:module_generator/helper.dart';
import 'package:module_generator/models/file/file_info.dart';
import 'package:module_generator/models/module_generator/lib_file_generator.dart';
import 'package:module_generator/models/module_generator/module_generation_result.dart';
import 'package:module_generator/models/file/source_file.dart';
import 'package:module_generator/services/file_finder.dart';
import 'package:module_generator/services/file_parser.dart';
import 'package:module_generator/services/file_service.dart';
import 'package:path/path.dart' as p;

abstract class ModuleGenerator {
  Future<ModuleGenerationResult> generate(String rootDirectory, {String? libname, String? filename});
}

class ModuleGeneratorImpl implements ModuleGenerator {
  ModuleGeneratorImpl({
    required this.fileParser,
    required this.fileFinder,
    required this.fileService,
    required this.libFileGenerator,
    required this.pathHelper,
  });

  final PathHelper pathHelper;
  final FileParser fileParser;
  final FileFinder fileFinder;
  final FileService fileService;
  final LibFileGenerator libFileGenerator;

  @override
  Future<ModuleGenerationResult> generate(String rootDirectory, {String? libname, String? filename}) async {
    await _validateRoot(rootDirectory);

    final filepath = pathHelper.resolve(rootDirectory, '${filename ?? _getDefaultFilename()}.dart');
    libname ??= _getDefaultLibname(rootDirectory);

    await _validateTargetFile(filepath);

    final filesInfo = await fileFinder.getTargetFiles(rootDirectory);
    final sourceFiles = await _getSourceFiles(filesInfo.fileInfoList);

    final libContent = libFileGenerator.generateLibFile(sourceFiles, libname);
    final fileContentPairs = sourceFiles.map((f) => RefactoredSourceFile(f.info, libFileGenerator.generateSourceFile(f.content, libname!)));

    return ModuleGenerationResult(
      IndexFile(filepath, libContent),
      fileContentPairs, 
    );
  }

  Future<void> _validateTargetFile(String file) async {
    if(await fileService.existFile(file)) throw FileAlreadyExistException(file);
  }

  Future<void> _validateRoot(String root) async {
    if(await Directory(root).exists()) return;
    throw DirectoryNotFoundException(root);
  }

  String _getDefaultFilename() => 'index';
  String _getDefaultLibname(String root) => pathHelper.basename(root);

  Future<List<SourceFile>> _getSourceFiles(List<FileInfo> filesInfo) async {
    final fileRawContentList = await Future.wait(filesInfo.map((i) => fileService.read(i.fullpath)));
    return _getFiles(filesInfo, fileRawContentList).toList();
  }

  Iterable<SourceFile> _getFiles(List<FileInfo> filesInfo, List<List<String>> content) sync* {
    if(filesInfo.length != content.length) throw Exception();
    for(int i = 0; i < filesInfo.length; i++) {
      yield SourceFile(filesInfo[i], fileParser.parse(content[i]));
    }
  }
}
