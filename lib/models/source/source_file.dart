import 'package:module_generator/models/file_info.dart';
import 'package:module_generator/models/source/source_content.dart';

class SourceFile {
  final FileInfo info;
  final SourceContent content;

  const SourceFile(this.info, this.content);
}