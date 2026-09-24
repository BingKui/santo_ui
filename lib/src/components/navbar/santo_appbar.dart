import 'package:bindings_compatible/bindings_compatible.dart';
import 'package:santo_ui/src/components/icon/santo_icon.dart';
import 'package:santo_ui/src/components/icon/santo_icons.dart';
import 'package:santo_ui/src/components/line/santo_line.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/theme/configs/santo_appbar_config.dart';
import 'package:santo_ui/src/theme/base/santo_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// AppBar 内图标操作区(InkWell)的圆角半径,leading 与 action 共用
const double _kAppBarIconRadius = 12;

/// AppBar组件,基于[AppBar]封装。为了解决原生的AppBar对Leading宽度的限制
/// 在1.21版本之后，Flutter放开了宽度的限制[https://github.com/flutter/flutter/blob/flutter-1.21-candidate.0/packages/flutter/lib/src/material/app_bar.dart]
///
/// 布局规则：
///    leading是左侧显示的内容
///    title是中间显示的内容
///    action是右侧显示的内容
///    呈现的依然是AppBar，优化点在于：第一 title可以传入String
///                               第二 action和leading 封装了快捷使用
///
/// 用户如果想自定义 使用效果完全可以传入appbar的属性
///
/// 布局步骤：同appbar默认的布局 先leading、后action，最后title
///
///    首先，计算leading的宽度 外部传入则可以leadingWidth 则已外部传入为主
///
///         该组件为[SantoDoubleLeading]和[SantoBackLeading]提供了计算
///         leading默认的大小是[SantoAppBarConfig.leadingSize],
///         [SantoDoubleLeading]的大小是 但是Leading的宽度的2倍+间距
///
///         leadingWidth默认宽度为SantoAppBarConfig.leadingSize
///         如果传入的leading是完全自定义的Widget，可以自行设置leadingWidth
///
///    其次，摆放action
///
///    最后，对齐title
///
/// 组件支持两种显示模式深色和浅色。 通过[SantoAppBar.brightness]属性设置，
/// 深色[Brightness.dark]模式，背景色是黑色，icon和文字颜色是白色。
/// 浅色[Brightness.light]模式，背景色是白色，icon和文字颜色是黑色。
/// 如果使用默认的[SantoBackLeading]和[SantoAppBarTitle]
/// BkAppBar中的文字颜色和backLeading可自动随着[SantoAppBar.brightness]变化。
///
/// 组件提供了默认的返回leading，如果不需要默认的leading可以设置[automaticallyImplyLeading]为false
/// 默认的leading，提供了默认的返回[Navigator.pop(context)]，
/// 如果是native打开的话，可能需要单独处理,否则会出现白屏
///
/// 其他属性同AppBar本身的含义
///
/// 显示：返回按钮、Appbar示例文本
/// SantoAppBar(
///   title: 'Appbar示例',
/// )
///
/// 显示：自定义leading、tab切换、自定义action
/// SantoAppBar(
///   leading: SantoBackLeading(),
///   title: Row(
///   mainAxisSize: MainAxisSize.min,
///      crossAxisAlignment: CrossAxisAlignment.start,
///      children: <Widget>[
///      GestureDetector(
///         onTap: () {
///           currentIndex = 0;
///           setState(() {});
///          },
///         child: Text(
///           '二手',
///            style: currentIndex == 0 ? selectedHeiStyle : unSelectedHeiStyle,
///           ),
///      ),
///      SizedBox(
///         width: 24,
///      ),
///      GestureDetector(
///         onTap: () {
///           currentIndex = 1;
///           setState(() {});
///         },
///         child: Text(
///           '新房',
///            style: currentIndex == 1 ? selectedHeiStyle : unSelectedHeiStyle,
///         ),
///       )
///      ],
///    ),
///  actions: SantoIconAction(
///    icon: SantoIcons.shareIos,
///    iconPressed: () {},
///  ),
///
/// 相关组件如下:
///  * [SantoBackLeading], 自定义leading，单个文本或按钮
///  * [SantoDoubleLeading], 自定义leading，两个文本或按钮
///  * [SantoAppBarTitle], 自定义title，纯文本展示
///  * [SantoIconAction], 自定义action，显示icon
///  * [SantoTextAction], 自定义action，纯文本展示
///  * [SantoBarBottomDivider], appbar与其他元素的分割线，同[SantoLine]
///
///
class SantoAppBar extends PreferredSize {
  /// 导航栏左侧活动区域,在为null且
  /// [automaticallyImplyLeading]为true时默认赋值为[SantoBackLeading]
  final Widget? leading;

