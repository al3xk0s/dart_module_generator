class FileInfo {
  final String fullpath;
  final String dartModuleRelative;
  final String? dartProjectRelative;

  const FileInfo({
    required this.fullpath,
    required this.dartModuleRelative,
    required this.dartProjectRelative,
  });

  @override
  bool operator ==(covariant FileInfo other) {
    return super == other || (
      fullpath == other.fullpath && dartModuleRelative == other.dartModuleRelative && dartProjectRelative == other.dartProjectRelative
    );
  }

  @override
  int get hashCode => fullpath.hashCode + dartModuleRelative.hashCode * 37 + dartProjectRelative.hashCode * 31;

  @override
  String toString() {
    return 'filePath: $fullpath\n'
      'relative: $dartModuleRelative';
  }
}