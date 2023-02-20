import 'package:module_generator/helper.dart';
import 'package:module_generator/models/file/file_info.dart';

abstract class FileInfoParser {
  FileInfo parse(String? projectRoot, String moduleRoot, String fullpath);
}

class FileInfoParserImpl implements FileInfoParser {
  final PathHelper pathHelper;

  FileInfoParserImpl(this.pathHelper);

  @override
  FileInfo parse(String? projectRoot, String moduleRoot, String fullpath) {
    return FileInfo(
      fullpath: fullpath, 
      dartModuleRelative: pathHelper.toDartStandart(pathHelper.relative(moduleRoot, fullpath)),
      dartProjectRelative: projectRoot == null ? null : pathHelper.toDartStandart(pathHelper.relative(projectRoot, fullpath)),
    );
  }
}