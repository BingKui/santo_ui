import 'package:santo_ui/src/constants/santo_asset_constants.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/utils/santo_tools.dart';
import 'package:flutter/material.dart';

/// 描述: 星级评价列表，默认支持5个

class SantoAppraiseStarListView extends StatefulWidget {
  /// 展示的星星的数目
  final int count;

  /// 未选中时的提示
  final String? hint;

  /// 星星下面的文案，点击对应的星星会显示相应index的文案，titles长度不能比count小
  final List<String> titles;

  /// 点击回调
  final ValueChanged<int>? onTap;

  SantoAppraiseStarListView(
      {Key? key, this.count = 5, required this.titles, this.hint, this.onTap})
      : assert(count > 0 && count <= 5),
        assert(titles.length >= count),
        super(key: key);

  @override
  _SantoAppraiseStarListViewState createState() =>
      _SantoAppraiseStarListViewState();
}

class _SantoAppraiseStarListViewState extends State<SantoAppraiseStarListView> {
  Image _star =
      SantoTools.getAssetImage(SantoAsset.iconStarSize, gaplessPlayback: true);

  Image _selectedStar = SantoTools.getAssetImage(SantoAsset.iconStarSizeSelected,
      gaplessPlayback: true);

  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.titles.isEmpty) {
      return _buildStars();
    } else {
      Widget subWidget = Container();
      String? subTitle = widget.hint;
      if (_selectedIndex >= 0 && _selectedIndex < widget.titles.length) {
        subTitle = widget.titles[_selectedIndex];
      }
      if (subTitle?.isNotEmpty ?? false) {
        subWidget = Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            subTitle ?? '',
            style: TextStyle(
                fontSize: 12.0,
                color: SantoThemeConfigurator.instance
                    .getConfig()
                    .commonConfig
                    .colorTextSecondary,
                fontWeight: FontWeight.w600),
          ),
        );
      }
      return Column(
        children: <Widget>[
          _buildStars(),
          subWidget,
        ],
      );
    }
  }

  Widget _buildStars() {
    List<Widget> list = [];
    for (int i = 0; i < widget.count; i++) {
      Widget item = GestureDetector(
        child: Padding(
          padding: EdgeInsets.only(left: 6, right: 6, top: 4),
          child: (i <= _selectedIndex) ? _selectedStar : _star,
        ),
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!(i);
          }
          _selectedIndex = i;
        },
      );
      list.add(item);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: list,
    );
  }
}