  /// AppBar标题,必须是String或者Widget类型
  /// 为String时,会使用[SantoAppBarTitle]来加载title
  final dynamic title;

  /// 为了方便业务使用，可以设置为Widget或者List<Widget>
  /// 传入的Widget会自动添加边距并转化为List<Widget>
  /// 传入的List<Widget>会自动添加右边距和action之间的间距
  final dynamic actions;

  /// 是否自动添加Leading实现
  final bool automaticallyImplyLeading;

  /// 以下属性都对应于[AppBar]中的属性
  /// 详细介绍可以查阅[AppBar]的文档
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;
  final double elevation;
  final double toolbarOpacity;
  final double bottomOpacity;
  final Alignment titleAlignment;
  final Widget? flexibleSpace;
  final double? leadingWidth;
  final Color? shadowColor;
  final ShapeBorder? shape;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final bool primary;
  final bool excludeHeaderSemantics;
  final double? titleSpacing;

  /// 默认处理了返回按钮，flutter的pop，如果是native打开的话，可能需要单独处理,否则会出现白屏
  /// backLeadCallback是默认的处理回调
  /// DefaultLeadingCallBack 也可以通过改方法参数 设置统一的返回处理，该参数是静态的
  final VoidCallback? backLeadCallback;

  /// 是否显示默认的eeeeee分割线，默认显示，可以设置为不显示
  final bool? showDefaultBottom;
  final bool showLeadingDivider;
  final SantoAppBarConfig? themeData;
  final SystemUiOverlayStyle? systemOverlayStyle;

  SantoAppBar(
      {Key? key,
      this.leading,
      this.showLeadingDivider = false,
      this.title,
      this.actions,
      this.backgroundColor,
      this.bottom,
      this.elevation = 0,
      this.automaticallyImplyLeading = true,
      this.toolbarOpacity = 1.0,
      this.bottomOpacity = 1.0,
      this.titleAlignment = Alignment.center,
      this.flexibleSpace,
      this.backLeadCallback,
      this.showDefaultBottom,
      this.themeData,
      this.leadingWidth,
      this.shadowColor,
      this.shape,
      this.iconTheme,
      this.actionsIconTheme,
      this.excludeHeaderSemantics = false,
      this.primary = true,
      this.systemOverlayStyle,
      this.titleSpacing})
      : assert(
            actions == null || actions is Widget || (actions is List<Widget>)),
        assert(title == null || title is String || title is Widget),
        super(key: key, child: Container(), preferredSize: Size(0, 0));

  SantoAppBar.buildSearchResultStyle(
      {Key? key,
      String? title,
      this.backgroundColor,
      this.bottom,
      this.showLeadingDivider = true,
      this.flexibleSpace,
      this.backLeadCallback,
      this.showDefaultBottom = true,
      this.themeData,
      this.leadingWidth,
      this.shadowColor,
      this.shape,
      this.iconTheme,
      this.actionsIconTheme,
      this.excludeHeaderSemantics = false,
      this.primary = true,
      this.systemOverlayStyle,
      this.titleSpacing})
      : this.actions = null,
        this.elevation = 0,
        this.toolbarOpacity = 1.0,
        this.bottomOpacity = 1.0,
        this.leading = null,
        this.automaticallyImplyLeading = false,
        this.titleAlignment = Alignment.centerLeft,
        this.title = _SantoSearchResultAppBar(
          appBarConfig: themeData,
          backgroundColor: backgroundColor,
          title: title,
          bottom: bottom,
          showLeadingDivider: showLeadingDivider,
          flexibleSpace: flexibleSpace,
          backLeadCallback: backLeadCallback,
          showDefaultBottom: showDefaultBottom,
        ),
        super(key: key, child: Container(), preferredSize: const Size(0, 0));

  @override
  Size get preferredSize {
    SantoAppBarConfig _defaultConfig = themeData ?? SantoAppBarConfig();
    _defaultConfig = SantoThemeConfigurator.instance
        .getConfig(configId: _defaultConfig.configId)
        .appBarConfig
        .merge(_defaultConfig);
    return Size.fromHeight(
        _defaultConfig.appBarHeight + (bottom?.preferredSize.height ?? 0.0));
  }

