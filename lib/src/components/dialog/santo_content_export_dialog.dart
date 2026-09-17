import 'package:santo_ui/src/components/button/santo_normal_button.dart';
import 'package:santo_ui/src/components/dialog/santo_dialog_utils.dart';
import 'package:santo_ui/src/constants/santo_asset_constants.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/theme/configs/santo_dialog_config.dart';
import 'package:santo_ui/src/utils/santo_tools.dart';
import 'package:flutter/material.dart';

/// 描述: 内容可扩展Dialog
// ignore: must_be_immutable
class SantoContentExportWidget extends StatelessWidget {
  /// 标题
  final String? title;

  /// 是否可关闭
  final bool isClose;

  /// 中间内容widget
  final Widget? contentWidget;

  /// 提交按钮文字
  final String? submitText;

  /// 内容最大高度
  final Color? submitBgColor;

  /// 提交操作
  final VoidCallback? onSubmit;

  /// 是否展示底部操作区域
  final bool isShowOperateWidget;

  /// the theme config for common santo_ui dialog
  SantoDialogConfig? themeData;

  SantoContentExportWidget(this.contentWidget,
      {this.title,
      required this.isClose,
      this.submitText,
      this.onSubmit,
      this.submitBgColor,
      required this.isShowOperateWidget,
      this.themeData}) {
    this.themeData ??= SantoDialogConfig();
    this.themeData = SantoThemeConfigurator.instance
        .getConfig(configId: themeData!.configId)
        .dialogConfig
        .merge(themeData);
  }

  /// 当content含TextField  键盘弹起遮挡内容
  /// 因此顶级父Widget 采用SingleChildScrollView

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0x33808695),
        body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 300),
                    decoration: BoxDecoration(
                      //背景
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(
                          SantoDialogUtils.getDialogRadius(
                              themeData!))), //设置四周圆角 角度
                    ),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            _generateTitleWidget(),
                            contentWidget ?? Container(),
                            _generateBottomWidget(context),
                          ],
                        ),
                        _generateCloseWidget(context),
                      ],
                    ),
                  ),
                )),
          ),
        ));
  }

  Widget _generateCloseWidget(BuildContext context) {
    if (isClose) {
      return Positioned(
          right: 0.0,
          child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: SantoTools.getAssetImage(SantoAsset.iconPickerClose),
              )));
    }
    return const SizedBox.shrink();
  }

  /// 构建Dialog标题
  Widget _generateTitleWidget() {
    return Padding(
      padding: null != title && title!.isNotEmpty
          ? EdgeInsets.fromLTRB(20, 25, 20, 12)
          : EdgeInsets.only(top: 20),
      child: null != title && title!.isNotEmpty
          ? Text(
              title!,
              style: SantoDialogUtils.getDialogTitleStyle(themeData!),
            )
          : Container(),
    );
  }

  /// 构建底部操作按钮
  Widget _generateBottomWidget(BuildContext context) {
    return Padding(
        padding: isShowOperateWidget
            ? EdgeInsets.fromLTRB(20, 12, 20, 20)
            : EdgeInsets.only(top: 20),
        child: isShowOperateWidget
            ? SizedBox(
                width: double.infinity,
                child: SantoNormalButton(
                  text: submitText ?? "",
                  alignment: Alignment.center,
                  constraints: const BoxConstraints.tightFor(height: 48),
                  backgroundColor:
                      submitBgColor ?? themeData!.commonConfig.brandPrimary,
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 18),
                  onTap: () {
                    if (onSubmit != null) onSubmit!();
                  },
                ),
              )
            : const SizedBox.shrink());
  }
}
