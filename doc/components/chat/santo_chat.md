---
title: SantoChat
group:
  title: 会话
  order: 1
---

# SantoChat

会话组件承载双方的往来消息与底部输入区,参考 flutter_chat_ui 与 chatview 的能力面设计。
库内提供一站式总装 `SantoChat`,同时把所有原子组件导出,业务可以按需自行拼装。

## 一、效果总览

- **双方消息**:按 `currentUserId` 自动分列左右,我方是浅色底气泡(对齐 DevOpsMobile),对方是白底气泡,
  两侧文字都取正文色
- **@与表情**:`@展示名` 命中 `mentions` 时高亮可点,`[表情名]` 命中注册表时渲染成表情图,
  `http(s)://` 链接自动变色可点
- **系统消息**:居中弱化提示,不带头像与气泡
- **引用消息**:气泡内先渲染引用块,点击回调业务跳回原消息
- **图片/视频消息**:按宽高比取展示尺寸;视频额外展示封面、时长与播放按钮
- **语音/文件消息**:波形 + 时长、文件名 + 大小,播放与下载交给业务
- **消息列表**:时间分隔、同发送者分组、滑动引用回复、长按表情回应、上拉加载更早消息、回到底部
- **底部输入区**:白底铺满底部安全区域,预留 `leading`/`trailing` 插槽给语音与表情面板
- **会话列表**:`SantoChatList` 展示未读角标、置顶标记与免打扰静音角标

## 二、描述

### 适用场景

1. 单聊/群聊的会话窗口(IM、客服、协作评论)
2. 需要展示双方往来记录并允许继续发送内容

### 使用规范

- 消息列表按**时间正序**(旧 → 新)传入,`SantoChatMessageList` 内部按 `reverse` 决定排布,
  默认 `reverse: true` 让最新消息贴在底部
- 需要更细粒度拼装时直接组合 `SantoChatMessageList` + `SantoChatInput`,
  或用 `SantoChatBubble` 承载自定义内容
- 表情图片资源由业务方注册,库内不内置表情图
- 语音与视频的播放、图片预览、文件下载都由业务方在回调里实现,库内不引入播放器依赖
- 输入区底部安全区域**固定预留**、不提供开关;贴底使用时组件自带白底铺满安全区

## 三、组件构成

| 组件 | 说明 |
| --- | --- |
| `SantoChat` | 总装:头部 + 消息列表 + 输入区 |
| `SantoChatMessageList` | 消息列表:时间分隔、分组、滑动回复、表情回应、加载更多、回到底部 |
| `SantoChatBubble` | 单个气泡:左右分栏、头像、昵称、时间、状态、引用、回应 |
| `SantoChatInput` | 底部输入区:插槽、回复条、发送按钮、安全区 |
| `SantoChatList` | 会话列表:会话行、未读角标、置顶、免打扰 |
| `SantoChatText` | 会话富文本:@提及、表情、链接 |
| `SantoChatQuoteView` | 引用块 |
| `SantoChatImage` / `SantoChatVideo` | 图片、视频消息内容 |
| `SantoChatVoice` / `SantoChatFile` | 语音、文件消息内容 |
| `SantoChatSystemNotice` | 系统消息 |
| `SantoChatTypingIndicator` | 对方正在输入 |
| `SantoChatReactionView` / `SantoChatReactionPicker` | 表情回应展示与选择条 |

## 四、数据模型

| 类型 | 说明 |
| --- | --- |
| `SantoChatAuthor` | 会话参与者:`id` / `name` / `avatarUrl` |
| `SantoChatMention` | 被 @ 的成员:`id` / `display`,`parse(text, candidates)` 可从文本解析命中项 |
| `SantoChatQuote` | 引用信息:`messageId` / `title` / `preview` / `thumbnailUrl` |
| `SantoChatReaction` | 表情回应:`emoji` / `count` / `reactedByMe` |
| `SantoChatMessage` | 消息基类:`id` / `author` / `createdAt` / `status` / `quote` / `reactions` |
| `SantoChatTextMessage` | 文本消息,额外带 `text` 与 `mentions` |
| `SantoChatImageMessage` | 图片消息,`url` 与展示尺寸/original 尺寸 |
| `SantoChatVideoMessage` | 视频消息,`url` / `coverUrl` / `duration` |
| `SantoChatVoiceMessage` | 语音消息,`url` / `duration` / 可选 `waveform` |
| `SantoChatFileMessage` | 文件消息,`url` / `name` / `size` |
| `SantoChatSystemMessage` | 系统消息,只有 `text`(`author` 为 null) |
| `SantoChatConversation` | 会话行:`title` / `avatarUrl` / `preview` / `updatedAt` / `unreadCount` / `pinned` / `muted` |

`SantoChatEmojiRegistry` 是全局表情注册表,App 启动时注册一次:

```dart
SantoChatEmojiRegistry.registerAll(<String, String>{
  '微笑': 'assets/emoji/smile.png',
  '赞': 'https://cdn.example.com/emoji/like.png',
});
```

