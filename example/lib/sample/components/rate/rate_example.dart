

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// 星级评分条
class RateExample extends StatefulWidget {
  @override
  _RateExampleState createState() => _RateExampleState();
}

class _RateExampleState extends State<RateExample> {
  var num = 3;

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: 'Rate 评分示例',
      padding: EdgeInsets.zero,
      scrollable: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: ListView(
          children: <Widget>[
            SantoSection(
              title: '基础用法',
              description: 'selectedCount 支持小数，小数部分以半颗展示，count 可指定星星总数',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // 只接受整数，外界
                  Text("支持半颗"),
                  SantoRate(),
                  SantoRate(
                    selectedCount: 0.5,
                  ),
                  SantoRate(
                    selectedCount: 3.1,
                  ),
                  SantoRate(
                    selectedCount: 3.6,
                    count: 10,
                  ),
                ],
              ),
            ),
            SantoSection(
              title: '点击选中',
              description: '传入 onSelected 后支持点击评分，canRatingZero 开启第一颗星反选',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    child: Text("支持点击选中，第一个支持反选"),
                    onTap: () {
                      SantoToast.show("haha", context);
                      setState(() {
                        num = 4;
                      });
                    },
                  ),
                  SantoRate(
                    selectedCount: num.toDouble(),
                    space: 5,
                    canRatingZero: true,
                    onSelected: (count) {
                      SantoToast.show("选中了$count个", context);
                    },
                  ),
                ],
              ),
            ),
            SantoSection(
              title: '自定义样式',
              description: 'starBuilder 按 RatingState 返回自定义星星，可换图片、颜色与大小',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("自定义图片，颜色，大小"),
                  SantoRate(
                    selectedCount: 3,
                    space: 1,
                    canRatingZero: true,
                    onSelected: (count) {
                      SantoToast.show("选中了$count个", context);
                    },
                    starBuilder: _buildRating,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 自定义图片，大小，颜色
  Widget _buildRating(RatingState state) {
    switch (state) {
      case RatingState.select:
        return SantoTools.getAssetSizeImage(SantoAsset.iconStar, 16, 16,
            color: Color(0xFF3571DC));
      case RatingState.half:
        return SantoTools.getAssetSizeImage(SantoAsset.iconStarHalf, 16, 16);
      default:
        return SantoTools.getAssetSizeImage(SantoAsset.iconStar, 16, 16,
            color: Color(0xFFE8EAEC));
    }
  }
}
