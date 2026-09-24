---
title: SantoChat
group:
  title: 会话
  order: 1
---

# SantoChat

会话组件承载双方的往来消息与底部输入区,参考 flutter_chat_ui、chatview 与 DevOpsMobile 的能力面设计。
库内提供一站式总装 `SantoChat`,同时把所有原子组件导出,业务可以按需自行拼装。

## 一、效果总览

- **双方消息**:按 `currentUserId` 自动分列左右,我方是浅色底气泡(主题色 10% 透明),对方是白底气泡
- **消息状态**:我方消息按 `status` 展示状态图标——发送中时钟、已发送单勾、已送达双勾、已读双勾(主题色)贴头像一侧;
  失败时改在**非头像一侧**(我方气泡的左边)展示实心警示图标(`warning-square-solid`,相对气泡上下居中),
  点它触发 `onRetry` 重发
- **@与表情**:`@展示名` 命中 `mentions` 时高亮可点,`[表情名]` 命中注册表时渲染成表情图,
  `http(s)://` 链接自动变色可点,`isEdited` 为 true 时在气泡内展示「已编辑」
- **长按菜单**:气泡旁浮层,顶部一排表情回应、下面是操作区;表情与操作项都按**块级排列
  (上图标 + 下文案)**,一排最多 5 个、多出的换行(超过 10 项时排到第三排),
  默认按消息类型给项(文本有复制/编辑、语音有转文字、只有自己的消息能删除),可整表自定义
- **系统消息**:居中弱化提示,不带头像与气泡
- **引用消息**:气泡内先渲染引用块,我方与对方样式一致,点击回调业务跳回原消息
- **图片/视频消息**:按宽高比取展示尺寸;视频额外展示封面、时长与播放按钮
- **语音/文件消息**:波形 + 时长、文件名 + 大小,播放、转文字与下载交给业务
- **文档消息**:一张文档卡片(标题 + 附言 + 「点击查看文档」),**自带白底与描边、不套气泡**,
  点击回调 `onDocTap`,由业务方校验权限后打开文档(对标 DevOpsMobile 的文档链接卡片)
- **消息列表**:时间分隔、同发送者分组、滑动引用回复、长按菜单、双击快捷回应、上拉加载更早消息、回到底部
- **编辑消息**:长按「编辑」→ 输入区进入编辑态并预填内容 → 提交回调业务替换消息
- **多选**:勾选框 + 底部操作栏(已选条数、转发/删除、取消)
- **底部输入区**:白底铺满底部安全区域,**没有发送按钮**(发送走输入法发送键);
  点表情按钮展开**内置表情面板**(默认 32 个,点选把 `[表情名]` 插到光标处),
  点 `+` 展开**扩展菜单**(默认照片/拍摄/文件),点输入框收起面板唤起输入法;
  两个面板**共用固定高度 230**(`kSantoChatPanelHeight`),互相切换、与输入法切换时高度都不跳;
  面板内容用**网格布局**、**左上角起排**、单元格尺寸固定、不足一页的空位保留,
  一页放不下的**左右滑动翻页**,多于一页时底部显示分页指示点;
  扩展菜单 5 列 **2 排**(`kSantoChatMenuItemRows`,一页 10 项),每个入口图标贴格子左侧、文案在图标宽度内居中;
  表情面板 8 列 **4 排**(`kSantoChatEmojiRows`,一页 32 个),表情在格子内居中
- **会话列表**:`SantoChatList` 展示未读角标、置顶标记与免打扰静音角标

## 二、描述

### 适用场景

1. 单聊/群聊的会话窗口(IM、客服、协作评论)
2. 需要展示双方往来记录并允许继续发送内容

### 使用规范

- 消息列表按**时间正序**(旧 → 新)传入,`SantoChatMessageList` 内部按 `reverse` 决定排布,
  默认 `reverse: true` 让最新消息贴在底部
- 会话要撑满一屏(而不是嵌在固定高度里)时,放在 `Scaffold` 的 body 即可:
  Scaffold 默认 `resizeToAvoidBottomInset: true`,输入法弹出时页面缩短、输入区自然停在输入法上方
