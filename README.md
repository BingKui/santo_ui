# Santo UI

企业级 Flutter 组件库(参考 [Bruno](https://github.com/LianjiaTech/bruno) 构建)。提供统一主题定制、多主题 configId 注册、开箱即用的移动端组件。

## 工程结构

```
santo_ui/
├── lib/
│   ├── santo_ui.dart                 # 统一出口:import 'package:santo_ui/santo_ui.dart'
│   └── src/
│       ├── theme/                    # 主题系统(SantoThemeConfigurator + 各组件 Config)
│       └── components/               # 按分类组织的 31 类组件
├── example/                          # 示例 App(分类导航 + 各组件示例页)
├── doc/                              # 文档站源文件(组件 md + 指南)
│   ├── start.md / theme.md / contribution.md / FAQ.md
│   └── components/<分类>/<组件>.md
├── tool/gen_doc.dart                 # 参数表生成 + 文档校验脚本
└── test/                             # 单元测试
```

## 快速接入

```yaml
dependencies:
  santo_ui: ^0.1.0
```

```dart
import 'package:santo_ui/santo_ui.dart';

// 注册公司品牌主题(可选,不注册则使用默认主题)
SantoThemeConfigurator.instance.register(
  SantoAllThemeConfig(commonConfig: SantoCommonConfig(brandColor: Color(0xFF3C7AF0))),
);

SantoBigMainButton(title: '提交', onTap: () {});
SantoToast.show('保存成功', context);
showSantoDialog(context: context, title: '提示', message: '确认删除?');
```

## 组件覆盖

| 分类 | 内容 |
| --- | --- |
| 基础与布局 | AppBar/搜索导航栏、TabBar、锚点联动、分割线/虚线、阴影卡片、卡片标题、步骤条 |
| 按钮 | 大主/幽灵/描边按钮、小按钮、图标按钮、按钮组/吸底面板 |
| 文本与标签 | 可展开文本、气泡文本、通知栏、标签系列 |
| 表单 | 输入/单选/多选/选择/范围/开关/星级等表单项 + 分组、InputText、SearchText、Checkbox/Radio |
| 弹窗与浮层 | Dialog 系列、Loading、Toast、气泡浮层、ActionSheet 系列 |
| 选择器 | 底部滚轮 Picker、多级联动、日期/区间、日历、城市选择、筛选器系列 |
| 信息展示 | 空态/异常页、新手引导、评分、评价、信息表/宫格、画廊、图表系列 |

完整清单与用法见 `doc/components/`;示例运行 `cd example && flutter run`。

## 开发

```bash
flutter pub get
dart analyze lib            # 静态检查
flutter test                # 单元测试
dart run tool/gen_doc.dart --all     # 生成组件参数表
dart run tool/gen_doc.dart --check   # 校验组件均有文档
dart doc                    # API Reference(--output doc/api)
```

## 许可

MIT。组件库移植自 [Bruno](https://github.com/LianjiaTech/bruno)(MIT),保留原项目版权声明。
