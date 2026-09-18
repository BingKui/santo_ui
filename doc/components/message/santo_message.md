---
title: SantoMessage
group:
  title: 消息通知
  order: 1
---

# SantoMessage

顶部轻量消息提示,支持 success/error/warning/info 四种类型。使用 Overlay 实现,自动消失。

## 一、效果总览

- 从页面顶部滑入显示
- 支持成功/错误/警告/信息四种类型
- 每种类型有默认图标和颜色
- 自动消失,可自定义持续时间
- 提供便捷的静态方法

## 二、描述

### 适用场景
1. 操作成功/失败反馈
2. 轻量级提示信息
3. 表单验证错误提示
4. 网络请求状态提示

### 使用规范
- 优先使用便捷方法:`success()`, `error()`, `warning()`, `info()`
- duration 不宜过长,默认 2 秒适合大多数场景
- 重要信息应考虑使用 Dialog 而非 Message
- 同一时间只显示一条消息,新消息会替换旧消息

## 三、构造函数及参数说明

### SantoMessage.show()

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| context | BuildContext | 上下文 | 是 | - |
| content | String | 消息内容 | 是 | - |
| type | SantoMessageType | 消息类型(success/error/warning/info) | 否 | info |
| duration | Duration | 自动消失时长 | 否 | 2秒 |
| backgroundColor | Color? | 背景色 | 否 | null(按类型自动) |
| textColor | Color? | 文字颜色 | 否 | null(白色) |
| icon | IconData? | 自定义图标 | 否 | null(按类型自动) |
| onDismiss | VoidCallback? | 消失回调 | 否 | null |

### 便捷方法

```dart
SantoMessage.success(context, '操作成功')
SantoMessage.error(context, '操作失败')
SantoMessage.warning(context, '请注意')
SantoMessage.info(context, '提示信息')
```

### SantoMessage.dismiss()

手动关闭当前显示的消息。

## 四、示例代码

### 成功提示

```dart
ElevatedButton(
  onPressed: () {
    SantoMessage.success(context, '保存成功');
  },
  child: const Text('保存'),
)
```

### 错误提示

```dart
SantoMessage.error(context, '网络连接失败,请重试');
```

### 自定义持续时间

```dart
SantoMessage.show(
  context: context,
  content: '这是一条长时间提示',
  type: SantoMessageType.info,
  duration: const Duration(seconds: 5),
);
```

### 手动关闭

```dart
// 显示消息
SantoMessage.show(context: context, content: '处理中...');

// 异步操作完成后关闭
await someAsyncOperation();
SantoMessage.dismiss();
```
