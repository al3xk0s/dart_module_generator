
import 'package:module_generator/models/source/source_content.dart';
import 'package:module_generator/models/source/source_file.dart';
import 'package:module_generator/models/source/source_line.dart';

abstract class LibFileGenerator {
  Iterable<String> generateLibFile(List<SourceFile> files, String libname);
  Iterable<String> generateSourceFile(SourceContent sourceFileContent, String libname);
}

class LibFileGeneratorImpl implements LibFileGenerator {
  static const _indent = '';

  @override
  Iterable<String> generateLibFile(List<SourceFile> files, String libname) sync* {
    yield LibraryDeclareLine(libname).toString();
    yield _indent;
    yield* _getImportsBlock(files).toSet();
    yield _indent;
    yield* _getPartBlock(files);
  }

  Iterable<String> _getImportsBlock(List<SourceFile> files) sync* {
    for(final file in files) {
      yield* file.content.imports;
    }
  }

  Iterable<String> _getPartBlock(List<SourceFile> files) sync* {
    for(final file in files) {
      yield PartLine(file.info.relative).toString();
    }
  }

  @override
  Iterable<String> generateSourceFile(SourceContent sourceFileContent, String libname) sync* {
    if(sourceFileContent.sources.isEmpty) return;

    yield PartOf.name(libname).toString();
    yield _indent;
    yield* sourceFileContent.sources;
  }
}