

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// 列表项
class ListItem extends StatefulWidget {
  /// 点击事件
  final VoidCallback? onPressed;

  /// 标题
  final String title;
  final double? titleFontSize;
  final Color? titleColor;
  final String? imgPath;

  /// 描述
  final String describe;
  final Color describeColor;

  /// 右侧控件
  final Widget? rightWidget;

  /// 构造函数
  ListItem({
    Key? key,
    this.onPressed,
    this.title = "",
    this.titleFontSize,
    this.titleColor,
    this.describe = "",
    this.describeColor = const Color(0xFF808695),
    this.rightWidget,
    this.imgPath,
  }) : super(key: key);

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final double radius =
        SantoThemeConfigurator.instance.getConfig().commonConfig.radiusMd;
    return Material(
      color: Colors.white,
      // 圆角 + 裁切,让水波纹也贴着圆角走
      borderRadius: BorderRadius.circular(radius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.onPressed,
        child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 20),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoLine(
                height: 14,
                color: Colors.transparent,
              ),
              Wrap(children: [
                Text(
                  widget.title,
                  style: TextStyle(
                      color: widget.titleColor ?? Color(0xFF17233D),
                      fontSize: widget.titleFontSize ?? 14),
                ),
              ]),
              Padding(padding: EdgeInsets.all(2)),
              Text(
                widget.describe,
                style: TextStyle(color: widget.describeColor, fontSize: 12),
              ),
              SantoLine(
                height: 14,
                color: Colors.transparent,
              )
            ],
            ),
        ),
      ),
    );
  }
}