- 长按菜单与多选操作栏只负责展示与回调,复制/转发/删除/编辑等具体行为由业务方实现;
  菜单项里的 `quote` 会自动接到 `onReply`,不用重复实现
- 表情图片资源由业务方注册,库内不内置表情图
- 语音与视频的播放、语音转文字、图片预览、文件下载都由业务方在回调里实现,库内不引入播放器依赖
- 输入区底部安全区域**固定预留**、不提供开关;贴底使用时组件自带白底铺满安全区

## 三、组件构成

| 组件 | 说明 |
| --- | --- |
| `SantoChat` | 总装:头部 + 消息列表 + 输入区(多选态换成操作栏) |
| `SantoChatMessageList` | 消息列表:时间分隔、分组、滑动回复、长按菜单、多选、加载更多、回到底部 |
| `SantoChatBubble` | 单个气泡:左右分栏、头像、昵称、时间、状态、已编辑、引用、回应 |
| `SantoChatInput` | 底部输入区:插槽、回复/编辑条、扩展菜单、安全区 |
| `SantoChatSelectionBar` | 多选操作栏:已选条数 + 操作项 + 取消 |
| `SantoChatList` | 会话列表:会话行、未读角标、置顶、免打扰 |
| `SantoChatText` | 会话富文本:@提及、表情、链接 |
| `SantoChatQuoteView` | 引用块 |
| `SantoChatImage` / `SantoChatVideo` | 图片、视频消息内容 |
| `SantoChatVoice` / `SantoChatFile` | 语音、文件消息内容 |
| `SantoChatDocCard` | 文档消息卡片:标题 + 附言 + 「点击查看文档」,自带容器不套气泡 |
| `SantoChatSystemNotice` | 系统消息 |
| `SantoChatTypingIndicator` | 对方正在输入 |
| `SantoChatMessageMenu` | 长按浮层菜单(表情回应 + 操作列表) |
| `SantoChatReactionView` | 表情回应展示(气泡下方的胶囊) |

## 四、数据模型

| 类型 | 说明 |
| --- | --- |
| `SantoChatAuthor` | 会话参与者:`id` / `name` / `avatarUrl` |
| `SantoChatMention` | 被 @ 的成员:`id` / `display`,`parse(text, candidates)` 可从文本解析命中项 |
| `SantoChatQuote` | 引用信息:`messageId` / `title` / `preview` / `thumbnailUrl` |
| `SantoChatReaction` | 表情回应:`emoji` / `count` / `reactedByMe` |
| `SantoChatMenuItem` | 菜单项:`key` / `label` / `icon` / `danger`;`defaults(message, isMine:)` 给默认项 |
| `SantoChatExtension` | 扩展菜单项:`key` / `label` / `icon`;`defaults` 为照片、拍摄、文件 |
| `SantoChatEmoji` | 表情:`name` / `symbol`,`token` 为插入输入框的 `[name]`;内置表 `kSantoChatDefaultEmojis`(32 个,与 DevOpsMobile 一致) |
| `SantoChatMessage` | 消息基类:`id` / `author` / `createdAt` / `status` / `quote` / `reactions` / `isEdited` |
| `SantoChatTextMessage` | 文本消息,额外带 `text` 与 `mentions` |
| `SantoChatImageMessage` | 图片消息,`url` 与展示尺寸/original 尺寸 |
| `SantoChatVideoMessage` | 视频消息,`url` / `coverUrl` / `duration` |
| `SantoChatVoiceMessage` | 语音消息,`url` / `duration` / 可选 `waveform` |
| `SantoChatFileMessage` | 文件消息,`url` / `name` / `size` |
| `SantoChatDocMessage` | 文档消息,`title` / `docId` / `spaceId` / `url` / 可选 `content`(附言) |
| `SantoChatSystemMessage` | 系统消息,只有 `text`(`author` 为 null) |
| `SantoChatConversation` | 会话行:`title` / `avatarUrl` / `preview` / `updatedAt` / `unreadCount` / `pinned` / `muted` |