地址以 `http` 开头按网络图加载,否则按包内资源加载;未注册的表情名保留原文。

## 五、构造函数及参数说明

### SantoChat

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| messages | List\<SantoChatMessage\> | 消息列表,按时间正序传入 | 是 | - |
| currentUserId | String | 当前登录用户 id | 是 | - |
| onSend | ValueChanged\<String\>? | 点击发送回调,回调后输入框自动清空 | 否 | null |
| showAvatar | bool | 是否展示头像 | 否 | true |
| showName | bool | 是否展示对方昵称 | 否 | false |
| empty | Widget? | 空状态 | 否 | 内置空状态 |
| header | Widget? | 列表上方的固定区域,如群公告 | 否 | null |
| inputLeading / inputTrailing | Widget? | 输入区左右插槽 | 否 | null |
| sendButton | Widget? | 自定义发送按钮 | 否 | 主按钮「发送」 |
| inputHintText | String | 输入框提示文案 | 否 | 请输入内容 |
| inputEnabled | bool | 输入区是否可输入 | 否 | true |
| replyTo | SantoChatQuote? | 当前回复的消息 | 否 | null |
| onCancelReply | VoidCallback? | 取消回复回调 | 否 | null |
| typingAuthor | SantoChatAuthor? | 正在输入的对方 | 否 | null |
| playingMessageId | String? | 正在播放的语音消息 id | 否 | null |
| reactions | List\<String\> | 长按可选的表情回应 | 否 | 👍 ❤️ 😂 😮 😢 |
| hasMore / loadingMore | bool | 是否还有更早的消息 / 是否正在加载 | 否 | false |
| showScrollToBottom | bool | 是否展示「回到底部」悬浮按钮 | 否 | true |
| listPadding | EdgeInsetsGeometry? | 列表内边距 | 否 | null |
| onLoadMore | VoidCallback? | 滚动到顶部加载更多 | 否 | null |
| onReply | ValueChanged\<SantoChatMessage\>? | 滑动气泡引用回复 | 否 | null |
| onMessageTap | ValueChanged\<SantoChatMessage\>? | 点击消息 | 否 | null |
| onMessageLongPress | ValueChanged\<SantoChatMessage\>? | 长按消息 | 否 | null |
| onMessageDoubleTap | ValueChanged\<SantoChatMessage\>? | 双击消息 | 否 | null |
| onReaction | void Function(SantoChatMessage, String)? | 选择表情回应 | 否 | null |
| onMentionTap | ValueChanged\<SantoChatMention\>? | 点击 @提及 | 否 | null |
| onLinkTap | ValueChanged\<String\>? | 点击链接 | 否 | null |
| onQuoteTap | ValueChanged\<SantoChatQuote\>? | 点击引用块 | 否 | null |
| onRetry | ValueChanged\<SantoChatMessage\>? | 点击发送失败的重试图标 | 否 | null |

### SantoChatMessageList

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| messages | List\<SantoChatMessage\> | 消息列表,按时间正序传入 | 是 | - |
| currentUserId | String | 当前登录用户 id | 是 | - |
| showAvatar / showName | bool | 是否展示头像 / 对方昵称 | 否 | true / false |
| reverse | bool | 是否倒序(最新消息在底部) | 否 | true |
| timeGroupWindow | Duration | 超过该间隔插入时间分隔 | 否 | 5 分钟 |
| empty / typingAuthor | Widget? / SantoChatAuthor? | 空状态 / 正在输入的对方 | 否 | null |
| playingMessageId | String? | 正在播放的语音消息 id | 否 | null |
| controller | ScrollController? | 外部滚动控制器 | 否 | null |
| padding | EdgeInsetsGeometry? | 列表内边距 | 否 | null |
| reactions | List\<String\> | 长按可选的表情回应,传空数组可关掉内置回应条 | 否 | 默认 5 个 |
| hasMore / loadingMore | bool | 是否还有更早的消息 / 是否正在加载 | 否 | false |
| showScrollToBottom | bool | 是否展示「回到底部」按钮 | 否 | true |
| onLoadMore / onReply / onMessageTap / onMessageLongPress / onMessageDoubleTap / onReaction / onMentionTap / onLinkTap / onQuoteTap / onRetry | 回调 | 同 `SantoChat` | 否 | null |

列表能力说明:

- **会话底色**:消息列表自带 `SantoChatConfig.backgroundColor`(默认 `fillBody` 灰)作画布,
  否则对面的白气泡在白底页面上看不见;需要透明时把主题里的 `chatConfig.backgroundColor`
  配成透明即可
- 时间分隔:相邻消息间隔超过 `timeGroupWindow` 或跨天时插入,文案为
  「今天/昨天/月-日/年-月-日」+ 时分(由 `formatChatTime` 生成)
