---
title: SantoCascader
group:
  title: 级联选择器
  order: 1
---

# SantoCascader

多级联动选择器(如省/市/区),底部弹出式选择器。

## 一、效果总览

- 支持多级数据联动选择
- 底部弹出式交互
- 可自定义列数
- 支持初始选中值

## 二、描述

### 适用场景
1. 省市区三级地址选择
2. 组织架构选择(公司/部门/小组)
3. 商品分类选择(一级/二级/三级分类)
4. 任何具有层级关系的数据选择

### 使用规范
- 通过 `SantoCascader.show()` 静态方法打开选择器
- data 必须是树形结构,每个节点包含 label、value 和可选的 children
- columnCount 决定显示的列数,应与数据层级匹配
- initialValues 用于回显已选中的值,长度应等于 columnCount

## 三、构造函数及参数说明

### SantoCascader.show()

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| context | BuildContext | 上下文 | 是 | - |
| data | List\<SantoCascaderItem\> | 树形数据源 | 是 | - |
| title | String? | 选择器标题 | 否 | null |
| columnCount | int | 显示的列数 | 否 | 3 |
| initialValues | List\<String\>? | 初始选中的值列表 | 否 | null |
| onConfirm | SantoCascaderConfirmCallback? | 确认回调 | 否 | null |
| onCancel | SantoCascaderCancelCallback? | 取消回调 | 否 | null |
| confirmText | String | 确认按钮文字 | 否 | '确认' |
| cancelText | String | 取消按钮文字 | 否 | '取消' |
| activeColor | Color? | 主题色 | 否 | null(brandPrimary) |

### SantoCascaderItem

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| label | String | 显示文本 | 是 | - |
| value | String | 唯一标识 | 是 | - |
| children | List\<SantoCascaderItem\>? | 子节点列表 | 否 | null |

## 四、示例代码

### 省市区选择

```dart
final addressData = [
  SantoCascaderItem(
    label: '北京市',
    value: 'beijing',
    children: [
      SantoCascaderItem(
        label: '朝阳区',
        value: 'chaoyang',
        children: [
          SantoCascaderItem(label: '三里屯街道', value: 'sanlitun'),
          SantoCascaderItem(label: '建国门街道', value: 'jianguomen'),
        ],
      ),
    ],
  ),
];

SantoCascader.show(
  context: context,
  data: addressData,
  title: '选择地址',
  onConfirm: (selectedItems) {
    print('Selected: ${selectedItems.map((e) => e.label).join(' / ')}');
  },
);
```

### 两级分类选择

```dart
SantoCascader.show(
  context: context,
  data: categoryData,
  columnCount: 2,
  title: '选择分类',
  onConfirm: (items) {},
);
```

### 带初始值

```dart
SantoCascader.show(
  context: context,
  data: addressData,
  initialValues: ['beijing', 'chaoyang', 'sanlitun'],
  onConfirm: (items) {},
);
```
