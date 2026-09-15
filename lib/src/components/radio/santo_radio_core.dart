import 'package:flutter/material.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 描述: radio组件
/// 1. 支持单选/多选
/// 2. 支持传入待选择widget，可以显示在选择按钮的左边或者右边
/// 3. 传入widget时，widget和选择按钮使用Row包裹，支持传入Row的属性[MainAxisAlignment]和[MainAxisSize]
/// 4. 默认使用矢量绘制的选中指示器（参考 TDesign），传入 selectedImage 等图片时可完全自定义

class SantoRadioCore extends StatefulWidget {
  /// 标识当前Radio的Index
  final int radioIndex;

  /// 初始值，是否被选择
  /// 默认false
  final bool isSelected;

  /// 是否禁用当前选项
  /// 默认false
  final bool disable;

  /// 是否处于半选状态（仅多选生效，参考 TDesign 半选态）
  /// 默认false
  final bool isIndeterminate;

  /// 指示器类型：单选圆点/多选方块
  /// 默认[SantoRadioType.single]
  final SantoRadioType radioType;

  /// 选择按钮的padding
  /// 默认EdgeInsets.all(5)
  final EdgeInsets? iconPadding;

  /// 配合使用的控件，比如卡片或者text
  final Widget? child;

  /// 控件是否在选择按钮的右边，
  /// true时 控件在选择按钮右边
  /// false时 控件在选择按钮的左边
  /// 默认true
  final bool childOnRight;

  /// 控件和选择按钮在row布局里面的alignment
  /// 默认值MainAxisAlignment.start
  final MainAxisAlignment mainAxisAlignment;

  /// 控件和选择按钮在row布局里面的crossAxisAlignment
  /// 默认值CrossAxisAlignment.center
  final CrossAxisAlignment crossAxisAlignment;

  /// 控件和选择按钮在row布局里面的mainAxisSize
  /// 默认值MainAxisSize.min
  final MainAxisSize mainAxisSize;

  /// 自定义选中时的图片，传入后优先于矢量指示器
  final Image? selectedImage;

  /// 自定义未选中时的图片
  final Image? unselectedImage;

  /// 自定义禁用且选中时的图片
  final Image? disSelectedImage;

  /// 自定义禁用且未选中时的图片
  final Image? disUnselectedImage;

  final VoidCallback? onRadioItemClick;

  /// 默认值HitTestBehavior.translucent控制widget.onRadioItemClick触发的点击范围
  final HitTestBehavior behavior;

  const SantoRadioCore(
      {Key? key,
      required this.radioIndex,
      this.disable = false,
      this.isSelected = false,
      this.isIndeterminate = false,
      this.radioType = SantoRadioType.single,
      this.iconPadding,
      this.child,
      this.childOnRight = true,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.crossAxisAlignment = CrossAxisAlignment.center,
      this.mainAxisSize = MainAxisSize.min,
      this.selectedImage,
      this.unselectedImage,
      this.disSelectedImage,
      this.disUnselectedImage,
      this.onRadioItemClick,
      this.behavior = HitTestBehavior.translucent})
      : super(key: key);

  @override
  _SantoRadioCoreState createState() => _SantoRadioCoreState();
}

class _SantoRadioCoreState extends State<SantoRadioCore> {
  late bool _isSelected;
  late bool _disable;

  /// 指示器尺寸（参考 TDesign 24px 视觉，含点击热区由外层 padding 提供）
  static const double _indicatorSize = 20.0;
  static const Duration _animationDuration = Duration(milliseconds: 150);

  @override
  void initState() {
    _isSelected = widget.isSelected;
    _disable = widget.disable;
    super.initState();
  }

  @override
  void didUpdateWidget(SantoRadioCore oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isSelected = widget.isSelected;
    _disable = widget.disable;
  }

  /// 是否使用自定义图片
  bool get _useCustomImages =>
      widget.selectedImage != null ||
      widget.unselectedImage != null ||
      widget.disSelectedImage != null ||
      widget.disUnselectedImage != null;

  @override
  Widget build(BuildContext context) {
    Widget icon = Container(
      padding: widget.iconPadding ?? const EdgeInsets.all(5),
      child: _useCustomImages ? _buildImageIndicator() : _buildVectorIndicator(),
    );

    Widget radioWidget;
    if (widget.child == null) {
      // 没设置左右widget的时候就不返回row
      radioWidget = icon;
    } else {
      List<Widget> list = [];
      if (widget.childOnRight) {
        list.add(icon);
        list.add(widget.child!);
      } else {
        list.add(widget.child!);
        list.add(icon);
      }
      radioWidget = Row(
        mainAxisSize: widget.mainAxisSize,
        mainAxisAlignment: widget.mainAxisAlignment,
        crossAxisAlignment: widget.crossAxisAlignment,
        children: list,
      );
    }

    return Semantics(
      enabled: !_disable,
      checked: _isSelected,
      child: GestureDetector(
        child: radioWidget,
        behavior: widget.behavior,
        onTap: () {
          if (widget.disable == true) return;
          if (widget.onRadioItemClick != null) {
            widget.onRadioItemClick!();
          }
        },
      ),
    );
  }

  /// 兼容旧版：使用自定义图片渲染
  Widget _buildImageIndicator() {
    if (_isSelected) {
      return _disable
          ? (widget.disSelectedImage ?? widget.selectedImage!)
          : widget.selectedImage!;
    }
    return _disable
        ? (widget.disUnselectedImage ?? widget.unselectedImage!)
        : widget.unselectedImage!;
  }

  /// 矢量绘制指示器（参考 TDesign）：
  /// 选中态填充品牌色 + 白色内容（单选为圆点，多选为对勾，半选为横线）
  /// 未选中态为描边空心
  /// 禁用态整体置灰
  Widget _buildVectorIndicator() {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final bool isRadio = widget.radioType == SantoRadioType.single;
    final bool checked = _isSelected || (widget.isIndeterminate && !isRadio);

    final Color activeColor =
        _disable ? const Color(0xFFBBBBBB) : commonConfig.brandPrimary;
    final Color fillColor = checked ? activeColor : Colors.transparent;
    final Color borderColor = checked
        ? activeColor
        : (_disable ? const Color(0xFFDCDCDC) : const Color(0xFFC9CDD4));

    Widget? content;
    if (checked) {
      if (isRadio) {
        content = AnimatedScale(
          duration: _animationDuration,
          curve: Curves.easeOutBack,
          scale: _isSelected ? 1.0 : 0.0,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        );
      } else if (widget.isIndeterminate && !_isSelected) {
        content = const Icon(Icons.remove, size: 14, color: Colors.white);
      } else {
        content = const Icon(Icons.check, size: 14, color: Colors.white);
      }
    }

    return AnimatedContainer(
      duration: _animationDuration,
      curve: Curves.easeOut,
      width: _indicatorSize,
      height: _indicatorSize,
      decoration: BoxDecoration(
        color: fillColor,
        shape: isRadio ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isRadio ? null : BorderRadius.circular(4),
        border: Border.all(color: borderColor, width: 2),
      ),
      alignment: Alignment.center,
      child: content,
    );
  }
}

/// radio类型
enum SantoRadioType {
  /// 多选
  multi,

  /// 单选
  single,
}
