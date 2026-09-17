import 'package:santo_ui/src/components/line/santo_line.dart';
import 'package:santo_ui/src/constants/santo_asset_constants.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/utils/santo_tools.dart';
import 'package:flutter/material.dart';

const double _kItemSidePadding = 5;

/// 描述: 横向步骤条,是一种常见的导航形式，它具有导航通用的属性：告知用户”我在哪/我能去哪“，
/// 步骤数目就相当于告知用户--能去哪或者说流程将要经历什么。
/// 通用组件步骤条分为三个状态：完成态/进行态/等待态，三种状态在样式上均加以区分
/// 注意事项：横向步骤条内的步骤总数最多只支持5个
class SantoHorizontalSteps extends StatefulWidget {
  /// The steps of the stepper whose titles, subtitles, icons always get shown.
  ///
  /// 步骤条中元素的列表
  final List<SantoStep> steps;

  /// 控制类
  final SantoStepsController? controller;

  /// 自定义正在进行状态的icon
  final Widget? doingIcon;

  /// 自定义已完成状态的icon
  final Widget? completedIcon;

  const SantoHorizontalSteps({
    Key? key,
    required this.steps,
    this.controller,
    this.doingIcon,
    this.completedIcon,
  })  : assert(steps.length < 6),
        super(key: key);

  @override
  State<StatefulWidget> createState() => SantoHorizontalStepsState();
}

class SantoHorizontalStepsState extends State<SantoHorizontalSteps> {
  Color get _primary {
    return SantoThemeConfigurator.instance.getConfig().commonConfig.brandPrimary;
  }

  int get _currentIndex {
    return widget.controller?.currentIndex ?? 0;
  }

  Color _getStepContentTextColor(int index) {
    return index > _currentIndex
        ? const Color(0xFFCCCCCC)
        : const Color(0xFF17233D);
  }

  void _handleStepStateListenerTick() {
    setState(() {});
  }

  void _initController() {
    widget.controller?._setMaxCount(widget.steps.length);
    widget.controller?.addListener(_handleStepStateListenerTick);
  }

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleStepStateListenerTick);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SantoHorizontalSteps oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bool isControllerDiff = oldWidget.controller != null &&
        widget.controller != oldWidget.controller;
    final bool isCountDiff = widget.steps.length != oldWidget.steps.length;
    if (isControllerDiff || isCountDiff) {
      oldWidget.controller?.removeListener(_handleStepStateListenerTick);
      _initController();
    }
  }

  @override
  Widget build(BuildContext context) {
    /// 单独一个widget组件，用于返回需要生成的内容widget
    Widget content;
    final List<Widget> childrenList = <Widget>[];
    final List<SantoStep> steps = widget.steps;
    final int length = steps.length;
    for (int i = 0; i < length; i += 1) {
      childrenList.add(_applyStepItem(steps[i], i));
    }
    content = Container(
      height: 78,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: childrenList,
      ),
    );
    return content;
  }

  Widget _applyStepItem(SantoStep step, int index) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _applyStepAndLine(step, index),
          _applyStepContent(step, index),
        ],
      ),
    );
  }

  Widget _applyStepAndLine(SantoStep step, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        index == 0
            ? Expanded(child: const SizedBox.shrink())
            : _applyLineItem(index, true),
        _applyStepIcon(step, index),
        index == widget.steps.length - 1
            ? Expanded(child: const SizedBox.shrink())
            : _applyLineItem(index, false),
      ],
    );
  }

  Widget _applyStepIcon(SantoStep step, int index) {
    Widget icon;
    if (widget.controller?.isCompleted == true) {
      return _getCompletedIcon(step);
    }
    if (step.state != null) {
      switch (step.state) {
        case SantoStepState.indexed:
          icon = _getIndexIcon(index);
          break;
        case SantoStepState.complete:
          icon = _getCompletedIcon(step);
          break;
        case SantoStepState.doing:
          icon = _getDoingIcon(step);
          break;
        default:
          icon = _getDoingIcon(step);
          break;
      }
    } else {
      if (index < _currentIndex) {
        // 当前index小于指定的活跃index
        icon = _getCompletedIcon(step);
      } else if (index == _currentIndex) {
        icon = _getDoingIcon(step);
      } else {
        icon = _getIndexIcon(index);
      }
    }
    return icon;
  }

  Widget _applyLineItem(int index, bool isLeft) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: SantoLine(
          height: 1,
          leftInset: isLeft ? 0 : _kItemSidePadding,
          rightInset: isLeft ? _kItemSidePadding : 0,
          color: _getLineColor(index, isLeft),
        ),
      ),
    );
  }

  Color _getLineColor(int index, bool isLeft) {
    if (index < _currentIndex) {
      return _primary;
    } else if (_currentIndex == index && isLeft) {
      return _primary;
    }
    return const Color(0xFFE7E7E7);
  }

  Widget _getIndexIcon(int index) {
    Widget icon;
    switch (index) {
      case 1:
        icon = SantoTools.getAssetSizeImage(SantoAsset.iconStep2, 20, 20);
        break;
      case 2:
        icon = SantoTools.getAssetSizeImage(SantoAsset.iconStep3, 20, 20);
        break;
      case 3:
        icon = SantoTools.getAssetSizeImage(SantoAsset.iconStep4, 20, 20);
        break;
      case 4:
        icon = SantoTools.getAssetSizeImage(SantoAsset.iconStep5, 20, 20);
        break;
      default:
        icon = SantoTools.getAssetSizeImage(SantoAsset.iconStepDoing, 20, 20);
        break;
    }
    return icon;
  }

  Widget _applyStepContent(SantoStep step, int index) {
    Widget? stepContent = step.stepContent;
    if (stepContent != null) {
      return stepContent;
    }
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return Container(
      margin: EdgeInsets.only(
          top: commonConfig.vSpacingXs,
          left: _kItemSidePadding,
          right: _kItemSidePadding),
      child: Text(
        step.stepContentText ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: commonConfig.fontSizeBase,
          color: _getStepContentTextColor(index),
        ),
      ),
    );
  }

  Widget _getCompletedIcon(SantoStep step) {
    Widget? completedIcon = step.completedIcon;
    if (completedIcon != null) {
      /// 如果Step中自定义completedIcon不为空，则使用自定义的icon
      return completedIcon;
    }
    completedIcon = widget.completedIcon;
    if (completedIcon != null) {
      /// 如果自定义completedIcon不为空，则使用自定义的icon
      return completedIcon;
    }

    /// 使用组件默认的icon
    return SantoTools.getAssetSizeImage(SantoAsset.iconStepCompleted, 20, 20,
        color: _primary);
  }

  Widget _getDoingIcon(SantoStep step) {
    Widget? doingIcon = step.doingIcon;
    if (doingIcon != null) {
      /// 如果Step中自定义doingIcon不为空，则使用自定义的icon
      return doingIcon;
    }
    doingIcon = widget.doingIcon;
    if (doingIcon != null) {
      /// 如果自定义doingIcon不为空，则使用自定义的icon
      return doingIcon;
    }
    // 使用组件默认的icon
    return SantoTools.getAssetSizeImage(SantoAsset.iconStepDoing, 20, 20,
        color: _primary);
  }
}

