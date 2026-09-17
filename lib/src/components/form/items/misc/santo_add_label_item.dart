import 'package:santo_ui/src/components/form/utils/santo_form_util.dart';
import 'package:santo_ui/src/constants/santo_fonts_constants.dart';
import 'package:santo_ui/src/theme/santo_theme.dart';
import 'package:flutter/material.dart';

/// 添加组类型录入项所使用的Widget
// ignore: must_be_immutable
class SantoAddLabel extends StatefulWidget {
  /// 录入项的唯一标识，主要用于录入类型页面框架中
  final String? label;

  /// 标题文案
  final String title;

  /// 是否可编辑
  final bool isEdit;

  /// 点击录入区回调
  final VoidCallback? onTap;

  /// 背景色
  final Color? backgroundColor;

  /// form配置
  SantoFormItemConfig? themeData;

  SantoAddLabel({
    Key? key,
    this.label,
    this.title = "",
    this.isEdit = true,
    this.backgroundColor,
    this.onTap,
    this.themeData,
  }) : super(key: key) {
    this.themeData ??= SantoFormItemConfig();
    this.themeData = SantoThemeConfigurator.instance
        .getConfig(configId: this.themeData!.configId)
        .formItemConfig
        .merge(this.themeData);
    this.themeData = this
        .themeData!
        .merge(SantoFormItemConfig(backgroundColor: backgroundColor));
  }

  @override
  SantoAddLabelState createState() {
    return SantoAddLabelState();
  }
}

class SantoAddLabelState extends State<SantoAddLabel> {
  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return GestureDetector(
      onTap: () {
        if (!SantoFormUtil.isEdit(widget.isEdit)) {
          return;
        }

        SantoFormUtil.notifyAddTap(context, widget.onTap);
      },
      child: Container(
        color: widget.themeData!.backgroundColor,
        padding: EdgeInsets.fromLTRB(commonConfig.hSpacingLg,
            commonConfig.vSpacingMd, 0, commonConfig.vSpacingMd),
        child: Text(
          widget.title,
          style: TextStyle(
            color: SantoThemeConfigurator.instance
                .getConfig()
                .commonConfig
                .brandPrimary,
            fontSize: SantoFonts.f18,
          ),
        ),
      ),
    );
  }
}
