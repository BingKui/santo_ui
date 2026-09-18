---
order: 5
---

# 贡献指南

这篇指南会指导你如何为 Santo 做贡献。在提 issue 或者 pull request 之前,请花几分钟阅读这篇指南。

### 开发环境要求

- Flutter SDK >= 3.10.0
- Dart SDK ^3.13.3
- 推荐使用 VS Code 或 Android Studio

### 分支管理

主分支为 `main`,所有新功能开发基于 main 分支创建 feature 分支。Bug 修复根据影响的版本选择对应分支。

### 代码规范

1. **组件命名**: 所有组件以 `Santo` 开头,如 `SantoButton`、`SantoDialog`
2. **文件命名**: 使用 snake_case,如 `santo_button.dart`、`santo_dialog.dart`
3. **文档规范**: 每个公共组件必须有对应的文档,放在 `doc/components/<分类>/santo_<组件>.md`
4. **示例代码**: 在 `example/lib/sample/` 下提供组件使用示例,同一组件的示例合并到单页、按 `SantoSection` 分块
5. **组件约定**: 底部安全区域处理、内容区与块间距取哪个令牌等,见根目录 [AGENTS.md](../AGENTS.md)

### 如何贡献

如果你想处理一个 issue,请先到[仓库](https://codeup.aliyun.com/67ee24d7b8d84778e0e7ee11/SantoUI)确认没有别人正在处理。如果当前没有人在处理,可以留言认领。

在提交 merge request 之前,请确认按照以下步骤操作:

1. 基于正确的分支做修改(feature 分支或 bugfix 分支)
2. 运行 `dart analyze lib example/lib` 确保无静态检查错误
3. 运行 `flutter test test` 确保测试通过(如有)
4. 在 `example` 目录下运行相关 demo 确认功能正常
5. 为新功能或修改补充文档

Santo 团队会 review 所有的 merge request,合并符合规范的代码,并在 review 过程中提供反馈。

### 文档贡献

- 新增组件必须同步添加文档
- 文档格式参考现有组件文档模板
- 文档应包含:组件说明、适用场景、参数说明、示例代码
- 文档位置: `doc/components/<组件分类>/<组件名>.md`

### 加入我们

Santo 仍在持续迭代优化。如果你在使用过程中遇到问题或有改进建议,欢迎到[仓库](https://codeup.aliyun.com/67ee24d7b8d84778e0e7ee11/SantoUI)提 issue 与我们交流。
