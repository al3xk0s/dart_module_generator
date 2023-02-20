import 'package:module_generator/models/file/file_info.dart';
import 'package:module_generator/models/file/source_content.dart';

class SourceFile {
  final FileInfo info;
  final SourceContent content;

  const SourceFile(this.info, this.content);
}