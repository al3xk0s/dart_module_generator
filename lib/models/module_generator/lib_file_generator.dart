
import 'package:module_generator/helper.dart';
import 'package:module_generator/models/file/source_content.dart';
import 'package:module_generator/models/file/source_file.dart';
import 'package:module_generator/models/file/source_line.dart';

abstract class LibFileGenerator {
  Iterable<String> generateLibFile(List<SourceFile> files, String libname);
  Iterable<String> generateSourceFile(SourceContent sourceFileContent, String libname);
}

class LibFileGeneratorImpl implements LibFileGenerator {
  const LibFileGeneratorImpl(this.pathHelper);

  static const _indent = '';

  final PathHelper pathHelper;

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
      yield* file.content.imports.map((i) => i.trim()).where((i) => !_isSourceReferenceImport(i, files));
    }
  }

  bool _isSourceReferenceImport(String importStr, List<SourceFile> files) {
    final relativeImportPart = pathHelper.getRelativeProjectPath(importStr);
    return files.any((f) => relativeImportPart == (f.info.dartProjectRelative ?? ''));
  }

  Iterable<String> _getPartBlock(List<SourceFile> files) sync* {
    for(final file in files) {
      yield PartLine(file.info.dartModuleRelative).toString();
    }
  }

  @override
  Iterable<String> generateSourceFile(SourceContent sourceFileContent, String libname) sync* {
    if(sourceFileContent.sources.isEmpty) return;

    yield PartOf.name(libname).toString();
    yield _indent;
    yield* sourceFileContent.sources;
    yield _indent;
  }
}