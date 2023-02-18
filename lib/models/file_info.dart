class FileInfo {
  final String relative;
  final String filePath;

  const FileInfo({
    required this.filePath,
    required this.relative,
  });

  @override
  bool operator ==(covariant FileInfo other) {
    return super == other || (
      filePath == other.filePath && relative == other.relative
    );
  }

  @override
  int get hashCode => filePath.hashCode + relative.hashCode * 37;

  @override
  String toString() {
    return 'filePath: $filePath\n'
      'relative: $relative';
  }
}