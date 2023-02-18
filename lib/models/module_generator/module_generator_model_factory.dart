import 'dart:io';

import 'package:module_generator/models/module_generator/lib_file_generator.dart';
import 'package:module_generator/models/module_generator/module_generator_model.dart';
import 'package:module_generator/services/file_finder.dart';
import 'package:module_generator/services/file_parser.dart';
import 'package:module_generator/services/file_service.dart';


typedef RefactorModelFactory = ModuleGeneratorModel Function();

ModuleGeneratorModel getRefactorModel() {
  return RefactorModelImpl(
    FileParserImpl(), 
    FileFinderImpl(), 
    FileServiceImpl(FileMode.write), 
    LibFileGeneratorImpl(),
  );
}