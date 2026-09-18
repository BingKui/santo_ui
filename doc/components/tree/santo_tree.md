---
title: SantoTree
group:
  title: 树形控件
  order: 1
---

# SantoTree

层级数据展示和选择,支持展开/收起节点、单选/多选、自定义节点内容。

## 一、效果总览

- 树形层级结构展示
- 支持节点展开/收起
- 支持单选和多选模式
- 可自定义节点内容
- 选中状态高亮显示

## 二、描述

### 适用场景
1. 组织架构展示和选择
2. 文件目录树
3. 分类层级选择
4. 权限配置中的资源树选择

### 使用规范
- data 为树形数据,每个节点包含 label、value 和可选的 children
- multiple 为 true 时启用多选,配合 selectedValues 控制选中项
- nodeBuilder 可完全自定义节点渲染逻辑
- onNodeTap 和 onNodeExpand 分别处理点击和展开事件

## 三、构造函数及参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| data | List\<SantoTreeNode\> | 树形数据 | 是 | - |
| multiple | bool | 是否多选模式 | 否 | false |
| onNodeTap | SantoTreeNodeTapCallback? | 节点点击回调 | 否 | null |
| onNodeExpand | SantoTreeNodeExpandCallback? | 节点展开/收起回调 | 否 | null |
| nodeBuilder | SantoTreeNodeBuilder? | 自定义节点构建器 | 否 | null |
| selectedValues | List\<String\>? | 选中值列表(多选模式) | 否 | null |
| onSelectionChanged | ValueChanged\<List\<String\>\>? | 选中值变化回调 | 否 | null |
| activeColor | Color? | 主题色 | 否 | null(brandPrimary) |
| indentWidth | double | 缩进宽度 | 否 | 24 |
| nodeHeight | double | 节点高度 | 否 | 44 |

### SantoTreeNode

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| label | String | 显示文本 | 是 | - |
| value | String | 唯一标识 | 是 | - |
| children | List\<SantoTreeNode\>? | 子节点列表 | 否 | null |
| expanded | bool | 是否展开 | 否 | false |
| icon | IconData? | 节点图标 | 否 | null |
| data | dynamic | 附加数据 | 否 | null |

## 四、示例代码

### 基础用法(单选)

```dart
SantoTree(
  data: [
    SantoTreeNode(
      label: '根节点',
      value: 'root',
      children: [
        SantoTreeNode(label: '子节点1', value: 'child1'),
        SantoTreeNode(label: '子节点2', value: 'child2'),
      ],
    ),
  ],
  onNodeTap: (node) {
    print('Tapped: ${node.label}');
  },
)
```

### 多选模式

```dart
SantoTree(
  data: treeData,
  multiple: true,
  selectedValues: const ['node1', 'node3'],
  onSelectionChanged: (values) {
    print('Selected: $values');
  },
)
```

### 自定义节点

```dart
SantoTree(
  data: treeData,
  nodeBuilder: (context, node, level, expanded, onTap, onToggle) {
    return ListTile(
      leading: Icon(node.icon ?? Icons.folder),
      title: Text(node.label),
      trailing: node.children != null
          ? IconButton(
              icon: Icon(expanded ? Icons.expand_more : Icons.chevron_right),
              onPressed: () => onToggle(node),
            )
          : null,
      onTap: () => onTap(node),
    );
  },
)
```
