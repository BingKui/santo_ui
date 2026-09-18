---
title: SantoStatistic
group:
  title: 统计数值
  order: 1
---

# SantoStatistic

突出展示带标题的数值,支持前后缀、精度与千分位分组。参考 antd Statistic。

## 一、效果总览

- 标题 + 数值的经典布局
- 支持数值前后缀
- 支持小数精度控制
- 支持千分位分隔符
- 支持加载状态
- 可完全自定义数值渲染

## 二、描述

### 适用场景
1. 数据看板中的关键指标
2. 财务报表中的金额展示
3. 统计数据展示(如用户数、订单数)
4. 实时数据监控

### 使用规范
- precision 只补零和截断,不进行四舍五入
- groupSeparator 默认为逗号,可根据地区习惯修改
- formatter 优先级高于内置格式化逻辑,用于完全自定义
- loading 为 true 时显示骨架屏占位
- prefix/suffix 通常用于单位、货币符号等

## 三、构造函数及参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| title | String? | 标题文案 | 否 | null |
| titleWidget | Widget? | 自定义标题(优先级高于 title) | 否 | null |
| value | Object? | 数值,支持 num 与 String | 否 | 0 |
| precision | int? | 保留小数位数 | 否 | null |
| prefix | Widget? | 数值前缀 | 否 | null |
| suffix | Widget? | 数值后缀 | 否 | null |
| groupSeparator | String | 千分位分隔符 | 否 | ',' |
| decimalSeparator | String | 小数分隔符 | 否 | '.' |
| formatter | Widget Function(Object?)? | 自定义数值内容 | 否 | null |
| loading | bool | 是否展示加载态 | 否 | false |
| titleStyle | TextStyle? | 标题文字样式 | 否 | null |
| valueStyle | TextStyle? | 数值文字样式 | 否 | null |

## 四、示例代码

### 基础用法

```dart
SantoStatistic(
  title: '总销售额',
  value: 126560,
)
```

### 带前后缀

```dart
SantoStatistic(
  title: '增长率',
  value: 25.6,
  prefix: const Text('+'),
  suffix: const Text('%'),
)
```

### 指定小数位数

```dart
SantoStatistic(
  title: '平均评分',
  value: 4.8567,
  precision: 2, // 显示 4.85
)
```

### 自定义分隔符

```dart
SantoStatistic(
  title: '金额',
  value: 1234567.89,
  prefix: const Text('¥'),
  groupSeparator: ',',
  decimalSeparator: '.',
)
// 显示: ¥1,234,567.89
```

### 加载状态

```dart
SantoStatistic(
  title: '实时用户数',
  value: isLoading ? null : userCount,
  loading: isLoading,
)
```

### 完全自定义格式化

```dart
SantoStatistic(
  title: '文件大小',
  value: 1048576,
  formatter: (value) {
    final bytes = value as int;
    if (bytes < 1024) return Text('$bytes B');
    if (bytes < 1048576) return Text('${(bytes / 1024).toStringAsFixed(2)} KB');
    return Text('${(bytes / 1048576).toStringAsFixed(2)} MB');
  },
)
```
