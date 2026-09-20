import 'dart:async';

import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

/// 加载示例,分组与 antd Spin 文档保持一致
///
/// SantoLoading 是库内唯一的加载入口:独立指示器、包裹内容、全屏遮罩
/// 以及 show/dismiss 浮层都由它一个类承担。
class LoadingExample extends StatefulWidget {
  @override
  State<LoadingExample> createState() => _LoadingExampleState();
}

class _LoadingExampleState extends State<LoadingExample> {
  /// 延迟示例的加载态
  bool _delayLoading = false;

  /// 包裹模式的加载态
  bool _nestedLoading = true;

  /// 进度示例的百分比
  double _percent = 0;

  Timer? _percentTimer;

  @override
  void dispose() {
    _percentTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: 'Loading 加载中',
      children: <Widget>[
        ExampleIntro('loading'),
        _buildBasicSection(),
        _buildSizeSection(),
        _buildTipSection(),
        _buildIndicatorSection(),
        _buildDelaySection(),
        _buildNestedSection(),
        _buildPercentSection(),
        _buildFullscreenSection(),
        _buildOverlaySection(),
      ],
    );
  }

  /// 基础用法
  Widget _buildBasicSection() {
    return SantoSection(
      title: '基础用法',
      description: '不传参数时是默认尺寸的主题色圆环,占满可用空间并居中展示',
      child: SizedBox(height: 120, child: const SantoLoading()),
    );
  }

  /// 尺寸
  Widget _buildSizeSection() {
    return SantoSection(
      title: '尺寸',
      description: 'size 分 small(14)、medium(默认 20)、large(32) 三档:'
          'small 用于文字旁,medium 用于卡片级区块,large 用于整页',
      child: Row(
        children: <Widget>[
          Expanded(
            child: SizedBox(
              height: 80,
              child: const SantoLoading(size: SantoLoadingSize.small),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 80,
              child: const SantoLoading(),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 80,
              child: const SantoLoading(size: SantoLoadingSize.large),
            ),
          ),
        ],
      ),
    );
  }

  /// 自定义文案
  Widget _buildTipSection() {
    return SantoSection(
      title: '自定义文案',
      description: 'tip 展示在指示器下方,超长文案自动换行,不传时只有指示器',
      child: Column(
        children: <Widget>[
          // 不锁死高度:文案换行或系统字号放大时高度自适应,避免溢出
          SantoLoading(tip: '加载中...'),
          const SizedBox(height: 12),
          SantoLoading(
            tip: '正在上传附件,请保持网络畅通,完成后会自动刷新列表',
          ),
        ],
      ),
    );
  }

  /// 自定义指示器与颜色
  Widget _buildIndicatorSection() {
    return SantoSection(
      title: '自定义指示器',
      description: 'indicator 替换默认圆环;color 只改颜色时用 color 即可',
      child: Row(
        children: <Widget>[
          Expanded(
            child: SizedBox(
              height: 80,
              child: SantoLoading(
                indicator: const Icon(Icons.cloud_download, size: 28),
                tip: '自定义图标',
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 80,
              child: SantoLoading(
                color: const Color(0xFF52C41A),
                tip: '自定义颜色',
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 延迟展示
  Widget _buildDelaySection() {
    return SantoSection(
      title: '延迟展示',
      description: 'delay 设置延迟时长,延迟期间加载态结束则不展示,避免一闪而过的加载动画',
      child: Row(
        children: <Widget>[
          Switch(
            value: _delayLoading,
            onChanged: (bool value) {
              setState(() => _delayLoading = value);
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 80,
              child: SantoLoading(
                spinning: _delayLoading,
                delay: const Duration(milliseconds: 800),
                tip: '延迟 800ms',
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 包裹模式
  Widget _buildNestedSection() {
    return SantoSection(
      title: '包裹模式',
      description: '传入 child 后内容被包裹,加载时盖一层半透明蒙层并居中展示指示器',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Switch(
            value: _nestedLoading,
            onChanged: (bool value) {
              setState(() => _nestedLoading = value);
            },
          ),
          const SizedBox(height: 12),
          SantoLoading(
            spinning: _nestedLoading,
            tip: '加载中',
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('被包裹的内容区块'),
                  SizedBox(height: 8),
                  Text('加载过程中蒙层会遮住这块内容,避免用户误操作'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 进度
  Widget _buildPercentSection() {
    return SantoSection(
      title: '进度',
      description: 'percent 传 0~100 时圆环展示确定进度,并在下方展示百分比;不传为不确定进度',
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 120,
            height: 120,
            child: SantoLoading(
              size: SantoLoadingSize.large,
              percent: _percent,
            ),
          ),
          const SizedBox(width: 12),
          SantoButton(
            text: _percentTimer == null ? '开始' : '重置',
            type: SantoButtonType.primary,
            onTap: _togglePercent,
          ),
        ],
      ),
    );
  }

  /// 全屏
  Widget _buildFullscreenSection() {
    return SantoSection(
      title: '全屏',
      description: 'fullscreen 铺满父布局并居中展示指示器;'
          '浮层形式用 SantoLoading.show(context, fullscreen: true)',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 140,
            child: SantoLoading(
              fullscreen: true,
              tip: '铺满父布局',
            ),
          ),
          const SizedBox(height: 12),
          SantoButton(
            text: '全屏浮层',
            type: SantoButtonType.normal,
            onTap: () => _showOverlay(fullscreen: true, tip: '全屏加载中'),
          ),
        ],
      ),
    );
  }

  /// 浮层
  Widget _buildOverlaySection() {
    return SantoSection(
      title: '浮层',
      description: 'SantoLoading.show 展示黑胶囊浮层,由 SantoLoading.dismiss 关闭,不会自动关闭',
      child: SantoButton(
        text: '打开加载浮层',
        type: SantoButtonType.primary,
        onTap: () => _showOverlay(tip: '提交中'),
      ),
    );
  }

  void _togglePercent() {
    if (_percentTimer != null) {
      _percentTimer?.cancel();
      setState(() {
        _percentTimer = null;
        _percent = 0;
      });
      return;
    }
    setState(() => _percent = 0);
    _percentTimer = Timer.periodic(const Duration(milliseconds: 120), (Timer t) {
      if (!mounted) return;
      setState(() {
        _percent += 10;
        if (_percent >= 100) {
          _percent = 0;
          t.cancel();
          _percentTimer = null;
        }
      });
    });
  }

  /// 展示浮层并在 2 秒后关闭,便于示例演示
  void _showOverlay({String? tip, bool fullscreen = false}) {
    SantoLoading.show(context, tip: tip, fullscreen: fullscreen);
    Future.delayed(const Duration(seconds: 2)).then((_) {
      if (!mounted) return;
      SantoLoading.dismiss(context, '示例定时关闭');
    });
  }
}
