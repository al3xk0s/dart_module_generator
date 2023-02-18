import 'package:args/args.dart';

class Arguments {
  final Uri path;
  final String? libname;

  final bool isHelp;

  Arguments(this.path, this.libname, this.isHelp);
}

class ConsoleWorker {
  Arguments handleArguments(List<String> arguments) {
    final argParser = ArgParser()
    ..addOption('libname', abbr: 'l')
    ..addFlag('help', abbr: 'h');

    final args = argParser.parse(arguments);

    bool isHelp = args.arguments.isEmpty || (args['help'] ?? false);
    
    if(isHelp) return Arguments(Uri.parse('./'), null, isHelp);

    final path = Uri.parse(args.arguments[0]);
    final String? libname = args['libname'];

    return Arguments(path, libname, false);
  }

  String getHelp() {
    const tab = '  ';
    const help = [
      'Command structure:',
      '',
      '${tab}path/to/folder [ -l | --libname \'libname\']',
    ];

    return help.join('\n');
  }

  void showHelp() {
    print('');
    print(getHelp());
    print('');
  }
}