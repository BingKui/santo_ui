

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// 星级评分条
class RatingExample extends StatefulWidget {
  @override
  _RatingExampleState createState() => _RatingExampleState();
}

class _RatingExampleState extends State<RatingExample> {
  var num = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(
        title: '星级评分控件Example',
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            // 只接受整数，外界
            Text("支持半颗"),
            SantoRatingStar(),
            SantoRatingStar(
              selectedCount: 0.5,
            ),
            SantoRatingStar(
              selectedCount: 3.1,
            ),
            SantoRatingStar(
              selectedCount: 3.6,
              count: 10,
            ),
            SizedBox(height: 20),
            GestureDetector(
              child: Text("支持点击选中，第一个支持反选"),
              onTap: () {
                SantoToast.show("haha", context);
                setState(() {
                  num = 4;
                });
              },
            ),
            SantoRatingStar(
              selectedCount: num.toDouble(),
              space: 5,
              canRatingZero: true,
              onSelected: (count) {
                SantoToast.show("选中了$count个", context);
              },
            ),
            SizedBox(height: 20),
            Text("自定义图片，颜色，大小"),
            SantoRatingStar(
              selectedCount: 3,
              space: 1,
              canRatingZero: true,
              onSelected: (count) {
                SantoToast.show("选中了$count个", context);
              },
              starBuilder: _buildRating,
            )
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
            color: Color(0xFFF0F0F0));
    }
  }
}