消息状态 `SantoChatMessageStatus` 取值:`sending`(发送中)、`sent`(已发送)、
`delivered`(已送达)、`read`(已读)、`failed`(失败)。前四种在头像一侧展示对应图标;
`failed` 改在**非头像一侧**展示实心警示图标(`SantoSolidIcons.warningSquare`,`solid: true`),
相对气泡上下居中(与气泡同一行排布,不用额外的高度计算),点击回调 `onRetry` 重发。

`SantoChatEmojiRegistry` 是全局表情注册表,App 启动时注册一次:

```dart
SantoChatEmojiRegistry.registerAll(<String, String>{
  '微笑': 'assets/emoji/smile.png',
  '赞': 'https://cdn.example.com/emoji/like.png',
});
```

地址以 `http` 开头按网络图加载,否则按包内资源加载;未注册的表情名保留原文。
输入区点选的表情插入的是 `[表情名]` token:注册过同名表情图时渲染成图,
没注册时按内置 Unicode 表情渲染(见 [SantoChatEmoji])。

## 五、构造函数及参数说明

### SantoChat

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| messages | List\<SantoChatMessage\> | 消息列表,按时间正序传入 | 是 | - |
| currentUserId | String | 当前登录用户 id | 是 | - |
| onSend | ValueChanged\<String\>? | 提交回调(发送与编辑态提交共用),回调后输入框自动清空 | 否 | null |
| showAvatar / showName | bool | 是否展示头像 / 对方昵称 | 否 | true / false |
| empty / header | Widget? | 空状态 / 列表上方的固定区域(如群公告) | 否 | null |
| inputLeading / inputTrailing | Widget? | 输入区左右插槽(语音、表情) | 否 | null |
| inputHintText | String | 输入框提示文案 | 否 | 请输入内容 |
| inputEnabled | bool | 输入区是否可输入 | 否 | true |
| extensions | List\<SantoChatExtension\> | 扩展菜单项,传空数组则不展示 `+` 入口 | 否 | 照片、拍摄、文件 |
| onExtensionTap | ValueChanged\<SantoChatExtension\>? | 点选扩展菜单项 | 否 | null |
| emojis | List\<SantoChatEmoji\> | 表情面板里的表情,传空数组则不展示表情入口 | 否 | 内置 32 个 |
| replyTo | SantoChatQuote? | 当前回复的消息 | 否 | null |
| onCancelReply | VoidCallback? | 取消回复 | 否 | null |
| editingText | String? | 正在编辑的消息内容,不为空时输入区进入编辑态 | 否 | null |
| onCancelEdit | VoidCallback? | 取消编辑 | 否 | null |
| typingAuthor | SantoChatAuthor? | 正在输入的对方 | 否 | null |
| playingMessageId | String? | 正在播放的语音消息 id | 否 | null |
| reactions | List\<String\> | 长按可选的表情回应 | 否 | 👍 ❤️ 😂 😮 😢 |
| messageMenuItems | List\<SantoChatMenuItem\> Function(SantoChatMessage, bool)? | 自定义长按菜单项 | 否 | 按类型取默认 |
| onMessageMenuSelected | void Function(SantoChatMessage, SantoChatMenuItem)? | 选择菜单项 | 否 | null |
| selectionMode | bool | 是否处于多选态,多选态下输入区换成操作栏 | 否 | false |
| selectedIds | Set\<String\> | 多选已选中的消息 id | 否 | 空 |
| onSelectionToggle | ValueChanged\<SantoChatMessage\>? | 切换某条消息的选中状态 | 否 | null |
| selectionActions | List\<SantoChatMenuItem\> | 多选操作栏的操作项 | 否 | 转发、删除 |
| onSelectionAction | ValueChanged\<SantoChatMenuItem\>? | 多选操作 | 否 | null |
| onCancelSelection | VoidCallback? | 退出多选 | 否 | null |
| hasMore / loadingMore | bool | 是否还有更早的消息 / 是否正在加载 | 否 | false |
| showScrollToBottom | bool | 是否展示「回到底部」悬浮按钮 | 否 | true |
| listPadding | EdgeInsetsGeometry? | 列表内边距 | 否 | null |
| onLoadMore | VoidCallback? | 滚动到顶部加载更多 | 否 | null |
| onReply | ValueChanged\<SantoChatMessage\>? | 滑动气泡或菜单「引用」引用回复 | 否 | null |
| onMessageTap | ValueChanged\<SantoChatMessage\>? | 点击消息 | 否 | null |
| onMessageLongPress | ValueChanged\<SantoChatMessage\>? | 长按消息 | 否 | null |
| onMessageDoubleTap | ValueChanged\<SantoChatMessage\>? | 双击消息 | 否 | null |
| onReaction | void Function(SantoChatMessage, String)? | 选择表情回应 | 否 | null |
| onMentionTap | ValueChanged\<SantoChatMention\>? | 点击 @提及 | 否 | null |
| onLinkTap | ValueChanged\<String\>? | 点击链接 | 否 | null |
| onQuoteTap | ValueChanged\<SantoChatQuote\>? | 点击引用块 | 否 | null |
| onRetry | ValueChanged\<SantoChatMessage\>? | 点击非头像一侧的失败警示图标重发 | 否 | null |
| onDocTap | ValueChanged\<SantoChatDocMessage\>? | 点击文档卡片 | 否 | null |

