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
- 默认刷新头部是主题 `fillBody` 底色的圆角(主题 `radiusMd`)区域,配合列表视觉不突兀

## 二、描述

### 适用场景
1. 列表数据刷新(如新闻列表、商品列表)
2. 分页加载更多数据
3. 需要实时更新的Feed流
4. 任何需要上拉/下拉加载的场景

### 使用规范
- child 必须为可滚动组件(ListView/CustomScrollView等)
- onRefresh 和 onLoadMore 至少实现一个
- hasMore 用于控制是否还有更多数据,为 false 时不再触发加载
- controller 可用于外部代码触发刷新(如点击刷新按钮)
- refreshTimeout 为 null 时关闭超时机制

## 三、构造函数及参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| child | Widget | 滚动内容 | 是 | - |
| controller | SantoRefreshController? | 外部主动刷新控制器 | 否 | null |
| onRefresh | Future\<void\> Function()? | 下拉刷新回调 | 否 | null |
| onLoadMore | Future\<void\> Function()? | 触底加载回调 | 否 | null |
| onStateChanged | ValueChanged\<SantoRefreshState\>? | 刷新状态变化回调 | 否 | null |
| loadingBarHeight | double | 触发刷新阈值 | 否 | 50 |
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
