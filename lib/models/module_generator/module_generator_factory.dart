import 'dart:io';

import 'package:module_generator/models/module_generator/generation_result_writer.dart';
import 'package:module_generator/models/module_generator/lib_file_generator.dart';
import 'package:module_generator/models/module_generator/module_generator.dart';
import 'package:module_generator/services/file_finder.dart';
import 'package:module_generator/services/file_parser.dart';
import 'package:module_generator/services/file_service.dart';


typedef ModuleGeneratorFactory = ModuleGenerator Function();
typedef GenerationResultWriterFactory = GenerationResultWriter Function();

FileService _getFileService() => const FileServiceImpl(FileMode.write);

ModuleGenerator getModuleGenerator() {
  return ModuleGeneratorImpl(
    FileParserImpl(), 
    FileFinderImpl(), 
    _getFileService(), 
    LibFileGeneratorImpl(),
  );
}

GenerationResultWriter getResultWriter() {
  return GenerationResultWriterImpl(
    _getFileService(),
  );
}