### SantoChatMessageList

与 `SantoChat` 同名的参数含义一致,另有:

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| reverse | bool | 是否倒序(最新消息在底部) | 否 | true |
| timeGroupWindow | Duration | 超过该间隔插入时间分隔 | 否 | 5 分钟 |
| controller | ScrollController? | 外部滚动控制器 | 否 | null |
| padding | EdgeInsetsGeometry? | 列表内边距 | 否 | null |

列表能力说明:

- **会话底色**:消息列表自带 `SantoChatConfig.backgroundColor`(默认 `fillBody` 灰)作画布,
  否则对面的白气泡在白底页面上看不见;需要透明时把主题里的 `chatConfig.backgroundColor`
  配成透明即可
- 时间分隔:相邻消息间隔超过 `timeGroupWindow` 或跨天时插入,文案为
  「今天/昨天/月-日/年-月-日」+ 时分(由 `formatChatTime` 生成)
- 分组:同一发送者的连续消息只在该组第一条展示头像与昵称
- 长按:同时触发 `onMessageLongPress` 与内置菜单;想关掉内置菜单把 `reactions` 传空数组
  且 `onMessageMenuSelected`/`onReply` 传 null
- 双击:同时触发 `onMessageDoubleTap` 与第一个表情的快捷回应
- 多选态:`selectionMode` 为 true 时左侧出现勾选框、点整行切换选中,
  此时不响应点击消息、滑动引用与长按菜单
- `SantoChatSystemMessage` 自动渲染成居中提示,不参与分组、头像与菜单逻辑
- `SantoChatDocMessage` 自动渲染成 `SantoChatDocCard` 并切成**裸气泡**(`SantoChatBubble.bare`),
  卡片自带白底与描边;点击走 `onDocTap`

### SantoChatBubble

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| child | Widget | 气泡内容 | 是 | - |
| author | SantoChatAuthor? | 发送者,用于头像与昵称 | 否 | null |
| isMine | bool | 是否我方消息,决定左右与配色 | 否 | false |
| showAvatar / showName / showTime | bool | 是否展示头像 / 昵称 / 时间 | 否 | true / false / false |
| time | DateTime? | 展示的时间 | 否 | null |
| quote | SantoChatQuote? | 引用信息 | 否 | null |
| status | SantoChatMessageStatus | 发送状态,展示在我方气泡左侧 | 否 | sent |
| isEdited | bool | 是否展示「已编辑」标记 | 否 | false |
| reactions | List\<SantoChatReaction\> | 表情回应,展示在气泡下方 | 否 | 空 |
| contentPadding | EdgeInsetsGeometry? | 内容区内边距,图片/视频传 `EdgeInsets.zero` 铺满气泡 | 否 | 主题气泡内边距 |
| bare | bool | 内容自带容器(文档卡片):不画气泡底色与内边距 | 否 | false |
| backgroundColor / textColor / avatar | - | 背景色、文字色、自定义头像 | 否 | 按主题 |
| onTap / onLongPress / onDoubleTap / onRetry / onQuoteTap / onReactionTap | 回调 | 交互回调 | 否 | null |

