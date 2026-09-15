// 组件参数表生成脚本(对应技术方案 5.3 节)
// 用法:
//   dart run tool/gen_doc.dart --all      # 生成所有组件参数表
//   dart run tool/gen_doc.dart --check    # 校验组件源码均有对应文档 md
//   dart run tool/gen_doc.dart <file>     # 输出单个组件文件的参数表
import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    stderr.writeln('用法: dart run tool/gen_doc.dart [--all|--check|<file>]');
    exit(64);
  }

  if (args.contains('--check')) {
    _checkDocs();
    return;
  }

  final files = args.contains('--all')
      ? Directory('lib/src/components')
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .map((f) => f.path)
          .toList()
      : args;

  for (final path in files) {
    final table = _generateParamTable(path);
    if (table.isNotEmpty) stdout.write(table);
  }
}

final _classPattern = RegExp(r'^class\s+(Santo\w+)', multiLine: true);

/// 解析单个组件文件,输出 Santo* 类构造函数的参数表。
String _generateParamTable(String path) {
  final source = File(path).readAsStringSync();
  final buffer = StringBuffer();

  for (final classMatch in _classPattern.allMatches(source)) {
    final className = classMatch.group(1)!;
    final params = _findParams(source, classMatch.end, className);
    if (params.isEmpty) continue;

    buffer.writeln('## $className');
    buffer.writeln();
    buffer.writeln('文件: `$path`');
    buffer.writeln();
    buffer.writeln('| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |');
    buffer.writeln('| --- | --- | --- | --- | --- |');
    for (final p in params) {
      buffer.writeln(
          '| ${p.name} | ${p.type} | ${p.doc} | ${p.required ? '是' : '否'} | ${p.hasDefault ? '有' : '无'} |');
    }
    buffer.writeln();
  }
  return buffer.toString();
}

class _Param {
  _Param(this.name, this.type, this.doc, this.required, this.hasDefault);
  final String name;
  final String type;
  final String doc;
  final bool required;
  final bool hasDefault;
}

/// 从 className 类声明之后找构造函数,逐行提取命名参数与 /// 文档。
List<_Param> _findParams(String source, int searchStart, String className) {
  final ctorMatches =
      RegExp('$className\\s*\\(').allMatches(source, searchStart).toList();
  if (ctorMatches.isEmpty) return [];
  final ctorMatch = ctorMatches.first;

  final open = ctorMatch.end - 1;
  var depth = 0;
  var close = -1;
  for (var i = open; i < source.length; i++) {
    if (source[i] == '(') depth++;
    if (source[i] == ')') {
      depth--;
      if (depth == 0) {
        close = i;
        break;
      }
    }
  }
  if (close < 0) return [];
  final paramsText = source.substring(open + 1, close);

  // 字段类型表与字段文档表(用于 this.xxx 初始化形参)。
  final fieldTypes = <String, String>{};
  final fieldDocs = <String, String>{};
  for (final m in RegExp(
          r'(?:^|[;{}])\s*(?:static\s+)?(?:final|late final|var|const)?\s*([\w<>,\?\s\.]+?)\s+(\w+)\s*[;=]',
          multiLine: true)
      .allMatches(source)) {
    final type = m.group(1)?.trim();
    final name = m.group(2);
    if (type != null && name != null) fieldTypes[name] = type;
  }
  for (final m in RegExp(r'///\s*(.+)\n\s*(?:static\s+)?(?:final|late final|var|const)\s+([\w<>,\?\s\.]+?)\s+(\w+)\s*[;=]')
      .allMatches(source)) {
    final name = m.group(3);
    final doc = m.group(1)?.trim();
    if (name != null && doc != null) fieldDocs[name] = doc;
  }

  final entries = <_Param>[];
  final pendingDoc = <String>[];
  for (final rawLine in paramsText.split('\n')) {
    final line = rawLine.trim();
    if (line.startsWith('///')) {
      pendingDoc.add(line.replaceFirst(RegExp(r'^///\s*'), ''));
      continue;
    }
    if (line.isEmpty || line.startsWith('//')) continue;

    // 形如 `this.title,` `required this.onTap,` `String? title = 'x',`
    final thisForm =
        RegExp(r'^(required\s+)?this\.(\w+)\s*(=.*?)?[,]?$').firstMatch(line);
    final declForm = RegExp(
            r'^(required\s+)?([\w<>,\?\s\.]+?)\s+(\w+)\s*(=.*?)?[,]?$')
        .firstMatch(line);
    if (thisForm != null) {
      final name = thisForm.group(2)!;
      final doc = pendingDoc.isNotEmpty ? pendingDoc.join(' ') : (fieldDocs[name] ?? '');
      entries.add(_Param(
        name,
        fieldTypes[name] ?? '见字段声明',
        doc,
        thisForm.group(1) != null,
        thisForm.group(3) != null,
      ));
      pendingDoc.clear();
    } else if (declForm != null &&
        !line.startsWith('{') &&
        !line.startsWith('}')) {
      final type = declForm.group(2)?.trim();
      final name = declForm.group(3);
      if (name != null && type != null && type.isNotEmpty) {
        entries.add(_Param(
          name,
          type,
          pendingDoc.join(' '),
          declForm.group(1) != null,
          declForm.group(4) != null,
        ));
        pendingDoc.clear();
      }
    }
  }
  return entries;
}

/// 校验 lib/src/components 下的每个组件文件在 doc/components 下有同名 md。
void _checkDocs() {
  final docFiles = Directory('doc/components')
      .listSync(recursive: true)
      .whereType<File>()
      .map((f) => f.uri.pathSegments.last)
      .toSet();

  final componentFiles = Directory('lib/src/components')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .map((f) => f.uri.pathSegments.last.replaceAll('.dart', '.md'))
      .toSet();

  final missing = componentFiles.difference(docFiles).toList()..sort();
  if (missing.isEmpty) {
    stdout.writeln('文档校验通过: 所有组件均有对应 md 文档。');
  } else {
    stderr.writeln('以下组件缺少文档(${missing.length} 个):');
    for (final m in missing) {
      stderr.writeln('  - $m');
    }
    exit(1);
  }
}