  @override
  Widget build(BuildContext context) {
    SantoAppBarConfig _defaultConfig = themeData ?? SantoAppBarConfig();
    _defaultConfig = SantoThemeConfigurator.instance
        .getConfig(configId: _defaultConfig.configId)
        .appBarConfig
        .merge(_defaultConfig);

    _defaultConfig = _defaultConfig.merge(SantoAppBarConfig(
        backgroundColor: this.backgroundColor,
        showDefaultBottom: this.showDefaultBottom,
        systemOverlayStyle: this.systemOverlayStyle));

    // 模式:背景亮度 < 0.5 视为深色(深色模式或自定义背景色),
    // 内容(标题/操作文字)默认白色,可自行设置其他颜色;
    // 浅色背景内容默认黑色,不允许设置为白色(自动回退为黑色)
    final Color effectiveBackground = _defaultConfig.backgroundColor;
    final bool darkBackground = effectiveBackground.computeLuminance() < 0.5;
    _defaultConfig = _defaultConfig.copyWith(
      titleStyle:
          _resolveContentStyle(_defaultConfig.titleStyle, darkBackground),
      actionsStyle:
          _resolveContentStyle(_defaultConfig.actionsStyle, darkBackground),
      systemOverlayStyle: this.systemOverlayStyle ??
          (darkBackground
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark),
    );

    // 默认返回箭头颜色跟随模式;调用方自定义 builder 时不干预
    final SantoAppBarConfig globalConfig = SantoThemeConfigurator.instance
        .getConfig(configId: _defaultConfig.configId)
        .appBarConfig;
    if (identical(_defaultConfig.leadIconBuilder,
        globalConfig.leadIconBuilder)) {
      _defaultConfig = _defaultConfig.copyWith(
        leadIconBuilder: darkBackground
            ? SantoAppBarConfig.dark().leadIconBuilder
            : SantoAppBarConfig.light().leadIconBuilder,
      );
    }

    useWidgetsBinding().addPostFrameCallback((item) {
      SystemChrome.setSystemUIOverlayStyle(_defaultConfig.systemOverlayStyle);
    });

    Widget? flexibleSpace;
    if (this.flexibleSpace != null) {
      flexibleSpace = Container(
        height: _defaultConfig.appBarHeight +
            MediaQueryData.fromView(View.of(context)).padding.top,
        child: this.flexibleSpace,
      );
    }

    return AppBar(
      key: key,
      leading: _wrapLeading(_defaultConfig),
      leadingWidth: leadingWidth ?? _culLeadingSize(_defaultConfig),
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      title: _buildAppBarTitle(_defaultConfig),
      centerTitle: true,
      elevation: elevation,
      backgroundColor: _defaultConfig.backgroundColor,
      surfaceTintColor: Colors.transparent,
      actions: _wrapActions(_defaultConfig),
      bottom: _buildBarBottom(_defaultConfig),
      systemOverlayStyle: _defaultConfig.systemOverlayStyle,
      toolbarOpacity: toolbarOpacity,
      bottomOpacity: bottomOpacity,
      flexibleSpace: flexibleSpace,
      shadowColor: shadowColor,
      shape: shape,
      iconTheme: iconTheme ??
          IconThemeData(
            color: darkBackground
                ? _defaultConfig.commonConfig.colorTextBaseInverse
                : _defaultConfig.commonConfig.colorTextBase,
          ),
      actionsIconTheme: actionsIconTheme ??
          IconThemeData(
            color: darkBackground
                ? _defaultConfig.commonConfig.colorTextBaseInverse
                : _defaultConfig.commonConfig.colorTextBase,
          ),
      primary: primary,
      excludeHeaderSemantics: excludeHeaderSemantics,
    );
  }

