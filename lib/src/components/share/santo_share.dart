import 'package:santo_ui/src/components/line/santo_line.dart';
import 'package:santo_ui/src/constants/santo_constants.dart';
import 'package:santo_ui/src/l10n/santo_intl.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/utils/santo_tools.dart';
import 'package:flutter/material.dart';

/// section为所在行数（0或1），index是在第几位（从0开始记）, shareItem为渠道相关信息
typedef SantoShareItemClickCallBack = void Function(
    int section, int index, SantoShareItem shareItem);

/// 点击事件拦截回调（如果配置了此项，返回值为是否拦截，如果为true，则进行拦截，不进行默认回调）
/// section为所在行数（0或1），index是在第几位（从0开始记）,shareItem为渠道相关信息
typedef SantoShareItemClickInterceptor = bool Function(
    int section, int index, SantoShareItem shareItem);

/// 分享元素
class SantoShareItem extends Object {
  /// 分享类型（参考SantoShareItemConstants中的枚举，如果此项不为自定义，则自定义名称和图标不生效）
  int shareType;

  /// 自定义标题
  String? customTitle;

  /// 自定义图标
  Widget? customImage;

  /// 是否可点击（如果为预设类型，设置为不可点击后会变为相应的置灰图标）默认为true
  bool canClick;

  SantoShareItem(
    this.shareType, {
    this.customTitle,
    this.customImage,
    this.canClick = true,
  });
}

/// 分享弹窗
// ignore: must_be_immutable
class SantoShare extends StatelessWidget {
  /// 第一行渠道列表
  final List<SantoShareItem>? firstShareChannels;

  /// 第二行渠道列表
  final List<SantoShareItem>? secondShareChannels;

  /// 列表标题
  final String? mainTitle;

  /// 取消按钮名称
  final String? cancelTitle;

  /// 取消按钮的文本颜色，不传时取主题 colorTextBase
  final Color? textColor;

  /// 分享文本颜色，不传时取主题 colorTextSecondary
  final Color? shareTextColor;

  /// 点击事件回调
  final SantoShareItemClickCallBack? clickCallBack;

  /// 点击事件拦截回调（如果配置了此项，返回值为是否拦截，如果为true，则进行拦截，不进行默认回调）
  final SantoShareItemClickInterceptor? clickInterceptor;

