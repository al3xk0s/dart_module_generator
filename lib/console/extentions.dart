import 'package:args/args.dart';
import 'package:module_generator/console/my_option.dart';

extension MyOptionSupportExt on ArgParser {
  void addMyOption(
    MyOption option, {
    String? help,
    String? valueHelp,
    Iterable<String>? allowed,
    Map<String, String>? allowedHelp,
    String? defaultsTo,
    void Function(String?)? callback,
    bool mandatory = false,
    bool hide = false,
    List<String> aliases = const [],
  }) {
    return addOption(
      option.name,
      abbr: option.abbr,
      help: help,
      valueHelp: valueHelp,
      allowed: allowed,
      allowedHelp: allowedHelp,
      defaultsTo: defaultsTo,
      callback: callback,
      mandatory: mandatory,
      hide: hide,
      aliases: aliases,
    );
  }

  void addMyFlag(
    MyOption option, {
    String? help,
    bool? defaultsTo = false,
    bool negatable = true,
    void Function(bool)? callback,
    bool hide = false,
    List<String> aliases = const [],
  }) {
    return addFlag(
      option.name,
      abbr: option.abbr,
      help: help,
      defaultsTo: defaultsTo,
      negatable: negatable,
      callback: callback,
      hide: hide,
      aliases: aliases,
    );
  }
}

extension ArgMyOptionsSupportExt on ArgResults {
  T getMyOption<T>(MyOption option) {
    return this[option.name];
  }
}