  /// 根据背景亮度解析内容文字样式
  ///
  /// * 深色背景(深色模式/自定义背景色):未自定义颜色时默认白色,自定义其他颜色保留
  /// * 浅色背景:内容默认黑色,不允许设置为白色(自动回退为黑色)
  SantoTextStyle _resolveContentStyle(
      SantoTextStyle style, bool darkBackground) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final Color? color = style.color;
    if (darkBackground) {
      if (color == null || color == commonConfig.colorTextBase) {
        return style.merge(
            SantoTextStyle(color: commonConfig.colorTextBaseInverse));
      }
      return style;
    }
    if (color == null || color.computeLuminance() > 0.9) {
      return style.merge(SantoTextStyle(color: commonConfig.colorTextBase));
    }
    return style;
  }

  PreferredSizeWidget? _buildBarBottom(SantoAppBarConfig defaultConfig) {
    if (defaultConfig.systemOverlayStyle.statusBarBrightness ==
            Brightness.light) {
      if (bottom == null && defaultConfig.showDefaultBottom) {
        return SantoBarBottomDivider();
      }
    }
    return bottom;
  }

  // 根据输入的leading 设置默认的leadingWidth
  double _culLeadingSize(SantoAppBarConfig themeData) {
    if (leadingWidth != null) {
      return leadingWidth!;
    }
    if (leading is SantoDoubleLeading) {
      // 左边距 15 + 32 + 间距 5 + 32,与 SantoDoubleLeading 的宽度保持一致
      return themeData.leadingSize * 2 +
          themeData.leadingSpacing +
          themeData.leftAndRightPadding;
    }

    if (leading == null && !automaticallyImplyLeading) {
      return 0;
    }
    return themeData.leftAndRightPadding + themeData.leadingSize;
  }

  // 对[actions]进行包装: 单一的Widget会添加右边距
  //                     List<Widget>在添加右边距的 并 添加action中的间距
  List<Widget>? _wrapActions(SantoAppBarConfig themeData) {
    if (actions == null || !(actions is List<Widget> || actions is Widget)) {
      return null;
    }
    List<Widget> actionList = <Widget>[];

    if (actions is List<Widget>) {
      if (actions.isEmpty) {
        return actionList;
      }
      List<Widget> tmp = (actions as List<Widget>).map((item) {
        return (item is SantoTextAction)
            ? _warpRealAction(item, themeData)
            : item;
      }).toList();

      for (int i = 0, n = tmp.length; i < n; i++) {
        actionList.add(tmp[i]);
        if (i != n - 1) actionList.add(SizedBox(width: themeData.itemSpacing));
      }
    } else {
      Widget realAction = (actions is SantoTextAction)
          ? _warpRealAction(actions, themeData)
          : actions;
      actionList.add(realAction);
    }
    return actionList..add(SizedBox(width: themeData.leftAndRightPadding));
  }

  // 透传 AppBar 解析后的配置(含深色背景自动切换的配色),
  // 之前原样传的是 widget.themeData(通常为 null),AppBar 级配置对文字操作不生效
  SantoTextAction _warpRealAction(
      SantoTextAction textAction, SantoAppBarConfig? barThemeData) {
    return SantoTextAction(
      textAction.text,
      iconPressed: textAction.iconPressed,
      themeData: barThemeData,
      key: textAction.key,
    );
  }

  // 详情请参考_ToolbarLayout的布局方法
  Widget? _buildAppBarTitle(
    SantoAppBarConfig themeData,
  ) {
    Widget? realTitle;
    if (title is Widget) {
      return title;
    }
    if (title is String) {
      realTitle = SantoAppBarTitle(
        title,
        themeData: themeData,
      );
    }

    return realTitle;
  }

  Widget? _wrapLeading(SantoAppBarConfig barConfig) {
    Widget? realLeading = leading;
    if (leading == null && automaticallyImplyLeading) {
      realLeading = SantoBackLeading(
        iconPressed: backLeadCallback,
        themeData: barConfig,
      );
    }
    return realLeading;
  }
}

/// [SantoAppBar]中leading的默认实现
/// 图标操作区域固定 [SantoAppBarConfig.leadingSize](32)
class SantoBackLeading extends StatelessWidget {
  final Widget? child;
  final VoidCallback? iconPressed;
  final SantoAppBarConfig? themeData;

  SantoBackLeading({
    Key? key,
    this.iconPressed,
    this.child,
    this.themeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SantoAppBarConfig _defaultThemeData = themeData ?? SantoAppBarConfig();
    _defaultThemeData = SantoThemeConfigurator.instance
        .getConfig(configId: _defaultThemeData.configId)
        .appBarConfig
        .merge(_defaultThemeData);

    _defaultThemeData = SantoThemeConfigurator.instance
        .getConfig(configId: _defaultThemeData.configId)
        .appBarConfig
        .merge(_defaultThemeData);

    return Container(
      // 返回键操作区域固定 32,不随主题 iconSize/padding 变化,
      // 避免在 AppBar leading 槽位中溢出
      width: _defaultThemeData.leadingSize,
      height: _defaultThemeData.appBarHeight,
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(_kAppBarIconRadius),
          onTap: iconPressed ??
              () {
                /// 默认处理了返回按钮，flutter的pop，如果是native打开的话，可能需要单独处理,否则会出现白屏
                /// backLeadCallback是默认的处理回调
                /// DefaultLeadingCallBack 也可以通过改方法参数 设置统一的返回处理，该参数是静态的
                Navigator.maybePop(context);
              },
          child: SizedBox(
            width: _defaultThemeData.leadingSize,
            height: _defaultThemeData.leadingSize,
            child: Center(
              child: child ?? _defaultThemeData.leadIconBuilder(),
            ),
          ),
        ),
      ),
    );
  }
}

