import 'package:example/sample/home/example_theme_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('解析颜色哈希值', () {
    expect(ExampleThemeConfig.parseHexColor('#FF5722'),
        const Color(0xFFFF5722));
    expect(ExampleThemeConfig.parseHexColor('FF5722'),
        const Color(0xFFFF5722));
    expect(ExampleThemeConfig.parseHexColor('  #ff5722  '),
        const Color(0xFFFF5722));
    expect(ExampleThemeConfig.parseHexColor('#80FF5722'),
        const Color(0x80FF5722));
    expect(ExampleThemeConfig.parseHexColor('#1677FF'),
        ExampleThemeConfig.defaultBrandPrimary);
  });

  test('非法颜色哈希值返回 null', () {
    expect(ExampleThemeConfig.parseHexColor(''), isNull);
    expect(ExampleThemeConfig.parseHexColor('#F00'), isNull);
    expect(ExampleThemeConfig.parseHexColor('#12345'), isNull);
    expect(ExampleThemeConfig.parseHexColor('#1234567'), isNull);
    expect(ExampleThemeConfig.parseHexColor('#GGGGGG'), isNull);
  });
}
