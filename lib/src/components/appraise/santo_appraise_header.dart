import 'package:santo_ui/src/constants/santo_asset_constants.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/utils/santo_tools.dart';
import 'package:flutter/material.dart';
import 'package:santo_ui/src/components/appraise/santo_appraise_interface.dart';

/// 描述: 评价组件title
class SantoAppraiseHeader extends StatelessWidget {
  /// 是否显示标题，默认为 true，显示
  final bool showHeader;

  /// 标题文字，默认 ''
  final String title;

  /// 标题最大行数，默认为 1
  final int maxLines;

  /// 标题类型，默认 [SantoAppraiseHeaderType.spaceBetween]
  final SantoAppraiseHeaderType headerType;

  /// 标题的 padding，为 null 时为默认 padding。
  /// headerType 为 spaceBetween 时默认为 EdgeInsets.only(left: hSpacingLg, top: 16, right: 16, bottom: vSpacingLg)
  /// headerType 为 center 时默认为 EdgeInsets.only(top: vSpacingLg, bottom: vSpacingLg)
  final EdgeInsets? headPadding;

  /// 点击关闭的回掉
  final SantoAppraiseCloseClickCallBack? cancelCallBack;

  SantoAppraiseHeader(
      {Key? key,
      this.showHeader = true,
      this.title = '',
      this.maxLines = 1,
      this.headerType = SantoAppraiseHeaderType.spaceBetween,
      this.headPadding,
      this.cancelCallBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (showHeader) {
      if (headerType == SantoAppraiseHeaderType.spaceBetween) {
        return _spaceHeader(context);
      } else if (headerType == SantoAppraiseHeaderType.center) {
        return _centerHeader();
      }
    }
    return const SizedBox.shrink();
  }

  Widget _centerHeader() {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return Container(
      color: Colors.white,
      padding: headPadding ??
          EdgeInsets.only(
              top: commonConfig.vSpacingLg, bottom: commonConfig.vSpacingLg),
      child: Text(
        title,
        maxLines: maxLines,
        style: TextStyle(
          color: SantoThemeConfigurator.instance
              .getConfig()
              .commonConfig
              .colorTextBase,
          fontSize: commonConfig.fontSizeHead,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _spaceHeader(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return Container(
      color: Colors.white,
      height: 38 + maxLines * 22.0,
      child: Padding(
        padding: headPadding ??
            EdgeInsets.only(
                left: commonConfig.hSpacingLg,
                top: commonConfig.vSpacingMd,
                right: commonConfig.hSpacingMd,
                bottom: commonConfig.vSpacingLg),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    top: commonConfig.vSpacingXs,
                    right: commonConfig.pageGap),
                child: Text(
                  title,
                  maxLines: maxLines,
                  style: TextStyle(
                    color: SantoThemeConfigurator.instance
                        .getConfig()
                        .commonConfig
                        .colorTextBase,
                    fontSize: commonConfig.fontSizeHead,
                    height: 1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (cancelCallBack != null) {
                  cancelCallBack!(context);
                }
                Navigator.of(context).pop();
              },
              child: SantoTools.getAssetImage(SantoAsset.iconPickerClose),
            ),
          ],
        ),
      ),
    );
  }
}

/// title类型
enum SantoAppraiseHeaderType {
  /// 居中
  center,

  /// 两边
  spaceBetween,
}
