import 'package:santo_ui/src/components/chat/model/santo_chat_message.dart';
import 'package:santo_ui/src/components/icon/santo_icon.dart';
import 'package:santo_ui/src/components/icon/santo_icons.dart';
import 'package:santo_ui/src/theme/configs/santo_chat_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 语音消息默认展示宽度
const double kSantoChatVoiceWidth = 140;

/// 未提供波形时的内置波形
const List<double> kSantoChatDefaultWaveform = <double>[
  0.35, 0.7, 0.45, 0.9, 0.6, 0.3, 0.75, 0.5, 0.85,
  0.4, 0.65, 0.95, 0.55, 0.35, 0.8, 0.5, 0.7, 0.4,
];

/// 会话语音消息内容:播放按钮 + 波形 + 时长
///
/// 组件不负责播放,点击后回调 [onTap],由业务方控制播放并把 [isPlaying] 传回来。
///
/// @since v1.5.0
class SantoChatVoice extends StatelessWidget {
  /// 语音消息
  final SantoChatVoiceMessage message;

  /// 是否位于我方气泡内,决定取色
  final bool isMine;

  /// 是否正在播放,播放中把播放图标换成暂停图标
  final bool isPlaying;

  /// 点击回调
  final ValueChanged<SantoChatVoiceMessage>? onTap;

  const SantoChatVoice({
    Key? key,
    required this.message,
    this.isMine = false,
    this.isPlaying = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SantoChatConfig config =
        SantoThemeConfigurator.instance.getConfig().chatConfig;
    final Color contentColor = isMine
        ? config.myTextStyle.color ?? config.commonConfig.colorTextBaseInverse
        : config.otherTextStyle.color ?? config.commonConfig.colorTextBase;
    final List<double> waveform =
        message.waveform ?? kSantoChatDefaultWaveform;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap == null ? null : () => onTap!(message),
      child: SizedBox(
        width: kSantoChatVoiceWidth,
        child: Row(
          children: <Widget>[
            SantoIcon(
              isPlaying ? SantoIcons.pause : SantoIcons.soundHigh,
              size: config.commonConfig.iconSizeMd,
              color: contentColor,
            ),
            SizedBox(width: config.commonConfig.hSpacingSm),
            Expanded(
              child: SizedBox(
                height: config.commonConfig.iconSizeMd,
                child: CustomPaint(
                  painter: _WaveformPainter(
                    values: waveform,
                    color: contentColor.withOpacity(isPlaying ? 0.95 : 0.55),
                  ),
                ),
              ),
            ),
            SizedBox(width: config.commonConfig.hSpacingSm),
            Text(
              _formatVoiceDuration(message.duration),
              style: config.otherTextStyle
                  .generateTextStyle()
                  .copyWith(color: contentColor),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatVoiceDuration(Duration duration) {
  final int seconds = duration.inSeconds;
  if (seconds >= 60) {
    final String mm = (seconds ~/ 60).toString();
    final String ss = (seconds % 60).toString().padLeft(2, '0');
    return '$mm\'$ss"';
  }
  return '$seconds"';
}

/// 语音波形:按比例值绘制竖条,整体垂直居中
class _WaveformPainter extends CustomPainter {
  final List<double> values;
  final Color color;

  const _WaveformPainter({required this.values, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty || size.width <= 0 || size.height <= 0) return;
    final double totalGap = size.width * 0.4;
    final double barWidth =
        (size.width - totalGap) / values.length;
    final double gap = values.length > 1 ? totalGap / (values.length - 1) : 0;
    final Paint paint = Paint()..color = color;
    for (int i = 0; i < values.length; i++) {
      final double height = values[i].clamp(0.12, 1.0) * size.height;
      final double left = i * (barWidth + gap);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, (size.height - height) / 2, barWidth, height),
          Radius.circular(barWidth / 2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_WaveformPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.values != values;
}
