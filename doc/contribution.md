---
order: 5
---

# 贡献指南

这篇指南会指导你如何为 Santo 做贡献。在提 issue 或者 pull request 之前,请花几分钟阅读这篇指南。

### 开发环境要求

- Flutter SDK >= 3.3.0
- Dart SDK >= 2.18.0
- 推荐使用 VS Code 或 Android Studio

### 分支管理

主分支为 `main`,所有新功能开发基于 main 分支创建 feature 分支。Bug 修复根据影响的版本选择对应分支。

### 代码规范

1. **组件命名**: 所有组件以 `Santo` 开头,如 `SantoButton`、`SantoDialog`
2. **文件命名**: 使用 snake_case,如 `santo_button.dart`、`santo_dialog.dart`
3. **文档规范**: 每个公共组件必须有对应的文档,放在 `doc/components/` 目录下
4. **示例代码**: 在 `example/lib/sample/` 下提供组件使用示例

### 如何贡献

如果你想处理一个 issue,请先检查[现有 issue 列表](https://github.com/LianjiaTech/santo_ui/issues)确保没有别人正在处理。如果当前没有人在处理,可以留言认领。

在发送 pull request 之前,请确认按照以下步骤操作:

1. 基于正确的分支做修改(feature 分支或 bugfix 分支)
2. 运行 `dart analyze lib example/lib` 确保无静态检查错误
3. 运行 `flutter test test` 确保测试通过(如有)
4. 在 `example` 目录下运行相关 demo 确认功能正常
5. 为新功能或修改补充文档

Santo 团队会 review 所有的 pull request,合并符合规范的代码,并在 review 过程中提供反馈。

### 文档贡献

- 新增组件必须同步添加文档
- 文档格式参考现有组件文档模板
- 文档应包含:组件说明、适用场景、参数说明、示例代码
- 文档位置: `doc/components/<组件分类>/<组件名>.md`

### 加入我们

Santo 经过多条业务线累计上万次的引用,仍在不断迭代优化。如果你在使用过程中遇到问题或有改进建议,欢迎提 [issue](https://github.com/LianjiaTech/santo_ui/issues/new) 与我们交流。我们期待与你一起将 Santo 打造成 Flutter 生态中最有影响力的组件项目之一。
