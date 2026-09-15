import 'dart:math';

import 'package:santo_ui/src/constants/santo_asset_constants.dart';
import 'package:santo_ui/src/l10n/santo_intl.dart';
import 'package:santo_ui/src/theme/santo_theme.dart';
import 'package:santo_ui/src/utils/santo_rich_text.dart';
import 'package:santo_ui/src/utils/santo_tools.dart';
import 'package:santo_ui/src/utils/css/santo_core_funtion.dart';
import 'package:santo_ui/src/utils/css/santo_css_2_text.dart';
import 'package:flutter/material.dart';

/// key-value 展示信息的集合,需要配合[SantoInfoModal]使用
///
/// 该组件有两种显示样式[isValueAlign],value字段是否对齐展示。
///
/// 除了基本的信息展示之外，该组件也可以展开收起。[expandAtIndex]是从第几个索引开始 具备展开收起的功能
///
/// 规则：
///    1：对齐的情况
///       1.1: key的最大长度为92(以七个字作为标准)，当key超过7个字的时候，折行展示
///       1.2: value 占满剩余空间，可以折行展示
///       1.3: 如果存在箭头的情况，那么key和value最多显示一行，其余...截断
///
///    2：不对齐的情况
///       2.1: key和value一行铺开，key尽可能展示，value截断...
///
///    3：展开收起规则：
///         如果expandAtIndex是-1、大于等于孩子的长度-1，则不具备展开收起功能
///         isFolded控制 初始的展开收起状态
///         展开和收起的button是蒙层
///
/// 对齐的情况是使用Table实现，通过自定义的[TableColumnWidth]来达到对齐的效果。
/// TableColumnWidth提供了获取所有子节点宽度的API。
///
/// 除了基本的信息展示外，使用[SantoInfoModal]还可以实现富文本、复杂Widget的功能。
/// 样式：
///    支持文本、富文本和自定义的widget
///    常用的情况可以通过类中的静态函数构造
///    富文本和Icon的情况推荐使用 [SantoRichTextGenerator] 构造
///
/// 如果不想要展开收起的功能，那么可以使用[SantoFollowPairInfo]和[SantoAlignPairInfo]
///
/// [SantoFollowPairInfo]的value紧跟随者key，只具备展示的功能
/// [SantoAlignPairInfo]的value具备对齐的功能，只具备展示的功能
///
/// ```dart
/// SantoPairInfoTable(
///    children: <SantoInfoModal>[
///       SantoInfoModal(keyPart: "名称：", valuePart: "内容内容内容内容"),
///       SantoInfoModal(keyPart: "名称名：", valuePart: "内容内容内容内容内容"),
///       SantoInfoModal(keyPart: "名称名称名：", valuePart: "内容内容内容内容内容"),
///       SantoInfoModal(keyPart: "名称名称名称名称：", valuePart: "内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容"),
///      ],
/// ),
///
/// SantoPairInfoTable(
///    isValueAlign : false,
///    children: <SantoInfoModal>[
///       SantoInfoModal(keyPart: "名称：", valuePart: "内容内容内容内容"),
///       SantoInfoModal(keyPart: "名称名：", valuePart: "内容内容内容内容内容"),
///       SantoInfoModal(keyPart: "名称名称名：", valuePart: "内容内容内容内容内容"),
///       SantoInfoModal(keyPart: "名称名称名称名称：", valuePart: "内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容"),
///      ],
/// ),
/// ```
///
/// 其他信息展示组件
///  * [SantoEnhanceNumberCard], 强化数字信息展示组件
///  * [SantoRichInfoGrid], 两列富文本展示组件
///  * [SantoAlignPairInfo], value对齐的文本组件
///  * [SantoFollowPairInfo], key-value紧紧相随的的文本组件
///
class SantoPairInfoTable extends StatefulWidget {

  /// 文本信息是否对齐 默认不对齐
  final bool isValueAlign;

  /// TableCell 默认垂直对齐方式， 默认值为 [TableCellVerticalAlignment.baseline]
  /// 当 [SantoInfoModal.valuePart] 为自定义 Widget 时，可设置该参数调整对齐方式，仅在
  /// [isValueAlign] 为 true 时设置才生效
  final TableCellVerticalAlignment defaultVerticalAlignment;

