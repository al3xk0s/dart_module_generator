abstract class SourceLineTemplate {
  String get value;

  @override
  String toString() {
    return value;
  }
}

abstract class _ImportLikeSourceLine extends SourceLineTemplate {
  _ImportLikeSourceLine._(this.keyword, {this.path, this.name});

  _ImportLikeSourceLine.name(String keyword, String name) : this._(keyword, name: name);
  _ImportLikeSourceLine.path(String keyword, String path) : this._(keyword, path: path);

  @override
  String get value {
    return "$keyword ${_getSecondaryPart()};";
  }

  String _getSecondaryPart() {
    if(path == null && name == null) throw Exception('Path and name is null');
    if(path != null) return "'$path'";
    return name!;
  }

  final String keyword;
  final String? path;
  final String? name;
}

class ImportLine extends _ImportLikeSourceLine {
  ImportLine(String path) : super.path('import', path);
}

class PartLine extends _ImportLikeSourceLine {
  PartLine(String path) : super.path('part', path);
}

class PartOf extends _ImportLikeSourceLine {
  PartOf.path(String path) : super.path('part of', path);
  PartOf.name(String libname) : super.name('part of', libname);
}

class LibraryDeclareLine extends _ImportLikeSourceLine {
  LibraryDeclareLine(String libname) : super.name('library', libname);
}

class SimpleSourceLine extends SourceLineTemplate {
  SimpleSourceLine(this.value);

  @override
  final String value;
}