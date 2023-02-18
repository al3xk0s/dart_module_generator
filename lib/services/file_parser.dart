import 'package:module_generator/models/source/source_content.dart';

abstract class FileParser {
  SourceContent parse(Iterable<String> lines);
}

class FileParserImpl implements FileParser {
  static final RegExp _importPattern = RegExp("\\s*import\\s+'.*'\\s*;");

  @override
  SourceContent parse(Iterable<String> lines) {
    return 
      SourceContent(
        _getImports(lines).toList(),
        _getSource(lines).toList(),
      );
  }

  Iterable<String> _getImports(Iterable<String> lines) {
    return lines.where(_importPattern.hasMatch);
  }

    Iterable<String> _getSource(Iterable<String> lines) {
    return lines.where((s) => !_importPattern.hasMatch(s));
  }
}
