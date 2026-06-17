import 'dart:convert';
import 'dart:io';

import 'package:recase/recase.dart';

void main(List<String> args) {
  final fontsInfoFile = File('./assets/info.json');
  final fontsInfo =
      jsonDecode(fontsInfoFile.readAsStringSync()) as Map<String, dynamic>;

  final generatedOutput = <String>[
    "// GENERATED CODE - DO NOT MODIFY BY HAND",
    "// dart format off",
    "",
    "import 'package:flutter/widgets.dart';",
    '',
    "const _fontFamily = 'Lucide';",
    "const _fontPackage = 'lucide_icons';",
    '',
    'extension type const LucideIconData._(IconData i) implements IconData {}',
    '',
    'class LucideIcons {',
  ];

  final seenNames = <String>{};

  for (final icon in fontsInfo.entries) {
    final name = ReCase(icon.key).camelCase;
    final codePoint = '${icon.value['unicode']}'
        .replaceFirst('&#', '')
        .replaceFirst(';', '');

    // Some source names collapse to the same camelCase identifier (e.g.
    // `arrow-up-1-0` and `arrow-up-10`); they alias the same code point, so
    // emit each identifier only once.
    if (!seenNames.add(name)) {
      continue;
    }

    generatedOutput.add(
      '  static const IconData $name = '
      'LucideIconData._(IconData($codePoint, '
      'fontFamily: _fontFamily, '
      'fontPackage: _fontPackage));',
    );
  }

  generatedOutput.add('}');

  final outputFile = File('./lib/lucide_icons.dart');
  final output = '${generatedOutput.join('\n')}\n';
  outputFile.writeAsStringSync(output);
}
