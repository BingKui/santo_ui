---
title: SantoLoading
group:
  title: 反馈
  order: 8
---

# SantoLoading

加载组件用于提示正在进行的等待,是库内**唯一的加载入口**,对标
[antd Spin](https://ant-design.antgroup.com/components/spin-cn)。

独立指示器、包裹内容、全屏遮罩以及 show/dismiss 浮层都由 `SantoLoading` 一个类承担,
不再提供 `SantoPageLoading`、`SantoLoadingDialog` 等独立组件。

## 一、效果总览

- **独立使用**:默认主题色不确定进度圆环,占满可用空间并居中
- **尺寸**:`small`(14)、`medium`(20,默认)、`large`(32),与 antd Spin 一致
- **文案**:`tip` 展示在指示器下方,长文案自动换行
- **受控与延迟**:`spinning` 控制显隐,`delay` 避免一闪而过的加载动画
- **自定义指示器**:`indicator` 替换默认圆环,`color` 只改颜色
- **包裹模式**:传入 `child` 后在内容上盖一层半透明蒙层并居中展示指示器
- **全屏**:`fullscreen` 铺满父布局
- **进度**:`percent` 传 0~100 时圆环展示确定进度
- **浮层**:`SantoLoading.show` 展示「蒙层 + 黑胶囊」浮层,`SantoLoading.dismiss` 关闭

## 二、描述

### 适用场景

1. 页面局部或整页等待异步数据、渲染中
2. 阻塞式等待(提交表单等),完成后主动关闭浮层
3. 长列表、图片等占位加载

### 使用规范

1. 优先使用包裹模式(`child`)把加载态限制在受影响的区域内,避免整页阻塞
2. 超过 300ms 的等待才需要加载态;可配合 `delay` 使用,避免闪烁
3. 浮层必须成对调用 `SantoLoading.show` 与 `SantoLoading.dismiss`,不会自动关闭
4. 需要更小或更大的指示器时用 `size`,不要自建加载组件

## 三、构造函数及参数说明

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `child` | `Widget?` | - | 被包裹的内容,传入后进入包裹模式 |
| `tip` | `String?` | - | 加载文案,浮层不传时用本地化的「加载中」 |
| `indicator` | `Widget?` | - | 自定义指示器,默认主题色圆环 |
| `size` | `SantoLoadingSize` | `medium` | small / medium / large |
| `spinning` | `bool` | `true` | 是否处于加载中 |
| `delay` | `Duration?` | - | 延迟展示时长,延迟期间加载结束则不展示 |
| `percent` | `double?` | - | 进度百分比(0~100),不传为不确定进度 |
| `fullscreen` | `bool` | `false` | 铺满父布局的遮罩 + 居中指示器 |
| `color` | `Color?` | - | 指示器颜色,默认主题色 `brandPrimary` |
| `overlayColor` | `Color?` | - | 包裹/全屏模式的蒙层颜色 |

### 静态方法

| 方法 | 说明 |
| --- | --- |
| `SantoLoading.show<T>(context, {tip, fullscreen, barrierDismissible, useRootNavigator})` | 展示加载浮层,返回 Future |
| `SantoLoading.dismiss<T>(context, [result])` | 关闭加载浮层 |

## 四、示例代码

```dart
// 独立使用:占满可用空间并居中
SizedBox(height: 120, child: const SantoLoading());

// 尺寸与文案
SantoLoading(size: SantoLoadingSize.small);
SantoLoading(size: SantoLoadingSize.large, tip: '加载中');

// 自定义指示器与颜色
SantoLoading(indicator: const Icon(Icons.cloud_download), tip: '上传中');
SantoLoading(color: const Color(0xFF52C41A));

// 受控 + 延迟展示
SantoLoading(spinning: isLoading, delay: const Duration(milliseconds: 500));

// 包裹内容:加载时盖蒙层
SantoLoading(
  spinning: isLoading,
  tip: '加载中',
  child: const SantoPanel(title: '数据区块', child: Text('内容')),
);

// 进度
SantoLoading(percent: 40);

// 铺满父布局
SantoLoading(fullscreen: true, tip: '加载中');

// 浮层:黑胶囊 + 蒙层
SantoLoading.show(context, tip: '提交中');
SantoLoading.dismiss(context);
```

## 版本变更

### v1.1.0

- **新增**: `SantoLoading` 统一加载组件,新增 `size` / `tip` / `spinning` / `delay` / `indicator` / `percent` / `fullscreen` / `color` / `overlayColor` 参数
- **新增**: 三档尺寸 `SantoLoadingSize`,指示器 14 / 20 / 32
- **新增**: 静态方法 `SantoLoading.show` / `SantoLoading.dismiss`
- **删除**: `SantoPageLoading`、`SantoLoadingDialog`(浮层能力由 `show` / `dismiss` 承接)
- **变更**: 浮层文案参数由 `content` 改为 `tip`

### v1.0.0

- 初始版本发布(`SantoPageLoading`、`SantoLoadingDialog`)
