import 'package:module_generator/models/file_info.dart';
import 'package:module_generator/models/module_generator/lib_file_generator.dart';
import 'package:module_generator/models/source/source_content.dart';
import 'package:module_generator/models/source/source_file.dart';

import 'package:module_generator/services/file_finder.dart';
import 'package:module_generator/services/file_parser.dart';
import 'package:test/test.dart';

void main() {
  const modulePath = '/home/user/projects/module_generator/test/source/test_module';

  const userViewFileInfo = FileInfo(filePath: '/home/user/projects/module_generator/test/source/test_module/view/user_view.dart', relative: 'view/user_view.dart');

  const fileInfos = [
    FileInfo(filePath: '/home/user/projects/module_generator/test/source/test_module/user.dart', relative: 'user.dart'),
    FileInfo(filePath: '/home/user/projects/module_generator/test/source/test_module/view/address_view.dart', relative: 'view/address_view.dart'),
    userViewFileInfo,
    FileInfo(filePath: '/home/user/projects/module_generator/test/source/test_module/view/view.dart', relative: 'view/view.dart'),
    FileInfo(filePath: '/home/user/projects/module_generator/test/source/test_module/address.dart', relative: 'address.dart'),
    FileInfo(filePath: '/home/user/projects/module_generator/test/source/test_module/models/repo/base/user_repo.dart', relative: 'models/repo/base/user_repo.dart'),
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
    final actual = await FileFinderImpl().getTargetFiles(Uri.parse(modulePath));
    expect(actual, fileInfos);
  });

  test('Parse source', () {
    final actual = FileParserImpl().parse(userViewSources);
    expect(actual.imports, userViewSourceContent.imports);
    expect(actual.sources, userViewSourceContent.sources);
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
      'part \'${userInfoSourceFile.info.relative}\';',
    ];

    expect(actual, expected);
  });
}
