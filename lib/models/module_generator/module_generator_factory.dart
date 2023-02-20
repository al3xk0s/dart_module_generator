import 'dart:io';

import 'package:module_generator/helper.dart';
import 'package:module_generator/models/module_generator/generation_result_writer.dart';
import 'package:module_generator/models/module_generator/lib_file_generator.dart';
import 'package:module_generator/models/module_generator/module_generator.dart';
import 'package:module_generator/services/file_finder.dart';
import 'package:module_generator/services/file_info_parser.dart';
import 'package:module_generator/services/file_parser.dart';
import 'package:module_generator/services/file_service.dart';


typedef ModuleGeneratorFactory = ModuleGenerator Function();
typedef GenerationResultWriterFactory = GenerationResultWriter Function();

FileService _getFileService() => const FileServiceImpl(FileMode.write);

ModuleGenerator getModuleGenerator() {
  final pathHelper = createPathHelper();

  return ModuleGeneratorImpl(
    fileParser: FileParserImpl(), 
    fileFinder: FileFinderImpl(pathHelper, FileInfoParserImpl(pathHelper)), 
    fileService: _getFileService(), 
    libFileGenerator: LibFileGeneratorImpl(pathHelper),
    pathHelper: createPathHelper(),
  );
}

GenerationResultWriter getResultWriter() {
  return GenerationResultWriterImpl(
    _getFileService(),
  );
}