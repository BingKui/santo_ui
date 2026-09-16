---
title: SantoMenuBar
group:
  title: 导航
  order: 3
---

# SantoMenuBar

菜单栏:页面底部的导航切换栏,分默认(停靠)和悬浮两种样式。

## 一、效果总览

- 默认样式:纯色背景(默认白色,可自定义),顶部左右圆角,底部贴边
- 悬浮样式:透明毛玻璃圆角容器,与屏幕边缘保持 gap 间距,每个标签项为大圆角胶囊

## 二、描述

### 适用场景
1. 页面底部的主导航切换。
2. 需要悬浮毛玻璃效果的沉浸式页面。

### 使用规范
- 悬浮样式的 gap 为容器与屏幕左/右/下边缘的距离。
- 红点通过 `showBadge` 开启,数字角标通过 `badge` 自定义。

## 三、构造函数及参数说明

### SantoMenuBar

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| style | SantoMenuBarStyle | 样式 docked(默认)/floating(悬浮) | 否 | docked |
| items | List&lt;SantoMenuBarItem&gt; | 标签项 | 是 | 无 |
| currentIndex | int? | 受控选中索引 | 否 | null |
| onChange | ValueChanged&lt;int&gt;? | 选中变化回调 | 否 | null |
| barHeight | double? | 栏高度(docked 56 / floating 64) | 否 | null |
| backgroundColor | Color? | 背景色(docked 默认白色/floating 默认半透明白) | 否 | null |
| topRadius | double | docked 顶部圆角 | 否 | 12 |
| showTopDivider | bool | docked 顶部分割线 | 否 | true |
| gap | double | floating 与屏幕边缘距离 | 否 | 12 |
| containerRadius | double | floating 容器圆角 | 否 | 28 |
| itemRadius | double | floating 标签项圆角 | 否 | 20 |
| itemSelectedBgColor | Color? | floating 选中项背景,默认主色 | 否 | null |
| useSafeArea | bool | 底部安全区域 | 否 | true |

### SantoMenuBarItem

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| text | String? | 标签文本 | 否 | null |
| selectedIcon | Widget? | 选中图标 | 否 | null |
| unselectedIcon | Widget? | 未选中图标 | 否 | null |
| onTap | GestureTapCallback? | 点击回调 | 否 | null |
| showBadge | bool | 红点 | 否 | false |
| badge | Widget? | 自定义徽标 | 否 | null |

## 四、示例代码

```dart
SantoMenuBar(
  style: SantoMenuBarStyle.floating,
  gap: 12,
  items: [
    SantoMenuBarItem(text: '首页', selectedIcon: Icon(Icons.home)),
    SantoMenuBarItem(text: '我的', selectedIcon: Icon(Icons.person)),
  ],
)
```
