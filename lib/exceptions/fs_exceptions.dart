abstract class FsException implements Exception {
  const FsException(this.message);

  final String message;

  @override
  String toString() {
    return message;
  }
}

class FileAlreadyExistException extends FsException {
  FileAlreadyExistException(String path) : super('Файл \'$path\' уже существует');
}

class DirectoryNotFoundException extends FsException {
  DirectoryNotFoundException(String path) : super('Целевая дирректория \'$path\' не найдена');
}

class IsNotProjectExection extends FsException {
  IsNotProjectExection() : super('Требуемый путь не является dart проектом');
}