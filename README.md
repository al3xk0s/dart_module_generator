# Dart module generator

## Назначение

Это простая утилитка для создания дарт - модуля из папки. 
Она создает `index.dart` (или указанный через `-f` файл), являющийся входной точкой модуля.

Она также переносит все импорты из файлов модуля в `index` - файл и подключает эти файлы соответствующей диррективой.

## Ограничения

- Работает только на `unix` системах

## Сборка

Из корня проекта прописываем команду:

```sh
./compile_bin && sudo mv build/dart_module_generator /usr/bin/
```

## Использование

Вызов без параметров или с флагом `[ -h | --help ]` выведет простую подсказку:

```sh
Usage: dart_module_generator /path/to/folder [OPTIONS]

Options:

  -f, --filename        Позволяет задать имя index файла (default 'index')
  -l, --libname         Позволяет задать имя модуля в проекте (default ${moduleRootFolderName})
  -h, --help            Вызов справки
```

## Примеры

Допустим у нас следующая структура папок:

```sh
lib/
└── models
    └── module_generator
        ├── generation_result_writer.dart
        ├── module_generation_result.dart
        ├── module_generator.dart
        └── utils
            ├── lib_file_generator.dart
            └── module_generator_factory.dart
```

И мы хотим сделать модуль из `$(pwd)/lib/models/module_generator`

```sh
user@user-desktop:~/projects/module_generator$ dart_module_generator "$(pwd)/lib/models/module_generator"
```

В результате будет сгенерирован файл `lib/models/module_generator/index.dart` со следующим содержимым:

```dart
library module_generator;

import 'package:module_generator/services/file_service.dart';
import 'package:module_generator/models/file_info.dart';
import 'dart:io';
import 'package:module_generator/services/file_finder.dart';
import 'package:module_generator/services/file_parser.dart';
import 'package:module_generator/models/source/index.dart';
import 'dart:math';

part 'generation_result_writer.dart';
part 'module_generation_result.dart';
part 'utils/module_generator_factory.dart';
part 'utils/lib_file_generator.dart';
part 'module_generator.dart';
```

А в каждом файле модуля будет осуществлен перенос импортов на уровень `index.dart` и добавлена дирректива `part of`:

```dart
// lib/models/module_generator/utils/module_generator_factory.dart

part of module_generator;

// without imports

typedef ModuleGeneratorFactory = ModuleGenerator Function();
typedef GenerationResultWriterFactory = GenerationResultWriter Function();

// more source ...
```

И по итогу папки будут иметь структуру:

```sh
lib/
└── models
    └── module_generator
        ├── generation_result_writer.dart
        ├── index.dart
        ├── module_generation_result.dart
        ├── module_generator.dart
        └── utils
            ├── lib_file_generator.dart
            └── module_generator_factory.dart
```