  /// 待展示的文本信息集合
  final List<SantoInfoModal> children;

  ///从第几个索引开始 具备展开收起的功能 如果是-1则不具备展开收起功能
  ///默认-1
  final int expandAtIndex;

  ///是否是收起的状态 默认true ，展示部分(如果具备了展开收起功能)
  final bool isFolded;

  /// 每一行的间距 默认4
  final double? rowDistance;

  /// key和value的间距 默认2
  final double? itemSpacing;

  /// the theme config of SantoPairInfoTable
  final SantoPairInfoTableConfig? themeData;

  ///对齐情况下，自定义的key展示规则
  ///默认是最大的Key展示长度是107
  ///可以参考[_MaxWrapTableWidth]实现自定义的展示规则，指定长度等
  final TableColumnWidth? customKeyWidth;

  /// Table 展开收起状态变化的回调
  final ValueChanged<bool>? onFolded;

  /// create SantoPairInfoTable
  SantoPairInfoTable({
    Key? key,
    required this.children,
    this.defaultVerticalAlignment = TableCellVerticalAlignment.baseline,
    this.isValueAlign = true,
    this.expandAtIndex = -1,
    this.rowDistance,
    this.itemSpacing,
    this.isFolded = true,
    this.onFolded,
    this.customKeyWidth,
    this.themeData
  });

  @override
  _SantoPairInfoTableState createState() => _SantoPairInfoTableState();
}

class _SantoPairInfoTableState extends State<SantoPairInfoTable> {
  //当前的展示状态
  late bool _isFolded;

  //指定索引位置去具备展开功能
  late int _expandAtIndex;

  // 收起状态显示的孩子
  List<SantoInfoModal>? _foldList;

  // 展开状态显示的孩子
  List<SantoInfoModal?>? _expandedList;

  // 在页面呈现的孩子
  List<SantoInfoModal?>? _showList;

  // 指定位置的最原始 modal
  SantoInfoModal? indexModal;

  // 是否具备展开收起功能 如果不展示则显示全部
  bool _canFold = false;

  late SantoPairInfoTableConfig themeData;

  @override
  void initState() {
    themeData = widget.themeData ?? SantoPairInfoTableConfig();
    themeData =
        themeData.merge(SantoPairInfoTableConfig(rowSpacing: widget.rowDistance));
    themeData = SantoThemeConfigurator.instance
        .getConfig(configId: themeData.configId)
        .pairInfoTableConfig
        .merge(themeData);

    _isFolded = widget.isFolded;
    _expandAtIndex = widget.expandAtIndex;

    if (_expandAtIndex < 0 ||
        widget.expandAtIndex >= (widget.children.length - 1)) {
      _expandAtIndex = -1;
      _showList = widget.children;
      _canFold = false;
    } else {
      indexModal = widget.children[_expandAtIndex];
      _foldList = _generateFoldList();
      _expandedList = _generateExpandedList();
      _canFold = true;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(SantoPairInfoTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    themeData =
        themeData.merge(SantoPairInfoTableConfig(rowSpacing: widget.rowDistance));
    themeData = SantoThemeConfigurator.instance
        .getConfig(configId: themeData.configId)
        .pairInfoTableConfig
        .merge(themeData);
  }

  @override
  Widget build(BuildContext context) {
    Widget showWidget;

    if (_canFold) {
      if (_isFolded) {
        _showList = _foldList;
      } else {
        _showList = _expandedList;
      }
    } else {
      _showList = widget.children;
    }

    if (widget.isValueAlign) {
      showWidget = SantoAlignPairInfo(
        defaultVerticalAlignment: widget.defaultVerticalAlignment,
        children: _showList,
        itemSpacing: widget.itemSpacing,
        rowDistance: widget.rowDistance,
        themeData: themeData,
        customKeyWidth: widget.customKeyWidth,
      );
    } else {
      showWidget = SantoFollowPairInfo(
        children: _showList,
        itemSpacing: widget.itemSpacing,
        rowDistance: widget.rowDistance,
        themeData: themeData,
      );
    }
    return showWidget;
  }

  Widget _finalValueWidget(SantoInfoModal data, {double? itemSpacing}) {
    Widget? valueWidget;

    if (data.valuePart is String) {
      valueWidget = _valueTitleText(data.valuePart,
          isValueAlign: widget.isValueAlign,
          isArrow: data.isArrow,
          themeData: themeData);
    } else {
      valueWidget = data.valuePart;

      if (valueWidget == null) {
        valueWidget = Text(
          '--',
          style: themeData.valueTextStyle.generateTextStyle(),
        );
      }
    }
    if (data.isArrow) {
      valueWidget = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(child: valueWidget),
          SantoTools.getAssetImage(SantoAsset.iconRightArrow),
        ],
      );
    }
    return Padding(
      padding: EdgeInsets.only(left: itemSpacing ?? themeData.itemSpacing),
      child: valueWidget,
    );
  }

