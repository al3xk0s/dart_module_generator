class MyOption {
  const MyOption._(this.name, this.abbr);

  final String name;
  final String abbr;

  String get optname => '--$name';
  String get optabbr => '-$abbr';

  static const filename = MyOption._('filename', 'f');
  static const libname = MyOption._('libname', 'l');
  static const help = MyOption._('help', 'h');
}