import 'package:module_generator/models/file_info.dart';

abstract class WritebleFile {
  String get path;
  Iterable<String> get content;
}

class RefactoredSourceFile implements WritebleFile {
  const RefactoredSourceFile(this.info, this.content);

  final FileInfo info;

  @override
  String get path => info.filePath;

  @override
  final Iterable<String> content;
}

class IndexFile implements WritebleFile {
  const IndexFile(this.path, this.content);

  @override
  final String path;

  @override
  final Iterable<String> content;
}

class ModuleGenerationResult {
  const ModuleGenerationResult(this.indexFile, this.sourceFiles);

  final IndexFile indexFile;
  final Iterable<RefactoredSourceFile> sourceFiles;
}