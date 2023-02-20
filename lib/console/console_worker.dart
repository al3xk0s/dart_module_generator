import 'package:args/args.dart';
import 'package:module_generator/console/extentions.dart';
import 'package:module_generator/console/my_option.dart';
import 'package:module_generator/helper.dart';

class Arguments {
  final String path;
  final String? libname;
  final String? filename;

  final bool isHelp;

  Arguments(this.path, this.libname, this.filename, this.isHelp);
}

class ConsoleWorker {
  final PathHelper pathHelper = createPathHelper();

  Arguments handleArguments(List<String> arguments) {
    final argParser = ArgParser()
    ..addMyOption(MyOption.libname)
    ..addMyOption(MyOption.filename)
    ..addMyFlag(MyOption.help);

    final args = argParser.parse(arguments);
    
    bool isHelp = args.arguments.isEmpty || (args.getMyOption<bool?>(MyOption.help) ?? false);
    
    if(isHelp) return Arguments('', null, null, isHelp);

    final path = pathHelper.canonicalize(args.arguments[0]);
    final String? libname = args.getMyOption(MyOption.libname);
    final String? filename = args.getMyOption(MyOption.filename);

    return Arguments(path, libname, filename, false);
  }

  String getHelp() {
    const tab = '  ';

    String getOptString(MyOption option) => '${option.optabbr}, ${option.optname}';

    final options = [
      '${getOptString(MyOption.filename)}\tПозволяет задать имя index файла (default \'index\')',
      '${getOptString(MyOption.libname)}\t\tПозволяет задать имя модуля в проекте (default \${moduleRootFolderName})',
      '${getOptString(MyOption.help)}\t\tВызов справки',
    ];

    final help = [
      'Usage: dart_module_generator /path/to/folder [OPTIONS]',      
      '',
      'Options:',
      '',
      ...options.map((o) => '$tab$o'),
    ];

    return help.join('\n');
  }

  void handleException(Object exception) {
    _out('Ошибка: $exception');
  }

  void showHelp() => _out(getHelp());

  void _out(String string) {
    print('');
    print(string);
    print('');
  }
}
