---
title: SantoShareActionSheet
group:
  title: ActionSheet
  order: 2
---

# SantoShareActionSheet

分享专用ActionSheet

## 一、效果总览

<img src="./img/actionSheet_share_1.png" style="zoom:67%;" />
<br/>
<img src="./img/actionSheet_share_2.png" style="zoom:67%;" />
<br/>
<img src="./img/actionSheet_share_3.png" style="zoom:67%;" />
<br/>
<img src="./img/actionSheet_share_4.png" style="zoom:67%;" />



## 二、描述

### 适用场景

1. 吸底列表弹框

2. 可指定任意数量的需要展示的分享渠道图标（目前内设有：微信，朋友圈，qq，qq空间，微博，链接，短信）

3. 如需展示内设渠道之外的分享渠道，支持自定义展示渠道图标

4. 可自定义取消按钮名称



## 三、构造函数及参数说明

### 构造函数

```dart
SantoShareActionSheet({
    this.firstShareChannels,
    this.secondShareChannels,
    this.mainTitle,
    this.clickCallBack,
    this.clickInterceptor,
    this.cancelTitle,
    this.shareTextColor = const Color(0xff999999),
    this.textColor = const Color(0xff222222),
  });
```



### 参数说明

#### SantoShareItem 

| 参数名 | 参数类型 | 描述 |
| --- | --- | --- |
| shareType | int | 分享类型（参考SantoShareItemConstants中的枚举，如果此项不为自定义，则自定义名称和图标不生效） |
| customTitle | String? | 自定义标题 |
| customImage | Widget? | 自定义图标 |
| canClick | bool | 是否可点击（如果为预设类型，设置为不可点击后会变为相应的置灰图标）默认为true |

#### SantoShareActionSheet

| **参数名** | **参数类型** | **描述** | **是否必填** | **默认值** |
| --- | --- | --- | --- | --- |
| firstShareChannels | `List<SantoShareItem>?` | 第一行渠道列表 | 否 | 空 |
| secondShareChannels | `List<SantoShareItem>?` | 第二行渠道列表 | 否 |  |
| mainTitle | String? | 列表标题 | 否 |  |
| clickCallBack | SantoShareActionSheetItemClickCallBack? | 点击分享渠道图标后回调方法 | 否 | 空 |
| cancelTitle | String? | 取消按钮的文案 | 否 | ''取消'' |
| context | BuildContext | BuidContext | 是 | 空 |
| shareTextColor | Color | 分享渠道文案颜色 | 否 | Color(0xff999999)灰色 |
| textColor | Color | 选项标题颜色 | 否 | Color(0xff222222)黑色 |
| clickInterceptor | SantoShareActionSheetOnItemClickInterceptor? | 是否可点击（如果为预设类型，设置为不可点击后会变为相应的置灰图标）默认为true | 否 |  |

### 其他数据

| 常量名                               | 渠道名                                                       |
| ------------------------------------ | ------------------------------------------------------------ |
| SantoShareItemConstants.shareWeiXin    | 微信                                                         |
| SantoShareItemConstants.shareFriend    | 朋友圈                                                       |
| SantoShareItemConstants.shareQQ        | qq                                                           |
| SantoShareItemConstants.shareQZone     | qq空间                                                       |
| SantoShareItemConstants.shareWeiBo     | 微博                                                         |
| SantoShareItemConstants.shareLink      | 链接                                                         |
| SantoShareItemConstants.shareSms       | 短信                                                         |
| SantoShareItemConstants.shareCopyLink  | 剪贴板                                                       |
| SantoShareItemConstants.shareBrowser   | 浏览器                                                       |
| SantoShareItemConstants.shareSaveImage | 相册                                                         |
| SantoShareItemConstants.shareCustom    | 自定义自定义图标需在`getCustomChannelTitle`方法中设置文案，在`getCustomChannelWidget`方法中设定图标。如其中一个为空，则不显示自定义图标。 |



## 效果及代码展示

### 效果1： 六个分享渠道+两个自定义

<img src="./img/actionSheet_share_1.png" style="zoom:67%;" />



