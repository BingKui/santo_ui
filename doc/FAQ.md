---
order: 6
---

# FAQ

#### 如何找到适配 Flutter SDK 版本？

版本与 SDK 对应关系见 [Santo 概览](./santo_ui) 的「适配 Flutter SDK 版本」表,以工程根目录 `pubspec.yaml` 的 `environment` 为准。

#### 主题定制没生效可能原因？

请确定在 <code>main.dart</code> 中注册，如果正确注册仍没有生效，欢迎到[仓库](https://github.com/BingKui/santo_ui)提 issue

#### 会提供独立组件拆分依赖吗？

Santo 是作为整套解决方案输出，因此没有做组件拆分，以后也将不会对组件进行拆分。

#### 多渠道主题定制怎么做？

可以参照 [主题定制](./theme) 部分注册每个渠道配置，注册时需要指定不同的 <code>CONFIG_ID</code> ，并且要保证这些 <code>CONFIG_ID</code> 是唯一的，渠道使用时通过注册的 <code>CONFIG_ID</code> 取相应的配置即可生效。

#### 不会使用 Sketch 插件怎么办？

通过阅读这篇文章 [Sketch 设计指引](./sketch) 你将快速了解并完成你的设计。

#### 遇到问题怎么办？

欢迎到[仓库](https://github.com/BingKui/santo_ui)提 issue 或提交 merge request,我们会定期查阅;如果你已经有了解法,也欢迎直接提 MR。


