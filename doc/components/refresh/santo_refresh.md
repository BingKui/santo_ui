---
title: SantoRefresh
group:
  title: 下拉刷新
  order: 1
---

# SantoRefresh

下拉刷新 + 触底加载组件,对齐 TDesign PullDownRefresh 四态行为。支持刷新超时、四态文案自定义与外部主动刷新。

## 一、效果总览

- 支持下拉刷新和触底加载
- 四态提示:inactive/dragging/ready/refreshing/done/timeout
- 支持刷新超时自动结束
- 支持外部控制器主动触发刷新
- 可自定义刷新头部和加载底部
- 默认刷新头部为透明背景,仅展示加载图标与提示文案;下拉时头部真实撑开顶部区域、内容整体下移(纯绘制平移,不挤压列表视口,既不抖动也不遮挡内容)
- 刷新完成态展示成功图标(主题 `brandSuccess` 色)与「刷新完成」文案,并保持到头部完全收起
- 下拉存在安全区域:下拉距离未达 `triggerDistance` 时不展示任何提示、松手也不触发刷新

## 二、描述

### 适用场景
1. 列表数据刷新(如新闻列表、商品列表)
2. 分页加载更多数据
3. 需要实时更新的Feed流
4. 任何需要上拉/下拉加载的场景

### 使用规范
- child 必须为可滚动组件(ListView/CustomScrollView等)
- onRefresh 和 onLoadMore 至少实现一个
- 下拉距离未达 triggerDistance 时既不展示提示也不触发刷新;达到后才展示「松手刷新」,松手才发起刷新
- hasMore 用于控制是否还有更多数据,为 false 时不再触发加载
- controller 可用于外部代码触发刷新(如点击刷新按钮)
- refreshTimeout 为 null 时关闭超时机制
- 内容里自带滚动的嵌套容器(如设了 `height` 的 Table、内嵌 ListView)滚到顶部后继续下拉时,手势由 SantoRefresh 接管:同样撑开刷新头并触发刷新,嵌套容器自身不越界回弹(下拉时随页面内容整体下移)。需要嵌套容器不在边界处越界回弹时,在内容外层用 `ScrollConfiguration` 指定 `ClampingScrollPhysics`(用 `SantoPageLayout` 的刷新模式已内置该处理)
- 触底加载只认 SantoRefresh 直接承载的滚动容器,嵌套容器滚到底不会触发 onLoadMore

## 三、构造函数及参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| child | Widget | 滚动内容 | 是 | - |
| controller | SantoRefreshController? | 外部主动刷新控制器 | 否 | null |
| onRefresh | Future\<void\> Function()? | 下拉刷新回调 | 否 | null |
| onLoadMore | Future\<void\> Function()? | 触底加载回调 | 否 | null |
| onStateChanged | ValueChanged\<SantoRefreshState\>? | 刷新状态变化回调 | 否 | null |
| loadingBarHeight | double | 刷新头部高度(刷新进行中头部停留高度) | 否 | 50 |
| triggerDistance | double | 触发刷新所需的下拉距离(安全区域高度),未达不展示提示、松手不刷新;不能大于 maxBarHeight | 否 | 50 |
| maxBarHeight | double | 最大下拉高度 | 否 | 80 |
| lowerThreshold | double | 触底加载触发距离 | 否 | 50 |
| refreshTimeout | Duration? | 刷新超时时长,null 关闭超时 | 否 | 3秒 |
| successDuration | Duration | 刷新完成提示展示时长 | 否 | 500ms |
| texts | SantoRefreshTexts? | 四态提示语 | 否 | null |
| hasMore | bool | 是否还有更多数据 | 否 | true |
| refreshHeader | Widget Function(SantoRefreshState, double)? | 自定义刷新头部 | 否 | null |
| loadMoreFooter | Widget Function(bool)? | 自定义加载更多底部 | 否 | null |

## 四、示例代码

### 基础下拉刷新

```dart
SantoRefresh(
  onRefresh: () async {
    await fetchData();
  },
  child: ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) => ListTile(title: Text(items[index])),
  ),
)
```

### 自定义触发距离(安全区域)

```dart
SantoRefresh(
  // 下拉 100 以内不展示提示、松手也不刷新
  triggerDistance: 100,
  maxBarHeight: 140,
  onRefresh: () async {
    await fetchData();
  },
  child: ListView.builder(...),
)
```

### 下拉刷新 + 触底加载

```dart
SantoRefresh(
  onRefresh: () async {
    setState(() {
      page = 1;
      items.clear();
    });
    await loadItems(page);
  },
  onLoadMore: () async {
    if (!hasMore) return;
    page++;
    await loadItems(page);
  },
  hasMore: hasMore,
  child: ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) => ListTile(title: Text(items[index])),
  ),
)
```

### 外部控制刷新

```dart
final refreshController = SantoRefreshController();

Column(
  children: [
    IconButton(
      icon: const Icon(Icons.refresh),
      onPressed: () => refreshController.refresh(),
    ),
    Expanded(
      child: SantoRefresh(
        controller: refreshController,
        onRefresh: () async {
          await fetchData();
        },
        child: ListView(...),
      ),
    ),
  ],
)
```

### 自定义提示文案

```dart
SantoRefresh(
  onRefresh: () async {},
  texts: const SantoRefreshTexts(
    pull: '下拉即可刷新',
    ready: '释放立即刷新',
    refreshing: '正在刷新...',
    done: '刷新成功',
    timeout: '刷新超时',
    noMore: '没有更多了',
  ),
  child: ListView(...),
)
```

## 五、版本变更

### v1.5.0

- **修复**: 内容里自带滚动的嵌套容器(如设了 `height` 的 Table、内嵌 ListView)滚到顶部后继续下拉时,手势被嵌套容器独占 —— 刷新头不出现、松手也不触发刷新,嵌套内容反而自己越界回弹。现在嵌套容器在顶部边界的下拉由 SantoRefresh 接管,与页面自身滚动容器行为一致
- **修复**: 刷新头部恢复为下拉时撑开顶部区域并整体下移内容(纯绘制平移,视口高度不变),刷新区域不再是一个盖在列表上的透明浮层 —— 区域内始终承载刷新头内容(图标与提示文案),不再与首条内容重叠
- **注意事项**: 嵌套容器的横向滚动与刷新无关,不参与下拉;触底加载只认 SantoRefresh 直接承载的滚动容器

### v1.3.0

- **新增**: `triggerDistance` 参数,指定触发刷新所需的下拉距离(安全区域高度),默认 50。未达该距离时头部不展示任何提示、松手也不触发刷新;达到后才展示「松手刷新」,松手即刷新
- **变更**: `loadingBarHeight` 不再兼作触发阈值,只表示刷新头部高度(刷新进行中头部停留的高度),是否可触发改由 `triggerDistance` 判定
- **注意事项**: `triggerDistance` 不能大于 `maxBarHeight`,否则下拉永远到不了触发距离(已加断言)

### v1.0.0

- 初始版本发布