  SantoShare({
    this.firstShareChannels,
    this.secondShareChannels,
    this.mainTitle,
    this.clickCallBack,
    this.clickInterceptor,
    this.cancelTitle,
    this.shareTextColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return Container(
        decoration: ShapeDecoration(
          color: commonConfig.fillBase,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(commonConfig.radiusXs),
              topRight: Radius.circular(commonConfig.radiusXs),
            ),
          ),
        ),
        child: SafeArea(child: _configActionWidgets(context)));
  }

  /// 显示弹窗
  show(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return this;
        }).then((value) {});
  }

  /// 构建单个分享渠道
  Widget? _configChannelWidget(BuildContext context, int section, int index) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    // 分享类型
    SantoShareItem channel;
    // 渠道名称
    String? title;
    // 图片
    Widget? image;
    // 元素宽度(图片边长也是48)
    double itemsWidth = 48;
    // 元素间隔为20写死
    double space = commonConfig.hSpacingLg;
    title = null;
    image = null;
    // 判断区域
    if (section == 0) {
      channel = firstShareChannels![index];
    } else {
      channel = secondShareChannels![index];
    }
    // 判断是否为自定义标题
    title = (channel.shareType == SantoShareItemConstants.shareCustom)
        ? (channel.customTitle ?? "")
        : SantoIntl.of(context).localizedResource.shareChannels[channel.shareType];
    // 判断是否为自定义，如果不是自定义图标，则判断是否可点击（决定是否使用置灰图标）
    image = (channel.shareType == SantoShareItemConstants.shareCustom)
        ? channel.customImage
        : (channel.canClick
            ? SantoTools.getAssetImage(
                SantoShareItemConstants.shareItemImagePathList[channel.shareType])
            : SantoTools.getAssetImage(SantoShareItemConstants
                .disableShareItemImagePathList[channel.shareType]));
    //如果没图或没文字则不显示
    if (image == null) {
      return null;
    }

    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        width: itemsWidth + space,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: image,
              width: itemsWidth,
              height: itemsWidth,
            ),
            Divider(
              height: commonConfig.vSpacingSm,
              color: Colors.transparent,
            ),
            Text(
              title,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: commonConfig.fontSizeCaption,
                  color: shareTextColor ?? commonConfig.colorTextSecondary),
            )
          ],
        ),
      ),
      onTap: () {
        if (clickInterceptor == null ||
            !clickInterceptor!(section, index, channel)) {
          // 推荐使用回调方法处理点击事件!!!!!!!!!!
          if (clickCallBack != null && channel.canClick) {
            clickCallBack!(section, index, channel);
            // 如果未拦截并且可点击，则pop掉当前页面
            Navigator.of(context).pop();
          }
        }
      },
    );
  }

  /// 构建actionSheet的按钮
  Widget _configActionWidgets(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    List<Widget> tiles = [];
    // 预设分享渠道
    List<Widget> firstSectionItems = [];
    // 自定义分享渠道
    List<Widget> secondSectionItems = [];
    // 容器左侧留白
    double leftGap = commonConfig.hSpacingSm;
    // 容器上方留白
    double topGap = commonConfig.vSpacingLg;
    // 容器下方留白
    double bottomGap = commonConfig.vSpacingLg;
    // 构建第一行
    if (firstShareChannels != null) {
      for (int index = 0; index < firstShareChannels!.length; index++) {
        Widget? item = _configChannelWidget(context, 0, index);
        if (item != null) {
          firstSectionItems.add(item);
        }
      }
    }
    // 构建第二行
    if (secondShareChannels != null) {
      for (int index = 0; index < secondShareChannels!.length; index++) {
        Widget? item = _configChannelWidget(context, 1, index);
        if (item != null) {
          secondSectionItems.add(item);
        }
      }
    }
    // 添加title
    tiles.add(Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
          top: commonConfig.vSpacingMd, left: commonConfig.hSpacingLg),
      child: Text(
        mainTitle ?? SantoIntl.of(context).localizedResource.shareTo,
        maxLines: 1,
        textAlign: TextAlign.left,
        style: TextStyle(
            fontSize: commonConfig.fontSizeSubHead,
            fontWeight: FontWeight.w500,
            color: commonConfig.colorTextBase),
      ),
    ));

    // 添加“预设分享”容器
    if (firstSectionItems.isNotEmpty) {
      tiles.add(Container(
        padding: EdgeInsets.only(left: leftGap, top: topGap, bottom: bottomGap),
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: firstSectionItems,
          ),
        ),
      ));
    }

    // 添加分割线
    tiles.add(Container(
      // 分割线左右填充20
      padding:
          EdgeInsets.only(left: commonConfig.hSpacingLg, right: commonConfig.hSpacingLg),
      child: SantoLine(),
    ));

    // 添加“自定义分享”容器
    if (secondSectionItems.isNotEmpty) {
      tiles.add(Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: leftGap, top: topGap, bottom: bottomGap),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: secondSectionItems,
          ),
        ),
      ));
    }

    // 添加分割线
    tiles.add(
      SantoLine(),
    );

    // 添加"取消"按钮
    tiles.add(GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.only(
              left: 61,
              right: 61,
              top: commonConfig.gapMd,
              bottom: commonConfig.gapMd),
          child: Center(
            child: Text(
              cancelTitle ?? SantoIntl.of(context).localizedResource.cancel,
              style: TextStyle(
                  fontSize: commonConfig.fontSizeSubHead,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? commonConfig.colorTextBase),
            ),
          ),
        ),
        onTap: () {
          Navigator.of(context).pop();
        }));

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: tiles,
    );
  }
}
