import 'package:module_generator/console_worker.dart';
import 'package:module_generator/models/module_generator/module_generator_factory.dart';

void main(List<String> arguments) async {
  final worker = ConsoleWorker();
  final args = worker.handleArguments(arguments);
  if(args.isHelp) return worker.showHelp();

  final ModuleGeneratorFactory generatorFactory = getModuleGenerator;
  final GenerationResultWriterFactory resultWriterFactory = getResultWriter;

  final generator = generatorFactory();
  final resultWriter = resultWriterFactory();

  final result = await generator.generate(args.path, libname: args.libname, filename: args.filename);
  await resultWriter.write(result);
}