  /// 收起状态的孩子
  /// 替换指定位置的value为具备展开功能的widget
  List<SantoInfoModal> _generateFoldList() {
    List<SantoInfoModal> finalChildren = List<SantoInfoModal>.of(widget.children);
    //生成新的value
    SantoInfoModal expRowWidget = _foldButtonWidget();
    //替换modal
    finalChildren[widget.expandAtIndex] = expRowWidget;
    //移除指定索引
    finalChildren.removeRange(widget.expandAtIndex + 1, widget.children.length);
    return finalChildren;
  }

  /// 张开状态的孩子
  /// 替换最后的value 为具备收起功能的 value
  /// 替换index的value 为原始的value
  List<SantoInfoModal?> _generateExpandedList() {
    List<SantoInfoModal?> finalChildren = List<SantoInfoModal?>.of(widget.children);
    SantoInfoModal foldRowWidget = _expandedButtonWidget();
    finalChildren[_expandAtIndex] = indexModal;
    finalChildren[widget.children.length - 1] = foldRowWidget;
    return finalChildren;
  }

  SantoInfoModal _foldButtonWidget() {
    Image img = SantoTools.getAssetImage(SantoAsset.iconUpArrow);
    Transform trsm = Transform.rotate(angle: pi, child: img);
    Row row = Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Text(
            SantoIntl.currentResource.expand,
            style: TextStyle(
              fontSize: 14,
              color: themeData.commonConfig.colorTextSecondary,
            ),
          ),
        ),
        trsm
      ],
    );
    GestureDetector gdt = GestureDetector(
        child: row,
        onTap: () {
          widget.onFolded?.call(!_isFolded);
          setState(() {
            _isFolded = !_isFolded;
          });
        });

    Container layerCtn = Container(
      padding: const EdgeInsets.only(left: 30),
      alignment: Alignment.center,
      child: gdt,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [Colors.white.withAlpha(100), Colors.white, Colors.white],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      )),
    );

    /// 展开蒙层
    Widget foldButtonWidget = layerCtn;

    /// 将原有的value显示替换为 stack
    SantoInfoModal santoInfoModal = SantoInfoModal(
      isArrow: indexModal!.isArrow,
      keyPart: indexModal!.keyPart,
      valuePart: indexModal!.valuePart,
    );
    Container stack = Container(
      child: Stack(
        children: <Widget>[
          _finalValueWidget(santoInfoModal, itemSpacing: 0),
          Positioned(bottom: 0, right: 0, child: foldButtonWidget),
        ],
      ),
    );
    santoInfoModal.valuePart = stack;
    return santoInfoModal;
  }

  SantoInfoModal _expandedButtonWidget() {
    Image img = SantoTools.getAssetImage(SantoAsset.iconUpArrow);
    Row row = Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Text(
            SantoIntl.currentResource.collapse,
            style: TextStyle(
              fontSize: 14,
              color: themeData.commonConfig.colorTextSecondary,
            ),
          ),
        ),
        img
      ],
    );

    GestureDetector gdt = GestureDetector(
        child: row,
        onTap: () {
          widget.onFolded?.call(!_isFolded);
          setState(() {
            _isFolded = !_isFolded;
          });
        });

    Container layerCtn = Container(
      padding: EdgeInsets.only(left: 30),
      alignment: Alignment.topRight,
      child: gdt,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [Colors.white.withAlpha(100), Colors.white, Colors.white],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      )),
    );

    ///收起的widget
    Widget foldButtonWidget = layerCtn;

    SantoInfoModal santoInfoModal = SantoInfoModal(
      isArrow: widget.children.last.isArrow,
      keyPart: widget.children.last.keyPart,
      valuePart: widget.children.last.valuePart,
    );

    Container stack = Container(
      child: Stack(
        children: <Widget>[
          _finalValueWidget(santoInfoModal, itemSpacing: 0),
          Positioned(bottom: 0, right: 0, child: foldButtonWidget),
        ],
      ),
    );
    santoInfoModal.valuePart = stack;
    return santoInfoModal;
  }

  Widget _valueTitleText(String text,
      {bool isValueAlign = true,
      bool isArrow = false,
      required SantoPairInfoTableConfig themeData}) {
    bool isSingle;
    if (isArrow) {
      isSingle = true;
    } else {
      isSingle = !isValueAlign;
    }

    String show;
    if (text.isEmpty) {
      show = '--';
    } else {
      show = text;
    }

    Widget keyOrValue = Text(
      show,
      overflow: isSingle ? TextOverflow.ellipsis : TextOverflow.clip,
      maxLines: isSingle ? 1 : null,
      style: themeData.valueTextStyle.generateTextStyle(),
    );
    return keyOrValue;
  }
}