```dart
List<SantoShareItem> firstRowList = [];
firstRowList.add(SantoShareItem(
  SantoShareItemConstants.shareWeiXin,
  canClick: true,
));
firstRowList.add(SantoShareItem(
  SantoShareItemConstants.shareBrowser,
  canClick: true,
));
firstRowList.add(SantoShareItem(
  SantoShareItemConstants.shareCopyLink,
  canClick: true,
));
firstRowList.add(SantoShareItem(
  SantoShareItemConstants.shareFriend,
  canClick: true,
));
firstRowList.add(SantoShareItem(
  SantoShareItemConstants.shareLink,
  canClick: true,
));
firstRowList.add(SantoShareItem(
  SantoShareItemConstants.shareQQ,
  canClick: true,
));
firstRowList.add(SantoShareItem(
  SantoShareItemConstants.shareCustom,
  customImage: SantoTools.getAssetImage("images/icon_custom_share.png"),
  customTitle: "自定义",
  canClick: true,
));
SantoShareActionSheet actionSheet = new SantoShareActionSheet(
  firstShareChannels: firstRowList,
  clickCallBack: (int section, int index, SantoShareItem shareItem) {
    int channel = shareItem.shareType;
    SantoToast.show("channel: $channel, section: $section, index: $index", context);
  },
  cancelTitle: "自定义取消名字", // 取消按钮title可自定义
);
actionSheet.show(context);
```
### 效果2：四个分享渠道+四个自定义

<img src="./img/actionSheet_share_2.png" style="zoom:67%;" />

```dart
List<SantoShareItem> firstRowList = List();
List<SantoShareItem> secondRowList = List();
firstRowList.add(SantoShareItem(
  SantoShareItemConstants.shareQZone,
  canClick: true,
));
firstRowList.add(SantoShareItem(
  SantoShareItemConstants.shareSaveImage,
  canClick: true,
));
firstRowList.add(SantoShareItem(
  SantoShareItemConstants.shareSms,
  canClick: true,
));
firstRowList.add(SantoShareItem(
  SantoShareItemConstants.shareWeiBo,
  canClick: true,
));
secondRowList.add(SantoShareItem(
  SantoShareItemConstants.shareQZone,
  canClick: false,
));
secondRowList.add(SantoShareItem(
  SantoShareItemConstants.shareSaveImage,
  canClick: false,
));
secondRowList.add(SantoShareItem(
  SantoShareItemConstants.shareSms,
  canClick: false,
));
secondRowList.add(SantoShareItem(
  SantoShareItemConstants.shareWeiBo,
  canClick: false,
));
SantoShareActionSheet actionSheet = new SantoShareActionSheet(
  firstShareChannels: firstRowList,
  secondShareChannels: secondRowList,
  clickCallBack: (int section, int index, SantoShareItem shareItem) {
    int channel = shareItem.shareType;
    SantoToast.show("channel: $channel, section: $section, index: $index", context);
  },
  clickInterceptor: (int section, int index, SantoShareItem shareItem) {
    if (shareItem.canClick) {
      return false;
    } else {
      SantoToast.show("不可点击，拦截了", context);
      return true;
    }
  },
);
actionSheet.show(context);
```

### 效果3：上两个渠道+下一个自定义

<img src="./img/actionSheet_share_3.png" style="zoom:67%;" />

```dart
List<SantoShareItem> firstRowList = [];
List<SantoShareItem> secondRowList = [];
firstRowList.add(SantoShareItem(
  SantoShareItemConstants.shareWeiXin,
  canClick: true,
));
firstRowList.add(SantoShareItem(
  SantoShareItemConstants.shareFriend,
  canClick: true,
));
secondRowList.add(SantoShareItem(
  SantoShareItemConstants.shareCustom,
  customImage: SantoTools.getAssetImage("images/icon_custom_share.png"),
  customTitle: "自定义",
  canClick: true,
));
SantoShareActionSheet actionSheet = new SantoShareActionSheet(
  firstShareChannels: firstRowList,
  secondShareChannels: secondRowList,
  clickCallBack: (int section, int index, SantoShareItem shareItem) {
    int channel = shareItem.shareType;
    SantoToast.show("channel: $channel, section: $section, index: $index", context);
  },
);
actionSheet.show(context);
```



### 效果4：两个渠道

<img src="./img/actionSheet_share_4.png" style="zoom:67%;" />

```dart
List<SantoShareItem> firstRowList = [];
firstRowList.add(SantoShareItem(
  SantoShareItemConstants.shareWeiXin,
  canClick: true,
));
firstRowList.add(SantoShareItem(
  SantoShareItemConstants.shareFriend,
  canClick: true,
));
SantoShareActionSheet actionSheet = new SantoShareActionSheet(
  firstShareChannels: firstRowList,
  clickCallBack: (int section, int index, SantoShareItem shareItem) {
    int channel = shareItem.shareType;
    SantoToast.show("channel: $channel, section: $section, index: $index", context);
  },
);
actionSheet.show(context);
```

