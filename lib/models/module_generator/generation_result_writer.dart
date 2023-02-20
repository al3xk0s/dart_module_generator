import 'package:module_generator/models/module_generator/module_generation_result.dart';
import 'package:module_generator/services/file_service.dart';

abstract class GenerationResultWriter {
  Future<void> write(ModuleGenerationResult source);
}

class GenerationResultWriterImpl implements GenerationResultWriter {
  const GenerationResultWriterImpl(this.fileService);

  final FileService fileService;

  @override
  Future<void> write(ModuleGenerationResult source) async {
    await Future.wait([
      _writeFile(source.indexFile),
      _writeSourceFiles(source.sourceFiles),
    ]);
  }

  Future<void> _writeSourceFiles(Iterable<RefactoredSourceFile> files) async {
    await Future.wait(files.map((f) => _writeFile(f)));
  }

  Future<void> _writeFile(WritebleFile file) {
    return fileService.write(file.path, file.content);
  }
}