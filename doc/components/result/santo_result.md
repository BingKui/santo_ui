---
title: SantoResult
group:
  title: 结果页
  order: 1
---

# SantoResult

操作结果反馈页,用于展示操作完成后的结果状态,支持成功、失败、警告、信息四种状态。

## 一、效果总览

- 支持 success/error/warning/info 四种状态
- 每种状态有默认图标和颜色
- 可自定义图标和颜色
- 支持操作按钮区域

## 二、描述

### 适用场景
1. 表单提交成功/失败反馈
2. 操作确认页面
3. 错误提示页面
4. 流程完成状态展示

### 使用规范
- 成功状态使用绿色系,失败使用红色系,警告使用橙色系,信息使用蓝色系
- 标题简明扼要地说明结果,描述补充详细信息
- actions 区域放置相关操作按钮,如"重试"、"返回"等
- 自定义图标时建议保持与状态语义一致的颜色

## 三、构造函数及参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| status | SantoResultStatus | 结果状态(success/error/warning/info) | 是 | - |
| title | String? | 标题 | 否 | null |
| description | String? | 描述信息 | 否 | null |
| icon | IconData? | 自定义图标 | 否 | null(状态默认图标) |
| iconColor | Color? | 自定义图标颜色 | 否 | null(状态默认颜色) |
| actions | List\<Widget\>? | 操作按钮列表 | 否 | null |

## 四、示例代码

### 成功状态

```dart
SantoResult(
  status: SantoResultStatus.success,
  title: '提交成功',
  description: '您的申请已提交,我们将在3个工作日内处理',
)
```

### 失败状态带操作按钮

```dart
SantoResult(
  status: SantoResultStatus.error,
  title: '提交失败',
  description: '网络连接异常,请稍后重试',
  actions: [
    ElevatedButton(onPressed: () {}, child: const Text('重试')),
    OutlinedButton(onPressed: () {}, child: const Text('返回')),
  ],
)
```

### 自定义图标

```dart
SantoResult(
  status: SantoResultStatus.warning,
  icon: Icons.warning_amber_rounded,
  iconColor: Colors.orange,
  title: '注意事项',
  description: '请仔细阅读以下条款',
)
```