mixin PairInfoPart {
  bool isValueAlign();

  SantoPairInfoTableConfig configDefaultThemeData(
      SantoPairInfoTableConfig? themeData,
      {double? rowDistance,
      double? itemSpacing}) {
    SantoPairInfoTableConfig defaultThemeData;
    defaultThemeData = themeData ?? SantoPairInfoTableConfig();
    defaultThemeData = defaultThemeData.merge(SantoPairInfoTableConfig(
        rowSpacing: rowDistance, itemSpacing: itemSpacing));
    defaultThemeData = SantoThemeConfigurator.instance
        .getConfig(configId: defaultThemeData.configId)
        .pairInfoTableConfig
        .merge(defaultThemeData);
    return defaultThemeData;
  }

  Widget? finalKeyWidget(SantoInfoModal data, SantoPairInfoTableConfig themeData) {
    Widget? keyWidget;
    if (data.keyPart is String) {
      keyWidget = keyOrValueTitleText(true, data.keyPart.toString(),
          isValueAlign: isValueAlign(),
          isArrow: data.isArrow,
          themeData: themeData);
    } else {
      keyWidget = data.keyPart;
    }
    return keyWidget;
  }

  Widget finalValueWidget(SantoInfoModal data, SantoPairInfoTableConfig themeData,
      {double? itemSpacing}) {
    Widget? valueWidget;

    if (data.valuePart is String) {
      valueWidget = keyOrValueTitleText(false, data.valuePart,
          isValueAlign: isValueAlign(),
          isArrow: data.isArrow,
          themeData: themeData);
    } else {
      valueWidget = data.valuePart;

      if (valueWidget == null) {
        valueWidget = Text(
          '--',
          style: themeData.valueTextStyle.generateTextStyle(),
        );
      }
    }
    if (data.isArrow) {
      valueWidget = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(child: valueWidget),
          SantoTools.getAssetImage(SantoAsset.iconRightArrow),
        ],
      );
    }
    return Padding(
      padding: EdgeInsets.only(left: itemSpacing ?? themeData.itemSpacing),
      child: valueWidget,
    );
  }

  Widget keyOrValueTitleText(bool isKey, String text,
      {bool isValueAlign = true,
      bool isArrow = false,
      required SantoPairInfoTableConfig themeData}) {
    bool isSingle;
    if (isArrow) {
      isSingle = true;
    } else {
      isSingle = !isValueAlign;
    }

    String show;
    if (text.isEmpty) {
      if (isKey) {
        show = '--：';
      } else {
        show = '--';
      }
    } else {
      show = text;
    }

    Widget keyOrValue = Text(
      show,
      overflow: isSingle ? TextOverflow.ellipsis : TextOverflow.clip,
      maxLines: isSingle ? 1 : null,
      style: isKey
          ? themeData.keyTextStyle.generateTextStyle()
          : themeData.valueTextStyle.generateTextStyle(),
    );
    return keyOrValue;
  }
}

