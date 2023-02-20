import 'package:module_generator/models/file/file_info.dart';
import 'package:module_generator/models/module_generator/lib_file_generator.dart';
import 'package:module_generator/models/file/source_content.dart';
import 'package:module_generator/models/file/source_file.dart';

import 'package:module_generator/services/file_finder.dart';
import 'package:module_generator/services/file_parser.dart';
import 'package:test/test.dart';

void main() {
  const modulePath = '/home/user/projects/module_generator/test/source/test_module';

  const userViewFileInfo = FileInfo(fullpath: '/home/user/projects/module_generator/test/source/test_module/view/user_view.dart', dartModuleRelative: 'view/user_view.dart');

  const fileInfos = [
    FileInfo(fullpath: '/home/user/projects/module_generator/test/source/test_module/user.dart', dartModuleRelative: 'user.dart'),
    FileInfo(fullpath: '/home/user/projects/module_generator/test/source/test_module/view/address_view.dart', dartModuleRelative: 'view/address_view.dart'),
    userViewFileInfo,
    FileInfo(fullpath: '/home/user/projects/module_generator/test/source/test_module/view/view.dart', dartModuleRelative: 'view/view.dart'),
    FileInfo(fullpath: '/home/user/projects/module_generator/test/source/test_module/address.dart', dartModuleRelative: 'address.dart'),
    FileInfo(fullpath: '/home/user/projects/module_generator/test/source/test_module/models/repo/base/user_repo.dart', dartModuleRelative: 'models/repo/base/user_repo.dart'),
  ];

  const userViewSourceContent = SourceContent(
    [
      "import '../user.dart';",
      "import 'address_view.dart';",
      "import 'view.dart';",
    ],
    [
      "class UserView extends View {",
      "  final User user;",
      "",
      "  UserView(this.user);",
      "",
      "  @override",
      "  Iterable<String> build() {",
      "    return [",
      "      'User: \${user.name}',",
      "      'Address: \${AddressView(user.address)}',",
      "    ];",
      "  }",
      "}",
    ],
  );

  const userInfoSourceFile = SourceFile(
    userViewFileInfo,
    userViewSourceContent,
  );

  final userViewSources = [
    '',
    ...userViewSourceContent.imports,
    '',
    ...userViewSourceContent.sources,
    '',
  ];

  test('Find files', () async {
    final actual = await FileFinderImpl().getTargetFiles(String.parse(modulePath));
    expect(actual, fileInfos);
  });

  test('Parse source', () {
    final actual = FileParserImpl().parse(userViewSources);
    expect(actual.imports, userViewSourceContent.imports);
    expect(actual.sources, userViewSourceContent.sources);
  });

  test('Parse source with empty', () {
    final code = [
      'class SomeCode {}',
      '',
    ];
    final actual = FileParserImpl().parse(code);
    expect(actual.imports, const []);
    expect(actual.sources, [code.first]);
  });

  test('Generate source file', () {
    final libname = 'libr';
    final actual = LibFileGeneratorImpl().generateSourceFile(userViewSourceContent, libname).toList();
    final expected = [
      'part of $libname;',
      '',
      ...userViewSourceContent.sources,
    ];
    expect(actual, expected);
  });

  test('Generate libfile', () {
    final libname = 'libr';
    final actual = LibFileGeneratorImpl().generateLibFile([userInfoSourceFile], libname).toList();

    final expected = [
      'library $libname;',
      '',
      ...userViewSourceContent.imports,
      '',
      'part \'${userInfoSourceFile.info.dartModuleRelative}\';',
    ];

    expect(actual, expected);
  });
}