/// 支持在[SantoAppBar.leading]添加两个元素的Leading实现
///
/// 每个操作区固定 [SantoAppBarConfig.leadingSize](32x32),间距
/// [SantoAppBarConfig.leadingSpacing](5),左侧距屏幕边缘 leftAndRightPadding(15)
class SantoDoubleLeading extends StatelessWidget {
  final Widget first;
  final Widget second;
  final SantoAppBarConfig? themeData;

  SantoDoubleLeading(
      {Key? key, required this.first, required this.second, this.themeData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SantoAppBarConfig _defaultThemeData = themeData ?? SantoAppBarConfig();
    _defaultThemeData = SantoThemeConfigurator.instance
        .getConfig(configId: _defaultThemeData.configId)
        .appBarConfig
        .merge(_defaultThemeData);

    return Container(
      constraints: BoxConstraints.tightFor(
          height: _defaultThemeData.appBarHeight,
          width: _defaultThemeData.leadingSize * 2 +
              _defaultThemeData.leadingSpacing +
              _defaultThemeData.leftAndRightPadding),
      padding: EdgeInsets.only(left: _defaultThemeData.leftAndRightPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          first,
          SizedBox(width: _defaultThemeData.leadingSpacing),
          second,
        ],
      ),
    );
  }
}

/// [SantoAppBar.title]的默认实现
/// 标题文字个数限制在8个以内，并且单行展示
class SantoAppBarTitle extends StatelessWidget {
  final String title;
  final SantoAppBarConfig? themeData;

  SantoAppBarTitle(this.title, {Key? key, this.themeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SantoAppBarConfig _defaultThemeData = themeData ?? SantoAppBarConfig();
    _defaultThemeData = SantoThemeConfigurator.instance
        .getConfig(configId: _defaultThemeData.configId)
        .appBarConfig
        .merge(this.themeData);

    return ConstrainedBox(
      child: Text(
        title,
        style: _defaultThemeData.titleStyle.generateTextStyle(),
        overflow: TextOverflow.ellipsis,
      ),
      constraints: BoxConstraints.loose(Size.fromWidth(
          (_defaultThemeData.titleStyle.generateTextStyle().fontSize ?? 18) *
              (_defaultThemeData.titleMaxLength + 1))),
    );
  }
}

/// 在往[SantoAppBar.actions]中添加带icon的action时所使用的包装Widget
/// 此Widget中实现了大小约束，和点击实现，添加带icon类型的action时必须使用此类包裹
///
/// 几何与 [SantoBackLeading] 保持一致:点击区固定
/// [SantoAppBarConfig.leadingSize](32x32)、水波圆角 [_kAppBarIconRadius](12)、
/// 图标默认取主题 [SantoAppBarConfig.iconSize](20),左右两侧视觉对齐
class SantoIconAction extends StatelessWidget {
  /// 图标名,取值见 [SantoIcons];传入后由组件按主题图标大小构建 [SantoIcon],
  /// 建议优先使用(尺寸/颜色随 AppBar 深浅色自动对齐)
  ///
  /// @since v1.3.0
  final String? icon;

  /// 自定义图标 widget,与 [icon] 二选一;两者同时传时以 [icon] 为准
  ///
  /// 注意:自定义 widget 的尺寸由调用方负责(`SantoIcon` 不读 `IconTheme`,
  /// 需自行传 `size`),`Icon` 类图标会跟随 [size]
  final Widget? child;

  final VoidCallback iconPressed;

  /// 图标边长,默认取主题 [SantoAppBarConfig.iconSize](20)
  final double? size;

  final SantoAppBarConfig? themeData;

