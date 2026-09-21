import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

/// SantoShare 分享面板示例
class ShareExample extends StatelessWidget {
  const ShareExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(      title: 'Share 分享',
      children: <Widget>[
        ExampleIntro('share'),
        SantoSection(
          title: '单行 7 项',
          description: '预设渠道 + 自定义渠道混合,取消按钮文案可自定义',
          child: _buildTrigger(
            text: '分享（7 项）',
            onTap: () => _showSevenStyle(context),
          ),
        ),
        SantoSection(
          title: '双行 8 项',
          description:
              '第一行为可点击渠道,第二行为不可点击渠道;配置 clickInterceptor 拦截不可点击项',
          child: _buildTrigger(
            text: '分享（双行 8 项）',
            onTap: () => _showFourStyle(context),
          ),
        ),
        SantoSection(
          title: '双行 3 项',
          description: '预设渠道与自定义渠道分两行展示',
          child: _buildTrigger(
            text: '分享（双行 3 项）',
            onTap: () => _showThreeStyle(context),
          ),
        ),
        SantoSection(
          title: '单行 2 项',
          description: '仅两个渠道时面板高度自适应',
          child: _buildTrigger(
            text: '分享（2 项）',
            onTap: () => _showTwoStyle(context),
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _buildTrigger({required String text, required VoidCallback onTap}) {
    return SantoButton(
      text: text,
      alignment: Alignment.center,
      constraints: const BoxConstraints.tightFor(height: 48),
      onTap: onTap,
    );
  }

  void _showSevenStyle(BuildContext context) {
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
      customImage: SantoTools.getAssetImage("share/icon_custom_share.png"),
      customTitle: "自定义",
      canClick: true,
    ));
    SantoShare actionSheet = SantoShare(
      firstShareChannels: firstRowList,
      clickCallBack: (int section, int index, SantoShareItem shareItem) {
        int channel = shareItem.shareType;
        SantoToast.show(
            "channel: $channel, section: $section, index: $index", context);
      },
      cancelTitle: "自定义取消名字",
    );
    actionSheet.show(context);
  }

  void _showFourStyle(BuildContext context) {
    List<SantoShareItem> firstRowList = [];
    List<SantoShareItem> secondRowList = [];
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
    SantoShare actionSheet = SantoShare(
      firstShareChannels: firstRowList,
      secondShareChannels: secondRowList,
      clickCallBack: (int section, int index, SantoShareItem shareItem) {
        int channel = shareItem.shareType;
        SantoToast.show(
            "channel: $channel, section: $section, index: $index", context);
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
  }

  void _showThreeStyle(BuildContext context) {
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
      customImage: SantoTools.getAssetImage("share/icon_custom_share.png"),
      customTitle: "自定义",
      canClick: true,
    ));
    SantoShare actionSheet = SantoShare(
      firstShareChannels: firstRowList,
      secondShareChannels: secondRowList,
      clickCallBack: (int section, int index, SantoShareItem shareItem) {
        int channel = shareItem.shareType;
        SantoToast.show(
            "channel: $channel, section: $section, index: $index", context);
      },
    );
    actionSheet.show(context);
  }

  void _showTwoStyle(BuildContext context) {
    List<SantoShareItem> firstRowList = [];
    firstRowList.add(SantoShareItem(
      SantoShareItemConstants.shareWeiXin,
      canClick: true,
    ));
    firstRowList.add(SantoShareItem(
      SantoShareItemConstants.shareFriend,
      canClick: true,
    ));
    SantoShare actionSheet = SantoShare(
      firstShareChannels: firstRowList,
      clickCallBack: (int section, int index, SantoShareItem shareItem) {
        int channel = shareItem.shareType;
        SantoToast.show(
            "channel: $channel, section: $section, index: $index", context);
      },
    );
    actionSheet.show(context);
  }
}
