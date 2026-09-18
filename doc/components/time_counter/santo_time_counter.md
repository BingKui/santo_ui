---
title: SantoTimeCounter
group:
  title: 计时器
  order: 1
---

# SantoTimeCounter

支持倒计时和正计时两种模式,支持自定义格式(HH:mm:ss:SS),支持暂停/继续/重置控制器。

## 一、效果总览

- 支持倒计时(countdown)和正计时(stopwatch)两种模式
- 可自定义时间格式
- 支持暂停/继续/重置操作
- 提供控制器进行外部控制

## 二、描述

### 适用场景
1. 验证码倒计时
2. 限时活动倒计时
3. 运动计时/番茄钟
4. 考试/答题计时
5. 任何需要时间计数的场景

### 使用规范
- countdown 模式需要设置 duration,stopwatch 模式从 0 开始累加
- autoStart 为 true 时组件挂载后自动开始计时
- format 支持 HH(时)/mm(分)/ss(秒)/SS(毫秒)的组合
- controller 必须在组件外部创建,通过它调用 pause/resume/reset

## 三、构造函数及参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| mode | SantoTimeCounterMode | 计时器模式(countdown/stopwatch) | 否 | countdown |
| duration | Duration | 倒计时时长(仅倒计时模式有效) | 否 | 60秒 |
| autoStart | bool | 是否自动开始 | 否 | true |
| onTick | void Function(Duration)? | 每次计时回调 | 否 | null |
| onComplete | VoidCallback? | 倒计时完成回调 | 否 | null |
| textStyle | TextStyle? | 文字样式 | 否 | null |
| format | String | 时间格式(HH/mm/ss/SS) | 否 | 'mm:ss' |
| controller | SantoTimeCounterController? | 控制器(pause/resume/reset) | 否 | null |
| builder | Widget Function(Duration)? | 自定义构建器 | 否 | null |

### SantoTimeCounterController

| 方法 | 描述 |
| --- | --- |
| pause() | 暂停计时 |
| resume() | 继续计时 |
| reset() | 重置计时 |

## 四、示例代码

### 倒计时基础用法

```dart
SantoTimeCounter(
  duration: const Duration(minutes: 5),
  onComplete: () {
    print('倒计时结束');
  },
)
```

### 验证码倒计时

```dart
SantoTimeCounter(
  duration: const Duration(seconds: 60),
  format: 'ss',
  textStyle: const TextStyle(color: Colors.blue),
  onComplete: () {
    // 重新发送验证码
  },
)
```

### 正计时(秒表)

```dart
SantoTimeCounter(
  mode: SantoTimeCounterMode.stopwatch,
  format: 'mm:ss',
)
```

### 带控制器

```dart
final counterController = SantoTimeCounterController();

Column(
  children: [
    SantoTimeCounter(
      duration: const Duration(minutes: 10),
      controller: counterController,
      onTick: (remaining) {
        print('剩余: ${remaining.inSeconds}秒');
      },
    ),
    Row(
      children: [
        ElevatedButton(
          onPressed: () => counterController.pause(),
          child: const Text('暂停'),
        ),
        ElevatedButton(
          onPressed: () => counterController.resume(),
          child: const Text('继续'),
        ),
        ElevatedButton(
          onPressed: () => counterController.reset(),
          child: const Text('重置'),
        ),
      ],
    ),
  ],
)
```

### 自定义格式

```dart
SantoTimeCounter(
  duration: const Duration(hours: 2),
  format: 'HH:mm:ss',
)
// 显示: 01:59:59
```

### 自定义构建器

```dart
SantoTimeCounter(
  duration: const Duration(seconds: 30),
  builder: (duration) {
    final progress = duration.inSeconds / 30;
    return CircularProgressIndicator(value: progress);
  },
)
```