### SantoChatInput

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| controller / focusNode | - | 文本与焦点控制器 | 否 | 内部创建 |
| onSend | ValueChanged\<String\>? | 提交回调,回调后清空输入框;编辑态提交也走它 | 否 | null |
| hintText | String | 提示文案,**不换行**,超出输入框宽度时直接省略 | 否 | 请输入内容 |
| enabled | bool | 是否可输入 | 否 | true |
| maxLines | int | 输入框最多行数 | 否 | 4 |
| leading / trailing | Widget? | 左右插槽(语音、表情) | 否 | null |
| onChanged | ValueChanged\<String\>? | 输入内容变化 | 否 | null |
| replyTo | SantoChatQuote? | 当前回复的消息,不为空时展示引用条 | 否 | null |
| onCancelReply | VoidCallback? | 取消回复 | 否 | null |
| extensions | List\<SantoChatExtension\> | 扩展菜单项,传空数组则不展示 `+` 入口 | 否 | 照片、拍摄、文件 |
| onExtensionTap | ValueChanged\<SantoChatExtension\>? | 点选扩展菜单项 | 否 | null |
| emojis | List\<SantoChatEmoji\> | 表情面板里的表情,传空数组则不展示表情入口 | 否 | 内置 32 个 |
| editingText | String? | 正在编辑的消息内容,不为空时展示编辑条并预填内容 | 否 | null |
| onCancelEdit | VoidCallback? | 取消编辑 | 否 | null |

> 发送没有按钮:输入法发送键(回车)提交,`onEditingComplete` 被内部接管,
> 发送后键盘不会收起,连续发送时不会闪。空内容不会触发回调。
>
> 两个面板共用固定高度 `kSantoChatPanelHeight`(230),内容都用 `GridView` 网格布局、
> 左上角起排,单元格尺寸固定、不足一页的空位保留,多出的**左右滑动翻页**:
> 扩展菜单 5 列(`kSantoChatMenuItemColumns`)× 2 排(`kSantoChatMenuItemRows`)、一页 10 项,
> 铺满面板可用高度;表情面板 8 列(`kSantoChatEmojiColumns`)× 4 排(`kSantoChatEmojiRows`)、
> 一页 32 个。多于一页时面板底部显示分页指示点,两块面板同高,切换面板时输入区不会跳动。

### SantoChatSelectionBar

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| selectedCount | int | 已选条数,为 0 时操作项置灰 | 是 | - |
| actions | List\<SantoChatMenuItem\> | 操作项 | 否 | 转发、删除 |
| onCancel | VoidCallback? | 退出多选 | 否 | null |
| onAction | ValueChanged\<SantoChatMenuItem\>? | 点击操作项 | 否 | null |

### SantoChatList

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| conversations | List\<SantoChatConversation\> | 会话列表,顺序由调用方决定 | 是 | - |
| onTap / onLongPress | ValueChanged\<SantoChatConversation\>? | 点击 / 长按会话 | 否 | null |
| empty | Widget? | 空状态 | 否 | 内置空状态 |
| padding | EdgeInsetsGeometry? | 列表内边距 | 否 | null |

> `SantoChatList` 是整屏列表组件,需要父级给出确定高度。

### 内容组件