  SantoIconAction({
    Key? key,
    required this.iconPressed,
    this.icon,
    this.child,
    this.size,
    this.themeData,
  })  : assert(icon != null || child != null, 'SantoIconAction 的 icon 与 child 至少传一个'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    SantoAppBarConfig _defaultThemeData = themeData ?? SantoAppBarConfig();
    _defaultThemeData = SantoThemeConfigurator.instance
        .getConfig(configId: _defaultThemeData.configId)
        .appBarConfig
        .merge(_defaultThemeData);

    final double iconDimension = size ?? _defaultThemeData.iconSize;
    // AppBar 已按背景深浅解析好内容色(深色底白、浅色底黑),与 IconTheme 取齐
    final Color? iconColor = IconTheme.of(context).color;

    final Widget iconWidget = icon != null
        ? SantoIcon(icon!, size: iconDimension, color: iconColor)
        : child!;

    return Container(
      width: _defaultThemeData.leadingSize,
      height: _defaultThemeData.appBarHeight,
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(_kAppBarIconRadius),
          onTap: iconPressed,
          child: SizedBox(
            width: _defaultThemeData.leadingSize,
            height: _defaultThemeData.leadingSize,
            child: Center(
              child: IconTheme.merge(
                data: IconThemeData(size: iconDimension, color: iconColor),
                child: iconWidget,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 在往[SantoAppBar.actions]中添加文本action时所使用的包装Widget
/// 此Widget中实现了大小约束，和点击实现，添加文本action时必须使用此类包裹
class SantoTextAction extends StatelessWidget {
  final String text;
  final VoidCallback? iconPressed;
  final SantoAppBarConfig? themeData;

  SantoTextAction(this.text, {Key? key, this.iconPressed, this.themeData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SantoAppBarConfig _defaultThemeData = themeData ?? SantoAppBarConfig();
    _defaultThemeData = SantoThemeConfigurator.instance
        .getConfig(configId: _defaultThemeData.configId)
        .appBarConfig
        .merge(_defaultThemeData);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: _defaultThemeData.appBarHeight,
        alignment: Alignment.center,
        child: Text(text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _defaultThemeData.actionsStyle.generateTextStyle()),
      ),
      onTap: iconPressed,
    );
  }
}

/// AppBar底部分割线,将实例传入[SantoAppBar.bottom]属性即可
class SantoBarBottomDivider extends PreferredSize {
  SantoBarBottomDivider()
      : super(child: Container(), preferredSize: const Size(0, 0));

  @override
  Size get preferredSize => Size.fromHeight(0.5);

  @override
  Widget get child => SantoLine();
}

class _SantoSearchResultAppBar extends StatelessWidget {
  final SantoAppBarConfig? appBarConfig;
  final String? title;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;
  final bool showLeadingDivider;
  final Widget? flexibleSpace;
  final VoidCallback? backLeadCallback;
  final bool? showDefaultBottom;

  _SantoSearchResultAppBar(
      {this.appBarConfig,
      this.backgroundColor,
      this.bottom,
      this.title,
      this.showLeadingDivider = true,
      this.flexibleSpace,
      this.backLeadCallback,
      this.showDefaultBottom = true});

  @override
  Widget build(BuildContext context) {
    SantoAppBarConfig _defaultConfig = appBarConfig ?? SantoAppBarConfig();
    _defaultConfig = _defaultConfig.merge(SantoAppBarConfig(
      backgroundColor: this.backgroundColor,
      showDefaultBottom: this.showDefaultBottom,
    ));

    _defaultConfig = SantoThemeConfigurator.instance
        .getConfig(configId: _defaultConfig.configId)
        .appBarConfig
        .merge(_defaultConfig);

    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        /// leading
        SantoBackLeading(
          iconPressed: backLeadCallback,
          themeData: _defaultConfig,
        ),

        /// divider
        Visibility(
          visible: showLeadingDivider,
          child: Container(
            margin: EdgeInsets.only(
                left: commonConfig.gapMd, right: commonConfig.gapMd),
            height: 16,
            width: 1,
            color: _defaultConfig.commonConfig.dividerColorBase,
          ),
        ),

        /// padding
        Visibility(
          visible: !(showLeadingDivider),
          child: Padding(
            padding: EdgeInsets.only(left: commonConfig.gapMd),
          ),
        ),

        /// title
        Expanded(
          child: Text(
            title ?? '',
            style: _defaultConfig.titleStyle.generateTextStyle(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: commonConfig.hSpacingLg),
        )
      ],
    );
  }
}
