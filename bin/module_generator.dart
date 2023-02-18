import 'package:module_generator/console_worker.dart';
import 'package:module_generator/models/module_generator/module_generator_model_factory.dart';

void main(List<String> arguments) async {
  final worker = ConsoleWorker();
  final args = worker.handleArguments(arguments);
  if(args.isHelp) return worker.showHelp();

  final refactorModel = getRefactorModel();
  await refactorModel.refactor(args.path, libname: args.libname, filename: args.filename);
}