| 组件 | 主要参数 |
| --- | --- |
| `SantoChatText` | `text` / `mentions` / `style` / `accentColor` / `emojiSize` / `maxLines` / `onMentionTap` / `onLinkTap` |
| `SantoChatQuoteView` | `quote` / `onTap`;我方与对方同一套样式 |
| `SantoChatImage` | `message` / `onTap` |
| `SantoChatVideo` | `message` / `onTap`;`formatDuration(duration)` 静态方法格式化时长 |
| `SantoChatVoice` | `message` / `isMine` / `isPlaying` / `onTap` |
| `SantoChatFile` | `message` / `isMine` / `onTap`;`formatFileSize(bytes)` 静态方法格式化大小 |
| `SantoChatDocCard` | `message` / `onTap`;卡片宽度 `kSantoChatDocWidth`(220),自带白底与描边 |
| `SantoChatSystemNotice` | `text` / `margin` / `padding` |
| `SantoChatTypingIndicator` | `author` / `showAvatar` / `showName` |
| `SantoChatReactionView` | `reactions` / `isMine` / `onTap` |
| `SantoChatMessageMenu` | `show(context:, position:, reactions:, onReaction:, items:, onItemSelected:, onDismiss:)`;<br>块级排列,一排 5 个(见 `kSantoChatMenuItemColumns`) |

## 六、使用示例

```dart
// 一站式会话窗口:整屏使用,输入法弹出时输入区自动上移
Scaffold(
  appBar: SantoAppBar(title: '张三'),
  body: SantoChat(
    messages: messages,
    currentUserId: 'me',
    showName: true,
    typingAuthor: isTyping ? other : null,
    replyTo: replyTo,
    editingText: editing?.text,
    selectionMode: selectionMode,
    selectedIds: selectedIds,
    onSelectionToggle: toggleSelection,
    onSelectionAction: handleSelectionAction,
    onCancelSelection: exitSelection,
    onSend: (String text) {
      if (editing != null) {
        replaceMessage(editing.id, text: text, isEdited: true);
        editing = null;
        return;
      }
      messages.add(SantoChatTextMessage(
        id: 'm${messages.length}',
        author: me,
        text: text,
        mentions: SantoChatMention.parse(text, members),
        status: SantoChatMessageStatus.sending,
        createdAt: DateTime.now(),
      ));
    },
    onReply: (SantoChatMessage message) => replyTo = toQuote(message),
    onReaction: (SantoChatMessage message, String emoji) => toggleReaction(message, emoji),
    onMessageMenuSelected: (SantoChatMessage message, SantoChatMenuItem item) {
      switch (item.key) {
        case 'copy':
          Clipboard.setData(ClipboardData(text: (message as SantoChatTextMessage).text));
          break;
        case 'delete':
          messages.removeWhere((SantoChatMessage m) => m.id == message.id);
          break;
        case 'edit':
          editing = message as SantoChatTextMessage;
          break;
        case 'multiSelect':
          selectionMode = true;
          selectedIds
            ..clear()
            ..add(message.id);
          break;
        default:
          break;
      }
    },
    onExtensionTap: (SantoChatExtension extension) => pickAndSend(extension.key),
  ),
)

// 自定义长按菜单项:在默认项后追加「收藏」
SantoChat(
  // ...
  messageMenuItems: (SantoChatMessage message, bool isMine) => <SantoChatMenuItem>[
    ...SantoChatMenuItem.defaults(message, isMine: isMine),
    const SantoChatMenuItem(key: 'favorite', label: '收藏', icon: SantoIcons.star),
  ],
)

// 只拼装消息列表
SizedBox(
  height: 400,
  child: SantoChatMessageList(
    messages: messages,
    currentUserId: 'me',
    hasMore: true,
    loadingMore: loadingMore,
    onLoadMore: loadHistory,
  ),
)

// 单独使用气泡承载自定义内容
SantoChatBubble(
  author: other,
  showName: true,
  status: SantoChatMessageStatus.read,
  isEdited: true,
  quote: quote,
  reactions: message.reactions,
  child: SantoChatText(message.text, mentions: message.mentions),
)

// 底部输入区(扩展菜单 + 编辑态)
SantoChatInput(
  hintText: '请输入内容',
  editingText: editingText,
  onCancelEdit: cancelEdit,
  extensions: const <SantoChatExtension>[
    SantoChatExtension.photo,
    SantoChatExtension.camera,
    SantoChatExtension.file,
  ],
  onExtensionTap: (SantoChatExtension extension) => pick(extension.key),
  onSend: submit,
)

// 手动弹出长按菜单
SantoChatMessageMenu.show(
  context: context,
  position: details.globalPosition,
  reactions: kSantoChatDefaultReactions,
  onReaction: (String emoji) => toggleReaction(message, emoji),
  items: SantoChatMenuItem.defaults(message, isMine: true),
  onItemSelected: (SantoChatMenuItem item) => handle(item),
);

// 会话列表
SantoChatList(
  conversations: conversations,
  onTap: (SantoChatConversation conversation) => openChat(conversation.id),
  onLongPress: (SantoChatConversation conversation) => showActions(conversation),
)
```

