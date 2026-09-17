import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// TimeCounter 计时器示例页面
class TimeCounterExample extends StatefulWidget {
  @override
  _TimeCounterExampleState createState() => _TimeCounterExampleState();
}

class _TimeCounterExampleState extends State<TimeCounterExample> {
  /// 倒计时控制器
  final SantoTimeCounterController _countdownController =
      SantoTimeCounterController();

  /// 正计时控制器
  final SantoTimeCounterController _stopwatchController =
      SantoTimeCounterController();

  /// 倒计时是否完成
  bool _countdownComplete = false;

  @override
  void dispose() {
    _countdownController.detach();
    _stopwatchController.detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(      title: 'TimeCounter 计时器示例',
      children: <Widget>[
        // 基础倒计时
        SantoSection(
          title: '基础倒计时',
          description: 'countdown 模式倒计时 5 分钟，控制器支持暂停、继续与重置',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('默认倒计时模式，5分钟倒计时',
                  style: TextStyle(fontSize: 13, color: Colors.grey)),
              SizedBox(height: 16),
              Center(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SantoTimeCounter(
                    mode: SantoTimeCounterMode.countdown,
                    duration: Duration(minutes: 5),
                    controller: _countdownController,
                    onComplete: () {
                      setState(() {
                        _countdownComplete = true;
                      });
                    },
                  ),
                ),
              ),
              if (_countdownComplete)
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      '倒计时结束！',
                      style:
                          TextStyle(color: Color(0xFFFF4D4F), fontSize: 14),
                    ),
                  ),
                ),
              SizedBox(height: 12),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildControlButton('暂停', () {
                      _countdownController.pause();
                    }),
                    SizedBox(width: 12),
                    _buildControlButton('继续', () {
                      _countdownController.resume();
                    }),
                    SizedBox(width: 12),
                    _buildControlButton('重置', () {
                      setState(() {
                        _countdownComplete = false;
                      });
                      _countdownController.reset();
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 正计时
        SantoSection(
          title: '正计时',
          description: 'stopwatch 模式正计时，format 指定 HH:mm:ss 输出格式',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('秒表模式，格式 HH:mm:ss',
                  style: TextStyle(fontSize: 13, color: Colors.grey)),
              SizedBox(height: 16),
              Center(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SantoTimeCounter(
                    mode: SantoTimeCounterMode.stopwatch,
                    format: 'HH:mm:ss',
                    controller: _stopwatchController,
                  ),
                ),
              ),
              SizedBox(height: 12),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildControlButton('开始/继续', () {
                      _stopwatchController.resume();
                    }),
                    SizedBox(width: 12),
                    _buildControlButton('暂停', () {
                      _stopwatchController.pause();
                    }),
                    SizedBox(width: 12),
                    _buildControlButton('重置', () {
                      _stopwatchController.reset();
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 自定义格式
        SantoSection(
          title: '自定义格式',
          description: 'format 支持 mm:ss、HH:mm:ss 与 mm:ss:SS 等格式',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('支持 HH:mm:ss、mm:ss、mm:ss:SS 等格式',
                  style: TextStyle(fontSize: 13, color: Colors.grey)),
              SizedBox(height: 16),
              _buildFormatItem('mm:ss 格式', 'mm:ss', Duration(seconds: 90)),
              SizedBox(height: 8),
              _buildFormatItem(
                  'HH:mm:ss 格式', 'HH:mm:ss', Duration(hours: 2)),
              SizedBox(height: 8),
              _buildFormatItem('mm:ss:SS 格式（含毫秒）', 'mm:ss:SS',
                  Duration(seconds: 30)),
            ],
          ),
        ),

        // 自定义样式
        SantoSection(
          title: '自定义样式',
          description: 'textStyle 可自定义字号与颜色，演示中关闭了 autoStart',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('通过 textStyle 自定义文字样式',
                  style: TextStyle(fontSize: 13, color: Colors.grey)),
              SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    SantoTimeCounter(
                      mode: SantoTimeCounterMode.countdown,
                      duration: Duration(seconds: 30),
                      autoStart: false,
                      textStyle: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1677FF),
                      ),
                    ),
                    SizedBox(height: 16),
                    SantoTimeCounter(
                      mode: SantoTimeCounterMode.countdown,
                      duration: Duration(seconds: 30),
                      autoStart: false,
                      textStyle: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF52C41A),
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 自定义构建器
        SantoSection(
          title: '自定义构建器',
          description: 'builder 接收剩余时长，可完全自定义显示结构',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('通过 builder 完全自定义显示样式',
                  style: TextStyle(fontSize: 13, color: Colors.grey)),
              SizedBox(height: 16),
              Center(
                child: SantoTimeCounter(
                  mode: SantoTimeCounterMode.countdown,
                  duration: Duration(seconds: 60),
                  autoStart: false,
                  builder: (time) {
                    final minutes = (time.inMinutes % 60)
                        .toString()
                        .padLeft(2, '0');
                    final seconds = (time.inSeconds % 60)
                        .toString()
                        .padLeft(2, '0');
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildTimeBlock(minutes),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            ':',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                        ),
                        _buildTimeBlock(seconds),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 48),
      ],
    );
  }

  /// 构建控制按钮
  Widget _buildControlButton(String text, VoidCallback onTap) {
    return SantoNormalButton(
      onTap: onTap,
      text: text,
    );
  }

  /// 构建格式示例项
  Widget _buildFormatItem(String label, String format, Duration duration) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SantoTimeCounter(
            mode: SantoTimeCounterMode.countdown,
            duration: duration,
            format: format,
            autoStart: false,
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1677FF),
            ),
          ),
        ),
      ],
    );
  }

  /// 构建时间块
  Widget _buildTimeBlock(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFF1677FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
