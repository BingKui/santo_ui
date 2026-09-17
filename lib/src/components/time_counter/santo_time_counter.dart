import 'dart:async';

import 'package:flutter/material.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 计时器模式枚举
enum SantoTimeCounterMode {
  /// 倒计时
  countdown,

  /// 正计时
  stopwatch,
}

/// 计时器控制器
///
/// 用于控制计时器的暂停、继续、重置等操作。
///
/// 使用示例：
/// ```dart
/// final controller = SantoTimeCounterController();
///
/// // 暂停
/// controller.pause();
///
/// // 继续
/// controller.resume();
///
/// // 重置
/// controller.reset();
/// ```
class SantoTimeCounterController {
  /// 暂停回调
  VoidCallback? _onPause;

  /// 继续回调
  VoidCallback? _onResume;

  /// 重置回调
  VoidCallback? _onReset;

  /// 绑定控制器到计时器组件
  void attach({
    VoidCallback? onPause,
    VoidCallback? onResume,
    VoidCallback? onReset,
  }) {
    _onPause = onPause;
    _onResume = onResume;
    _onReset = onReset;
  }

  /// 解除绑定
  void detach() {
    _onPause = null;
    _onResume = null;
    _onReset = null;
  }

  /// 暂停计时器
  void pause() {
    _onPause?.call();
  }

  /// 继续计时器
  void resume() {
    _onResume?.call();
  }

  /// 重置计时器
  void reset() {
    _onReset?.call();
  }
}

/// TimeCounter 计时器组件
///
/// 支持倒计时和正计时两种模式。
/// 支持自定义格式（HH:mm:ss）、暂停/继续/重置。
/// 支持自定义样式和控制器。
///
/// 使用示例：
/// ```dart
/// // 倒计时
/// SantoTimeCounter(
///   mode: SantoTimeCounterMode.countdown,
///   duration: Duration(minutes: 5),
///   format: 'mm:ss',
///   onComplete: () {
///     print('倒计时结束');
///   },
/// )
///
/// // 正计时 + 控制器
/// final controller = SantoTimeCounterController();
/// SantoTimeCounter(
///   mode: SantoTimeCounterMode.stopwatch,
///   controller: controller,
///   format: 'HH:mm:ss',
/// )
/// ```
class SantoTimeCounter extends StatefulWidget {
  /// 计时器模式，默认倒计时
  final SantoTimeCounterMode mode;

  /// 倒计时时长（仅倒计时模式有效）
  final Duration duration;

  /// 是否自动开始，默认true
  final bool autoStart;

  /// 每次计时回调，参数为当前剩余/已用时间
  final void Function(Duration remaining)? onTick;

  /// 倒计时完成回调
  final VoidCallback? onComplete;

  /// 文字样式
  final TextStyle? textStyle;

  /// 时间格式，支持 HH、mm、ss、SS（毫秒，两位）
  /// 默认 'mm:ss'
  final String format;

  /// 控制器
  final SantoTimeCounterController? controller;

  /// 自定义构建器，可自定义显示样式
  /// 参数为当前剩余/已用时间
  final Widget Function(Duration time)? builder;

  /// 创建计时器组件
  const SantoTimeCounter({
    Key? key,
    this.mode = SantoTimeCounterMode.countdown,
    this.duration = const Duration(seconds: 60),
    this.autoStart = true,
    this.onTick,
    this.onComplete,
    this.textStyle,
    this.format = 'mm:ss',
    this.controller,
    this.builder,
  }) : super(key: key);

  @override
  State<SantoTimeCounter> createState() => _SantoTimeCounterState();
}

class _SantoTimeCounterState extends State<SantoTimeCounter> {
  /// 计时器
  Timer? _timer;

  /// 当前剩余/已用时间
  late Duration _currentTime;

  /// 是否正在运行
  bool _isRunning = false;

  /// 上次 tick 时间戳
  DateTime? _lastTickTime;

  @override
  void initState() {
    super.initState();
    _initTime();
    _bindController();
    if (widget.autoStart) {
      _start();
    }
  }

  @override
  void didUpdateWidget(SantoTimeCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _unbindController();
      _bindController();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _unbindController();
    super.dispose();
  }

  /// 初始化时间
  void _initTime() {
    if (widget.mode == SantoTimeCounterMode.countdown) {
      _currentTime = widget.duration;
    } else {
      _currentTime = Duration.zero;
    }
  }

  /// 绑定控制器
  void _bindController() {
    widget.controller?.attach(
      onPause: pause,
      onResume: resume,
      onReset: reset,
    );
  }

  /// 解除控制器绑定
  void _unbindController() {
    widget.controller?.detach();
  }

  /// 开始计时
  void _start() {
    if (_isRunning) return;
    _isRunning = true;
    _lastTickTime = DateTime.now();

    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!_isRunning) return;

      final now = DateTime.now();
      final elapsed = now.difference(_lastTickTime!);
      _lastTickTime = now;

      if (widget.mode == SantoTimeCounterMode.countdown) {
        _currentTime -= elapsed;
        if (_currentTime.inMilliseconds <= 0) {
          _currentTime = Duration.zero;
          _isRunning = false;
          _timer?.cancel();
          widget.onTick?.call(_currentTime);
          widget.onComplete?.call();
          if (mounted) setState(() {});
          return;
        }
      } else {
        _currentTime += elapsed;
      }

      widget.onTick?.call(_currentTime);
      if (mounted) setState(() {});
    });
  }

  /// 暂停计时
  void pause() {
    if (!_isRunning) return;
    _isRunning = false;
    _timer?.cancel();
    if (mounted) setState(() {});
  }

  /// 继续计时
  void resume() {
    if (_isRunning) return;
    _start();
    if (mounted) setState(() {});
  }

  /// 重置计时器
  void reset() {
    _timer?.cancel();
    _isRunning = false;
    _initTime();
    if (mounted) setState(() {});
    if (widget.autoStart) {
      _start();
    }
  }

  /// 格式化时间显示
  String _formatTime(Duration time) {
    String result = widget.format;

    final hours = time.inHours;
    final minutes = time.inMinutes % 60;
    final seconds = time.inSeconds % 60;
    final milliseconds = (time.inMilliseconds % 1000) ~/ 10;

    result = result.replaceAll('HH', hours.toString().padLeft(2, '0'));
    result = result.replaceAll('mm', minutes.toString().padLeft(2, '0'));
    result = result.replaceAll('ss', seconds.toString().padLeft(2, '0'));
    result = result.replaceAll('SS', milliseconds.toString().padLeft(2, '0'));

    return result;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      return widget.builder!(_currentTime);
    }

    final defaultStyle = widget.textStyle ??
        TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: SantoThemeConfigurator.instance
              .getConfig()
              .commonConfig
              .colorTextBase,
        );

    return Text(
      _formatTime(_currentTime),
      style: defaultStyle,
    );
  }
}