class SantoFollowPairInfo extends StatelessWidget with PairInfoPart {
  /// 待展示的文本信息集合
  final List<SantoInfoModal?>? children;

  /// 每一行的间距
  final double? rowDistance;

  /// key和value的间距
  final double? itemSpacing;

  final SantoPairInfoTableConfig? themeData;

  SantoFollowPairInfo({
    Key? key,
    required this.children,
    this.rowDistance,
    this.itemSpacing,
    this.themeData,
  });

  @override
  Widget build(BuildContext context) {
    SantoPairInfoTableConfig defaultThemeConfig = configDefaultThemeData(
        themeData,
        rowDistance: rowDistance,
        itemSpacing: itemSpacing);

    return _buildRowWidget(defaultThemeConfig);
  }

  Widget _buildRowWidget(SantoPairInfoTableConfig defaultThemeConfig) {
    int index = -1;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children!.map((data) {
            index++;
            return Padding(
              padding: EdgeInsets.only(
                  top: (index == 0) ? 0 : themeData!.rowSpacing),
              child: _buildSingleInfo(
                  data!, constraints.maxWidth / 2, defaultThemeConfig),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildSingleInfo(SantoInfoModal infoModal, double keyMax,
      SantoPairInfoTableConfig defaultThemeConfig) {
    Widget value = finalValueWidget(infoModal, defaultThemeConfig);
    if (infoModal.valueClickCallback != null) {
      value = GestureDetector(
        onTap: () {
          infoModal.valueClickCallback?.call();
        },
        child: value,
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: keyMax),
          child: finalKeyWidget(infoModal, defaultThemeConfig),
        ),
        Flexible(
          child: value,
        )
      ],
    );
  }

  @override
  bool isValueAlign() {
    return false;
  }
}

class SantoAlignPairInfo extends StatelessWidget with PairInfoPart {
  /// TableCell 默认垂直对齐方式， 默认值为 [TableCellVerticalAlignment.baseline]
  /// 当 [SantoInfoModal.valuePart] 为自定义 Widget 时，可设置该参数调整对齐方式
  final TableCellVerticalAlignment defaultVerticalAlignment;

  /// 待展示的文本信息集合
  final List<SantoInfoModal?>? children;

  ///控件的背景色 默认为白色
  final Color? backgroundColor;

  /// 每一行的间距
  final double? rowDistance;

  /// key和value的间距
  final double? itemSpacing;

  final TableColumnWidth? customKeyWidth;

  final SantoPairInfoTableConfig? themeData;

  SantoAlignPairInfo(
      {this.children,
      this.defaultVerticalAlignment = TableCellVerticalAlignment.baseline,
      this.rowDistance,
      this.backgroundColor,
      this.itemSpacing,
      this.customKeyWidth,
      this.themeData});

  @override
  Widget build(BuildContext context) {
    SantoPairInfoTableConfig defaultThemeConfig = configDefaultThemeData(
        themeData,
        rowDistance: rowDistance,
        itemSpacing: itemSpacing);

    return LayoutBuilder(
      builder: (context, constraints) {
        return _buildAlignWidget(defaultThemeConfig, constraints.maxWidth);
      },
    );
  }

  //对齐的时候 使用tab实现
  Widget _buildAlignWidget(
      SantoPairInfoTableConfig defaultThemeConfig, double maxWith) {
    int index = -1;
    Widget table = Table(
      defaultVerticalAlignment: this.defaultVerticalAlignment,
      textBaseline: TextBaseline.ideographic,
      columnWidths: <int, TableColumnWidth>{
        0: customKeyWidth ?? _MaxWrapTableWidth(maxWith),
        1: FlexColumnWidth()
      },
      border: TableBorder.all(color: Colors.transparent),
      children: children!.map((data) {
        index++;
        return _buildSingleInfo(
            data!, index == children!.length - 1, defaultThemeConfig);
      }).toList(),
    );
    return table;
  }

  @override
  bool isValueAlign() {
    return true;
  }

  TableRow _buildSingleInfo(SantoInfoModal infoModal, bool isLast,
      SantoPairInfoTableConfig defaultThemeConfig) {
    Widget value = Padding(
        padding:
            EdgeInsets.only(bottom: isLast ? 0 : defaultThemeConfig.rowSpacing),
        child: finalValueWidget(infoModal, defaultThemeConfig));

    if (infoModal.valueClickCallback != null) {
      value = GestureDetector(
        onTap: () {
          if (infoModal.valueClickCallback != null) {
            infoModal.valueClickCallback!();
          }
        },
        child: value,
      );
    }
    return TableRow(
        children: [finalKeyWidget(infoModal, defaultThemeConfig)!, value]);
  }
}

/// 用于展示信息的modal，封装了key和value的基本信息
///
/// 基本的文本展示只需 传入keyPart和valuePart为字符串
/// 复杂的展示 需要传入Widget，SantoInfoModal的若干静态方法 提供了丰富简便的富文本使用方式
///
class SantoInfoModal {
  /// 方便业务调用，具备两种类型 string 和 widget
  dynamic keyPart;

  /// 方便业务调用，具备两种类型 string 和 widget
  dynamic valuePart;

  /// 右侧是否包含箭头
  /// 如果有箭头那么  key-value一行展示
  final bool isArrow;

  /// value的点击回调
  final VoidCallback? valueClickCallback;

  SantoInfoModal(
      {this.keyPart,
      this.valuePart,
      this.isArrow = false,
      this.valueClickCallback})
      : assert(keyPart == null || keyPart is String || keyPart is Widget),
        assert(valuePart == null || valuePart is String || valuePart is Widget);

  ///-----------以下静态方法为常见显示的快捷构造-----------
  /// value的最后一部分带有可点击的超链接
  ///
  /// keyTitle 显示的key文案
  /// valueTitle 显示的value文案
  /// clickValue 显示的可点击文案
  /// fontSize 文案的大小
  /// clickCallback 可点击文案点击的回调
  /// isArrow 是否最右侧存在箭头
  static SantoInfoModal valueLastClickInfo(
      BuildContext context,
    String keyTitle,
    String valueTitle,
    String clickValue, {
    double? fontSize,
    double? itemSpacing,
    TextStyle? valueTextStyle,
    Function(String? clickValue)? clickCallback,
    bool isArrow = false,
    VoidCallback? valueClickCallback,
    Color? linkColor,
    SantoPairInfoTableConfig? themeData,
  }) {
    themeData ??= SantoPairInfoTableConfig();
    themeData = SantoThemeConfigurator.instance
        .getConfig(configId: themeData.configId)
        .pairInfoTableConfig
        .merge(themeData);
    themeData = themeData.merge(SantoPairInfoTableConfig(
        itemSpacing: itemSpacing,
        keyTextStyle: SantoTextStyle(fontSize: fontSize),
        valueTextStyle: SantoTextStyle(fontSize: fontSize)
            .merge(SantoTextStyle.withStyle(valueTextStyle)),
        linkTextStyle: SantoTextStyle(fontSize: fontSize, color: linkColor)
            .merge(SantoTextStyle.withStyle(valueTextStyle))));

    Widget valueWidget;
    if (isArrow) {
      valueWidget = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Text(
              valueTitle,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: themeData.valueTextStyle.generateTextStyle(),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (clickCallback != null) {
                clickCallback(clickValue);
              }
            },
            child: Text(
              clickValue,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: themeData.linkTextStyle.generateTextStyle(),
            ),
          )
        ],
      );
    } else {
      valueWidget = SantoRichTextGenerator()
          .addText(
            valueTitle,
            textStyle: themeData.valueTextStyle.generateTextStyle(),
          )
          .addTextWithLink(
            clickValue,
            textStyle: themeData.linkTextStyle.generateTextStyle(),
            richTextLinkClick: (text, url) {
              if (clickCallback != null) {
                clickCallback(text);
              }
            },
          )
          .addIcon(const SizedBox.shrink())
          .build();
    }