## 七、主题配置

组件外观统一取 `SantoChatConfig`,默认值由 `SantoCommonConfig` 派生:

| 字段 | 说明 | 默认值 |
| --- | --- | --- |
| backgroundColor | 会话背景色,列表会把它铺成画布 | `fillBody` |
| myBubbleColor / otherBubbleColor | 我方 / 对方气泡背景色 | 主题色 10% 透明 / `fillBase` |
| myTextStyle / otherTextStyle | 我方 / 对方气泡文字样式 | 正文色,字号 14 |
| bubbleRadius / bubblePadding / bubbleMaxWidthRatio | 气泡圆角、内边距、最大宽度占比 | `radiusMd` / 10 与 10 / 0.72 |
| myAccentColor / otherAccentColor | 气泡内 @ 与链接的强调色 | `colorLink` |
| nameTextStyle / timeTextStyle / systemTextStyle | 昵称 / 时间 / 系统消息文字样式 | 辅助色,字号 12 与 10 |
| systemBackgroundColor / systemPadding | 系统消息背景与内边距 | 8% 黑 / 10 与 5 |
| avatarSize / emojiSize | 头像与表情图边长 | 36 / 18 |
| quoteBackgroundColor | 引用块背景色,我方与对方一致 | `fillBody` |
| quoteTitleTextStyle / quotePreviewTextStyle | 引用来源与摘要样式 | 正文色 12 加粗 / 辅助色 12 |
| inputBackgroundColor / inputTextStyle / inputHintTextStyle | 输入区背景与文字样式 | `fillBase` / 正文色 14 / 提示色 14 |

## 八、版本变更

### v1.5.0
- **新增**: `SantoChat`、`SantoChatMessageList`、`SantoChatBubble`、`SantoChatInput`、`SantoChatList`、`SantoChatSelectionBar`
- **新增**: 内容组件 `SantoChatText`、`SantoChatQuoteView`、`SantoChatImage`、`SantoChatVideo`、`SantoChatVoice`、`SantoChatFile`、`SantoChatSystemNotice`、`SantoChatTypingIndicator`、`SantoChatReactionView`、`SantoChatMessageMenu`
- **新增**: 消息模型 `SantoChatAuthor`、`SantoChatMention`、`SantoChatQuote`、`SantoChatReaction`、`SantoChatMenuItem`、`SantoChatExtension`、`SantoChatMessage` 及文本/图片/视频/语音/文件/系统消息子类,`SantoChatConversation` 会话模型,`SantoChatEmojiRegistry` 表情注册表
- **新增**: 主题配置 `SantoChatConfig`,并在 `SantoAllThemeConfig` 与 `SantoDefaultConfigUtils` 中注册 `chatConfig`
- **变更**: `SantoChatMessageStatus` 增加 `delivered`、`read`;`SantoChatMessage` 增加 `isEdited`
- **变更**: 输入区去掉发送按钮,改为输入法发送键提交并接管 `onEditingComplete`(发送后键盘不收起);删除 `sendButton` 参数
- **变更**: 长按改为一站式浮层菜单(表情回应 + 操作列表),原独立的 `SantoChatReactionPicker` 由 `SantoChatMessageMenu` 取代
