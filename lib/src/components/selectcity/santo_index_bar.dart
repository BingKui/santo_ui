import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// IndexBar touch callback IndexModel.
typedef IndexBarTouchCallback = void Function(IndexBarDetails model);

/// IndexModel.
class IndexBarDetails {
  String tag = ""; //current touch tag.
  int position = -1; //current touch position.
  bool isTouchDown = false; //is touch down.
}

///Default Index data.
const List<String> INDEX_DATA_DEF = const [
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z",
  "#"
];

/// IndexBar.
class IndexBar extends StatefulWidget {
  IndexBar(
      {Key? key,
      this.data = INDEX_DATA_DEF,
      required this.onTouch,
      this.width = 30,
      this.itemHeight = 16,
      this.color = Colors.transparent,
      this.currentTag = '',
      this.touchDownColor,
      this.textStyle});

  /// index data.
  final List<String> data;

  /// IndexBar width(def:30).
  final int width;

  /// IndexBar item height(def:16).
  final int itemHeight;

  /// Background color
  final Color color;

  /// 当前选中的字母(常驻高亮,跟随列表滚动所在分组)
  final String currentTag;

  /// IndexBar touch down color.
  /// 按下态底色,不传取主题 dividerColorBase
  final Color? touchDownColor;

  /// IndexBar text style,不传取主题字号与文字色
  final TextStyle? textStyle;

  /// Item touch callback.
  final IndexBarTouchCallback onTouch;

  @override
  _SuspensionListViewIndexBarState createState() =>
      _SuspensionListViewIndexBarState();
}

class _SuspensionListViewIndexBarState extends State<IndexBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: widget.color,
      width: widget.width.toDouble(),
      child: _IndexBar(
        data: widget.data,
        width: widget.width,
        itemHeight: widget.itemHeight,
        textStyle: widget.textStyle,
        touchDownColor: widget.touchDownColor,
        currentTag: widget.currentTag,
        onTouch: (details) {
          widget.onTouch(details);
        },
      ),
    );
  }
}

/// Base IndexBar.
class _IndexBar extends StatefulWidget {
  /// index data.
  final List<String> data;

  /// IndexBar width(def:30).
  final int width;

  /// IndexBar item height(def:16).
  final int itemHeight;

  /// IndexBar text style.
  final TextStyle? textStyle;

  /// 按下字母的圆角底色
  /// 按下态底色,不传取主题 dividerColorBase
  final Color? touchDownColor;

  /// 当前选中的字母(常驻高亮,跟随列表滚动所在分组)
  final String currentTag;

  /// Item touch callback.
  final IndexBarTouchCallback onTouch;

  _IndexBar(
      {Key? key,
      this.data = INDEX_DATA_DEF,
      required this.onTouch,
      this.width = 30,
      this.itemHeight = 16,
      this.textStyle,
      this.touchDownColor,
      this.currentTag = ''})
      : super(key: key);

  @override
  _IndexBarState createState() => _IndexBarState();
}

class _IndexBarState extends State<_IndexBar> {
  List<int> _indexSectionList = [];
  int _widgetTop = -1;
  int _lastIndex = 0;
  bool _widgetTopChange = false;
  IndexBarDetails _indexModel = IndexBarDetails();

  /// get index.
  int _getIndex(int offset) {
    for (int i = 0, length = _indexSectionList.length; i < length - 1; i++) {
      int a = _indexSectionList[i];
      int b = _indexSectionList[i + 1];
      if (offset >= a && offset < b) {
        return i;
      }
    }
    return -1;
  }

  void _init() {
    _widgetTopChange = true;
    _indexSectionList.clear();
    _indexSectionList.add(0);
    int tempHeight = 0;
    widget.data.forEach((value) {
      tempHeight = tempHeight + widget.itemHeight;
      _indexSectionList.add(tempHeight);
    });
  }

  _triggerTouchEvent() {
    widget.onTouch(_indexModel);
  }

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    _init();

    List<Widget> children = [];
    for (int i = 0; i < widget.data.length; i++) {
      final v = widget.data[i];
      final bool active = _indexModel.isTouchDown && _indexModel.position == i;
      // 常驻选中:当前列表分组对应的字母,品牌色圆底白字
      final bool selected = !active && v == widget.currentTag;
      children.add(SizedBox(
        width: widget.width.toDouble(),
        height: widget.itemHeight.toDouble(),
        child: Center(
          child: active || selected
              ? Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: active
                        ? (widget.touchDownColor ??
                            commonConfig.dividerColorBase)
                        : commonConfig.brandPrimary,
                  ),
                  child: Text(
                    v,
                    textAlign: TextAlign.center,
                    style: active
                        ? TextStyle(
                            fontSize: widget.textStyle?.fontSize ??
                                commonConfig.fontSizeCaption,
                            color: commonConfig.brandPrimary,
                            fontWeight: FontWeight.w600,
                          )
                        : TextStyle(
                            fontSize: widget.textStyle?.fontSize ??
                                commonConfig.fontSizeCaption,
                            color: commonConfig.colorTextBaseInverse,
                            fontWeight: FontWeight.w500,
                          ),
                  ),
                )
              : Text(
                  v,
                  textAlign: TextAlign.center,
                  style: widget.textStyle ??
                      TextStyle(
                        fontSize: commonConfig.fontSizeCaption,
                        color: commonConfig.colorTextBase,
                      ),
                ),
        ),
      ));
    }

    return GestureDetector(
      onVerticalDragDown: (DragDownDetails details) {
        if (_widgetTop == -1 || _widgetTopChange) {
          _widgetTopChange = false;
          RenderBox? box = context.findRenderObject() as RenderBox;
          Offset topLeftPosition = box.localToGlobal(Offset.zero);
          _widgetTop = topLeftPosition.dy.toInt();
        }
        int offset = details.globalPosition.dy.toInt() - _widgetTop;
        int index = _getIndex(offset);
        if (index != -1) {
          _lastIndex = index;
          _indexModel.position = index;
          _indexModel.tag = widget.data[index];
          _indexModel.isTouchDown = true;
          _triggerTouchEvent();
        }
      },
      onVerticalDragUpdate: (DragUpdateDetails details) {
        int offset = details.globalPosition.dy.toInt() - _widgetTop;
        int index = _getIndex(offset);
        if (index != -1 && _lastIndex != index) {
          _lastIndex = index;
          _indexModel.position = index;
          _indexModel.tag = widget.data[index];
          _indexModel.isTouchDown = true;
          _triggerTouchEvent();
        }
      },
      onVerticalDragEnd: (DragEndDetails details) {
        _indexModel.isTouchDown = false;
        _triggerTouchEvent();
      },
      onTapUp: (TapUpDetails details) {
        _indexModel.isTouchDown = false;
        _triggerTouchEvent();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