    return SantoInfoModal(
      keyPart: keyTitle,
      valuePart: valueWidget,
      isArrow: isArrow,
      valueClickCallback: valueClickCallback,
    );
  }

  /// key或者value的文本的最后带有问号
  ///
  /// keyTitle 显示的key文案
  /// valueTitle 显示的value文案
  /// keyShow 是否可key的最后带有问号
  /// valueShow 是否value的最后带有问号
  /// keyCallback key的小问号点击的回调
  /// valueCallback value的小问号点击的回调
  ///   /// isArrow 是否最右侧存在箭头
  static SantoInfoModal keyOrValueLastQuestionInfo(
  BuildContext context,
    String keyTitle,
    String valueTitle, {
    bool keyShow = false,
    bool valueShow = true,
    double? fontSize,
    double? itemSpacing,
    TextStyle? keyTextStyle,
    TextStyle? valueTextStyle,
    Function? keyCallback,
    Function? valueCallback,
    bool isArrow = false,
    VoidCallback? valueClickCallback,
    SantoPairInfoTableConfig? themeData,
  }) {
    themeData ??= SantoPairInfoTableConfig();
    themeData = SantoThemeConfigurator.instance
        .getConfig(configId: themeData.configId)
        .pairInfoTableConfig
        .merge(themeData);
    themeData = themeData.merge(SantoPairInfoTableConfig(
        itemSpacing: itemSpacing,
        keyTextStyle: SantoTextStyle(fontSize: fontSize)
            .merge(SantoTextStyle.withStyle(keyTextStyle)),
        valueTextStyle: SantoTextStyle(fontSize: fontSize)
            .merge(SantoTextStyle.withStyle(valueTextStyle))));

    dynamic valueWidget;
    dynamic keyWidget;

    if (isArrow) {
      MediaQueryData mediaQuery = MediaQueryData.fromView(View.of(context));
      double screen = mediaQuery.size.width;

      if (keyShow) {
        keyWidget = Container(
          constraints: BoxConstraints(maxWidth: screen / 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Text(
                  keyTitle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: themeData.keyTextStyle.generateTextStyle(),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (keyCallback != null) {
                    keyCallback();
                  }
                },
                child: SantoTools.getAssetImage(SantoAsset.iconQuestion),
              ),
              Text(
                '：',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: themeData.valueTextStyle.generateTextStyle(),
              )
            ],
          ),
        );
      } else {
        keyWidget = keyTitle;
      }

      if (valueShow) {
        valueWidget = Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Text(
                valueTitle,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: themeData.keyTextStyle.generateTextStyle(),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (valueCallback != null) {
                  valueCallback();
                }
              },
              child: SantoTools.getAssetImage(SantoAsset.iconQuestion),
            )
          ],
        );
      } else {
        valueWidget = valueTitle;
      }
    } else {
      SantoRichTextGenerator keyGen = SantoRichTextGenerator();
      keyGen.addText(keyTitle,
          textStyle: themeData.keyTextStyle.generateTextStyle());
      if (keyShow) {
        keyGen.addIcon(GestureDetector(
          onTap: () {
            if (keyCallback != null) {
              keyCallback();
            }
          },
          child: SantoTools.getAssetImage(SantoAsset.iconQuestion),
        ));
        keyGen.addText('：',
            textStyle: themeData.keyTextStyle.generateTextStyle());
      }
      keyWidget = keyGen.build();

      SantoRichTextGenerator valueGen = SantoRichTextGenerator();
      valueGen.addText(valueTitle,
          textStyle: themeData.valueTextStyle.generateTextStyle());
      if (valueShow) {
        valueGen.addIcon(GestureDetector(
          onTap: () {
            if (valueCallback != null) {
              valueCallback();
            }
          },
          child: SantoTools.getAssetImage(SantoAsset.iconQuestion),
        ));
      }
      valueWidget = valueGen.build();
    }

    return SantoInfoModal(
      keyPart: keyWidget,
      valuePart: valueWidget,
      isArrow: isArrow,
      valueClickCallback: valueClickCallback,
    );
  }

  /// key的前面有一个自定义的icon icon和文本间距是8
  ///
  /// keyTitle 显示的key文案
  /// valueTitle 显示的value文案
  /// headIcon key前面的icon
  /// fontSize 文本
  /// isArrow 是否最右侧存在箭头
  static SantoInfoModal keyHeadIconInfo(
    String keyTitle,
    String valueTitle, {
    Widget? headIcon,
    double? fontSize,
    double? itemSpacing,
    TextStyle? keyTextStyle,
    TextStyle? valueTextStyle,
    bool isArrow = false,
    VoidCallback? valueClickCallback,
    SantoPairInfoTableConfig? themeData,
  }) {
    themeData ??= SantoPairInfoTableConfig();
    themeData = SantoThemeConfigurator.instance
        .getConfig(configId: themeData.configId)
        .pairInfoTableConfig
        .merge(themeData);
    themeData = themeData.merge(SantoPairInfoTableConfig(
        itemSpacing: itemSpacing,
        keyTextStyle: SantoTextStyle(fontSize: fontSize)
            .merge(SantoTextStyle.withStyle(keyTextStyle)),
        valueTextStyle: SantoTextStyle(fontSize: fontSize)
            .merge(SantoTextStyle.withStyle(valueTextStyle))));

    SantoRichTextGenerator keyGen = SantoRichTextGenerator();
    if (headIcon != null) {
      keyGen.addIcon(
          SizedBox(
            height: 12,
            width: 12,
            child: headIcon,
          ),
          alignment: PlaceholderAlignment.top);
      keyGen.addIcon(
          SizedBox(
            width: 8,
          ),
          alignment: PlaceholderAlignment.middle);
    }

    keyGen.addText(keyTitle,
        textStyle: themeData.keyTextStyle.generateTextStyle());

    return SantoInfoModal(
        keyPart: keyGen.build(),
        valuePart: valueTitle,
        isArrow: isArrow,
        valueClickCallback: valueClickCallback);
  }

  /// value是富文本
  static SantoInfoModal valueRichTextInfo(
    String keyTitle,
    String valueTitle, {
    double? fontSize,
    required double itemSpacing,
    TextStyle? valueTextStyle,
    bool isArrow = false,
    SantoHyperLinkCallback? richTextLinkClick,
    VoidCallback? valueClickCallback,
    SantoPairInfoTableConfig? themeData,
  }) {
    themeData ??= SantoPairInfoTableConfig();
    themeData = SantoThemeConfigurator.instance
        .getConfig(configId: themeData.configId)
        .pairInfoTableConfig
        .merge(themeData);
    themeData = themeData.merge(SantoPairInfoTableConfig(
        itemSpacing: itemSpacing,
        keyTextStyle: SantoTextStyle(fontSize: fontSize),
        valueTextStyle: SantoTextStyle(fontSize: fontSize)
            .merge(SantoTextStyle.withStyle(valueTextStyle))));

    return SantoInfoModal(
        keyPart: keyTitle,
        valuePart: Padding(
          padding: EdgeInsets.only(left: itemSpacing),
          child: ExcludeSemantics(
            child: SantoCSS2Text.toTextView(valueTitle,
                maxLines: isArrow ? 1 : null,
                textOverflow:
                    isArrow ? TextOverflow.ellipsis : TextOverflow.clip,
                defaultStyle: themeData.valueTextStyle.generateTextStyle(),
                linksCallback: (text, url) {
              if (richTextLinkClick != null) {
                richTextLinkClick(text, url);
              }
            }),
          ),
        ),
        valueClickCallback: valueClickCallback,
        isArrow: isArrow);
  }
}

/// 自定义TableColumnWidth 实现组件的key部分，达到最大宽度折行的效果
/// maxIntrinsicWidth来约束这一列的宽度范围
/// cells是这一列的布局信息，通过布局信息我们可以拿到 这一列的所有尺寸信息
/// 进而通过对比 来实现 最大宽度的功能
class _MaxWrapTableWidth extends TableColumnWidth {
  final double maxWidth;

  @override
  double maxIntrinsicWidth(Iterable<RenderBox> cells, double containerWidth) {
    double max = 0;
    cells.forEach((data) {
      double width = data.getMaxIntrinsicWidth(double.infinity);
      if (width > max) {
        max = width;
      }
    });

    double screen = maxWidth;
    double width =
        screen * (double.parse(((107 / 375.0)).toStringAsPrecision(5)));
    return max > width ? width : max;
  }

  @override
  double minIntrinsicWidth(Iterable<RenderBox> cells, double containerWidth) {
    return 0;
  }

  _MaxWrapTableWidth(this.maxWidth);
}
