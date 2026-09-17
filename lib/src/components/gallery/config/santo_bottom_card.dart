import 'dart:math';

import 'package:santo_ui/src/constants/santo_asset_constants.dart';
import 'package:santo_ui/src/l10n/santo_intl.dart';
import 'package:santo_ui/src/theme/configs/santo_gallery_detail_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/utils/santo_tools.dart';
import 'package:flutter/material.dart';

/// [fold] 收起状态
/// [unfold] 展开状态
/// [cantFold] 不可折叠的状态，描述信息直接展开
enum PhotoBottomCardState { fold, unFold, cantFold }

// ignore: must_be_immutable
class SantoPhotoBottomCard extends StatefulWidget {
  final String? name;
  final String? des;
  final PhotoBottomCardState model;
  final double contentHeight;
  SantoGalleryDetailConfig? themeData;

  SantoPhotoBottomCard(
      {Key? key,
      this.name,
      this.des,
      this.model = PhotoBottomCardState.cantFold,
      this.contentHeight = 150,
      this.themeData})
      : super(key: key);

  @override
  _SantoPhotoBottomCardState createState() => _SantoPhotoBottomCardState();
}

class _SantoPhotoBottomCardState extends State<SantoPhotoBottomCard>
    with TickerProviderStateMixin {
  PhotoBottomCardState? state;

  @override
  void initState() {
    super.initState();
    state = widget.model;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: widget.themeData!.bottomBackgroundColor,
      child: state == PhotoBottomCardState.cantFold
          ? buildCantFoldWidget()
          : buildFoldableWidget(),
    );
  }

  /// 构建可折叠的card
  Widget buildFoldableWidget() {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    if (state == PhotoBottomCardState.fold) {
      return Container(
        height: 53,
        padding: EdgeInsets.only(
            left: commonConfig.hSpacingLg, right: commonConfig.hSpacingLg),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(widget.name ?? "",
                style: widget.themeData!.titleStyle.generateTextStyle()),
            GestureDetector(
              onTap: () {
                setState(() {
                  state = PhotoBottomCardState.unFold;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(right: commonConfig.hSpacingXs),
                    child: Text(SantoIntl.of(context).localizedResource.expand,
                        style:
                            widget.themeData!.actionStyle.generateTextStyle()),
                  ),
                  Transform.rotate(
                    angle: pi,
                    child: SantoTools.getAssetImageWithColor(
                        SantoAsset.iconUpArrow, widget.themeData!.iconColor),
                  )
                ],
              ),
            )
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(
            left: commonConfig.hSpacingLg, right: commonConfig.hSpacingLg),
        child: Column(
          children: <Widget>[
            Container(
              height: 53,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(widget.name ?? "",
                      style: widget.themeData!.titleStyle.generateTextStyle()),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        state = PhotoBottomCardState.fold;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(right: commonConfig.hSpacingXs),
                          child: Text(SantoIntl.of(context).localizedResource.collapse,
                              style: widget.themeData!.actionStyle
                                  .generateTextStyle()),
                        ),
                        SantoTools.getAssetImageWithColor(
                            SantoAsset.iconUpArrow, widget.themeData!.iconColor)
                      ],
                    ),
                  )
                ],
              ),
            ),
            Text(
              widget.des ?? "",
              style: widget.themeData!.contentStyle.generateTextStyle(),
            )
          ],
        ),
      );
    }
  }

  /// 构建不可折叠的 card, content 是一个 ScrollView
  Widget buildCantFoldWidget() {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 53,
          child: Padding(
            padding: EdgeInsets.only(
                top: commonConfig.vSpacingMd,
                bottom: 12,
                left: commonConfig.hSpacingLg,
                right: commonConfig.hSpacingLg),
            child: Text(
              widget.name ?? "",
              style: widget.themeData!.titleStyle.generateTextStyle(),
            ),
          ),
        ),
        Container(
            height: widget.contentHeight,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                  child: Text(
                    widget.des ?? "",
                    style: widget.themeData!.contentStyle.generateTextStyle(),
                  ),
                  padding: EdgeInsets.only(
                      left: commonConfig.hSpacingLg,
                      right: commonConfig.hSpacingLg)),
            ))
      ],
    );
  }
}
