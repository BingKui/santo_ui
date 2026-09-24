

import 'package:santo_ui/src/components/picker/base/santo_picker_title.dart';
import 'package:santo_ui/src/components/picker/base/santo_picker_title_config.dart';
import 'package:santo_ui/src/components/picker/santo_picker_cliprrect.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/theme/configs/santo_picker_config.dart';
import 'package:flutter/material.dart';

enum SantoCommonPickBackType {
  cancel,
  confirm,
}

typedef TagsPickerContentBuilder = Widget Function(
    BuildContext context, VoidCallback? onUpdate);

/// 创建时传入Builder 或者 子类实现 createBuilder 函数
// ignore: must_be_immutable
abstract class CommonTagsPicker extends StatefulWidget {
  final BuildContext context;
  final ValueChanged? onConfirm;
  final VoidCallback? onCancel;
  final TagsPickerContentBuilder? contentBuilder;
  final SantoPickerTitleConfig pickerTitleConfig;

  SantoPickerConfig? themeData;

  CommonTagsPicker(
      {Key? key,
      required this.context,
      this.onConfirm,
      this.onCancel,
      this.contentBuilder,
      this.pickerTitleConfig = SantoPickerTitleConfig.Default,
      this.themeData})
      : super(key: key) {
    this.themeData ??= SantoPickerConfig();
    this.themeData = SantoThemeConfigurator.instance
        .getConfig(configId: this.themeData!.configId)
        .pickerConfig
        .merge(this.themeData);
  }

  void show() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        // 允许弹窗使用更大高度(带输入框时需要容纳底部按钮)
        isScrollControlled: true,
        builder: (BuildContext context) {
          // 键盘弹起时整体上移,避免输入区被遮挡
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: this,
          );
        }).then((type) {
      if (type == SantoCommonPickBackType.confirm) {
        if (onConfirm != null) {
          onConfirm!(getConfirmData());
        }
      } else {
        if (onCancel != null) {
          onCancel!();
        }
      }
    });
  }

  /// 子类重写实现builder
  @protected
  Widget? createBuilder(BuildContext context, VoidCallback? onUpdate) {
    return null;
  }

  /// 子类可重写,提供固定在底部的区域(如提交按钮)
  @protected
  Widget? buildFooter(BuildContext context, VoidCallback? onUpdate) {
    return null;
  }

  /// 子类可重写,控制内容区最大高度
  @protected
  double maxContentHeight(BuildContext context) => 370.0;

  /// 子类需重写getConfirmData()函数，直接使用LJTagsPickerWidget类时忽略
  @protected
  Object getConfirmData();

  @override
  _CommonPickerState createState() => _CommonPickerState();
}

class _CommonPickerState extends State<CommonTagsPicker> {
  VoidCallback? _onUpdate;

  @override
  void initState() {
    super.initState();
    _onUpdate = () {
      setState(() {
        /*刷新*/
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return SantoPickerClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(SantoThemeConfigurator.instance
            .getConfig()
            .pickerConfig
            .cornerRadius),
        topRight: Radius.circular(SantoThemeConfigurator.instance
            .getConfig()
            .pickerConfig
            .cornerRadius),
      ),
      child: Container(
          color: commonConfig.fillBase,
          // 底部安全区:白色背景铺到屏幕底部(包含安全区),内容在其上方避让,
          // 与 SantoFloatingPanel 的处理一致
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom),
            child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: 168.0,
                maxHeight: widget.maxContentHeight(context)),
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Flexible:内容按自身高度收拢,过高时内部滚动
                    Flexible(child: _createContentWidget()),
                    ?widget.buildFooter(context, _onUpdate),
                  ],
                ),
                _createHeaderWidget(), // 保证头视图在Stack的最上层
              ],
              ),
            ),
          )),
    );
  }

  // 创建头部视图
  Widget _createHeaderWidget() {
    return SantoPickerTitle(
      pickerTitleConfig: widget.pickerTitleConfig,
      themeData: widget.themeData,
      onCancel: () {
        Navigator.of(widget.context).pop(SantoCommonPickBackType.cancel);
      },
      onConfirm: () {
        Navigator.of(widget.context).pop(SantoCommonPickBackType.confirm);
      },
    );
  }

  /// 创建内容视图
  Widget _createContentWidget() {
    Widget? contentWidget;
    if (widget.contentBuilder != null) {
      contentWidget = widget.contentBuilder!(context, _onUpdate);
    } else {
      contentWidget = widget.createBuilder(context, _onUpdate);
    }
    if (contentWidget == null) {
      contentWidget = Container(
        height: 200.0,
        child: Center(
          child: Text('未配置数据'),
        ),
      );
    }
    return Container(
      padding: EdgeInsets.only(top: widget.themeData!.titleHeight), // 流出头部视图
      child: ListView(
        shrinkWrap: true, // 列表高度自适应
        controller: ScrollController(keepScrollOffset: false), // 若视图小于弹窗则不滑动
        children: <Widget>[contentWidget],
      ),
    );
  }
}