- 分组:同一发送者的连续消息只在该组第一条展示头像与昵称
- 长按:同时触发 `onMessageLongPress` 与内置回应条;想用自定义长按菜单把 `reactions` 传空数组
- 双击:同时触发 `onMessageDoubleTap` 与第一个表情的快捷回应
- `SantoChatSystemMessage` 自动渲染成居中提示,不参与分组与头像逻辑

### SantoChatBubble

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| child | Widget | 气泡内容 | 是 | - |
| author | SantoChatAuthor? | 发送者,用于头像与昵称 | 否 | null |
| isMine | bool | 是否我方消息,决定左右与配色 | 否 | false |
| showAvatar / showName / showTime | bool | 是否展示头像 / 昵称 / 时间 | 否 | true / false / false |
| time | DateTime? | 展示的时间 | 否 | null |
| quote | SantoChatQuote? | 引用信息 | 否 | null |
| status | SantoChatMessageStatus | 发送状态,失败与发送中会展示状态图标 | 否 | sent |
| reactions | List\<SantoChatReaction\> | 表情回应,展示在气泡下方 | 否 | 空 |
| contentPadding | EdgeInsetsGeometry? | 内容区内边距,图片/视频传 `EdgeInsets.zero` 铺满气泡 | 否 | 主题气泡内边距 |
| backgroundColor / textColor / avatar | - | 背景色、文字色、自定义头像 | 否 | 按主题 |
| onTap / onLongPress / onDoubleTap / onRetry / onQuoteTap / onReactionTap | 回调 | 交互回调 | 否 | null |

### SantoChatInput

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| controller / focusNode | - | 文本与焦点控制器 | 否 | 内部创建 |
| onSend | ValueChanged\<String\>? | 点击发送回调,回调后清空输入框 | 否 | null |
| hintText | String | 提示文案 | 否 | 请输入内容 |
| enabled | bool | 是否可输入 | 否 | true |
| maxLines | int | 输入框最多行数 | 否 | 4 |
| leading / trailing / sendButton | Widget? | 左右插槽与自定义发送按钮 | 否 | null / 主按钮「发送」 |
| onChanged | ValueChanged\<String\>? | 输入内容变化 | 否 | null |
| replyTo | SantoChatQuote? | 当前回复的消息,不为空时展示回复条 | 否 | null |
| onCancelReply | VoidCallback? | 取消回复回调 | 否 | null |

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
| `SantoChatSystemNotice` | `text` / `margin` / `padding` |
| `SantoChatTypingIndicator` | `author` / `showAvatar` / `showName` |
| `SantoChatReactionView` | `reactions` / `isMine` / `onTap` |
| `SantoChatReactionPicker` | `show(context:, position:, onSelected:, emojis:, onDismiss:)` |

## 六、使用示例

```dart
// 一站式会话窗口
SantoChat(
  messages: messages,
  currentUserId: 'me',
  showName: true,
  typingAuthor: isTyping ? other : null,
  replyTo: replyTo,
  onSend: (String text) {
    setState(() {
      messages.add(SantoChatTextMessage(
        id: 'm${messages.length}',
        author: me,
        text: text,
        mentions: SantoChatMention.parse(text, members),
        createdAt: DateTime.now(),
      ));
      replyTo = null;
    });
  },
  onReply: (SantoChatMessage message) {
    setState(() {
      replyTo = SantoChatQuote(
        messageId: message.id,
        title: message.author!.name,
        preview: (message as SantoChatTextMessage).text,
      );
    });
  },
  onReaction: (SantoChatMessage message, String emoji) => toggleReaction(message, emoji),
  onMessageTap: (SantoChatMessage message) => openDetail(message),
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
  quote: quote,
  reactions: message.reactions,
  child: SantoChatText(message.text, mentions: message.mentions),
)

// 底部输入区(带回复态与插槽)
SantoChatInput(
  hintText: '请输入内容',
  replyTo: replyTo,
  onCancelReply: () => setState(() => replyTo = null),
  leading: SantoIcon(SantoIcons.microphone),
  trailing: SantoIcon(SantoIcons.emoji),
  onSend: send,
)

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
| backgroundColor | 会话背景色 | `fillBody` |
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
- **新增**: `SantoChat`、`SantoChatMessageList`、`SantoChatBubble`、`SantoChatInput`、`SantoChatList`
- **新增**: 内容组件 `SantoChatText`、`SantoChatQuoteView`、`SantoChatImage`、`SantoChatVideo`、`SantoChatVoice`、`SantoChatFile`、`SantoChatSystemNotice`、`SantoChatTypingIndicator`、`SantoChatReactionView`、`SantoChatReactionPicker`
- **新增**: 消息模型 `SantoChatAuthor`、`SantoChatMention`、`SantoChatQuote`、`SantoChatReaction`、`SantoChatMessage` 及文本/图片/视频/语音/文件/系统消息子类,`SantoChatConversation` 会话模型,`SantoChatEmojiRegistry` 表情注册表
- **新增**: 主题配置 `SantoChatConfig`,并在 `SantoAllThemeConfig` 与 `SantoDefaultConfigUtils` 中注册 `chatConfig`