enum SantoStepState {
  /// A step that displays its index in its circle.
  indexed,

  /// A step that displays a doing icon in its circle.
  doing,

  /// A step that displays a completed icon in its circle.
  complete
}

class SantoStep {
  /// Creates a step for a [Stepper].
  ///
  /// The [stepContent], [doingIcon] arguments can be null.
  const SantoStep({
    this.stepContent,
    this.doingIcon,
    this.stepContentText,
    this.completedIcon,
    this.state,
  });

  /// The String title of the step that typically describes it.
  final String? stepContentText;

  /// The title of the step that typically describes it.
  final Widget? stepContent;

  /// The doingIcon of the step
  final Widget? doingIcon;

  /// The completedIcon of the step
  final Widget? completedIcon;

  /// The state of the step which determines the styling of its components
  /// and whether steps are interactive.
  final SantoStepState? state;
}

class SantoStepsController with ChangeNotifier {
  /// 指示当前进行态的步骤
  int currentIndex;

  /// 整个流程是否完成
  bool isCompleted;

  /// 最大个数（最多只支持5个）
  int _maxCount = 0;

  SantoStepsController({this.currentIndex = 0, this.isCompleted = false});

  /// 只有在当前包内调用，不开放给外部调用
  void _setMaxCount(int _maxCount) {
    this._maxCount = _maxCount;
  }

  /// 设置当前步骤条的 index,从 0 开始。
  void setCurrentIndex(int currentIndex) {
    if (this.currentIndex == currentIndex || currentIndex > _maxCount) return;
    isCompleted = currentIndex == _maxCount;
    this.currentIndex = currentIndex;
    notifyListeners();
  }

  /// 整个链路完成
  void setCompleted() {
    setCurrentIndex(_maxCount);
  }

  /// 向前一步
  void forwardStep() {
    if (currentIndex < _maxCount) {
      setCurrentIndex(currentIndex + 1);
    }
  }

  /// 向后一步
  void backStep() {
    final int backIndex = currentIndex <= 0 ? 0 : currentIndex - 1;
    setCurrentIndex(backIndex);
  }
}
