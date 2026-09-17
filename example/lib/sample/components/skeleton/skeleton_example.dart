import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/rule_panel.dart';
import 'package:flutter/material.dart';

/// SantoSkeleton 骨架屏示例
class SkeletonExample extends StatefulWidget {
  @override
  State<SkeletonExample> createState() => _SkeletonExampleState();
}

class _SkeletonExampleState extends State<SkeletonExample> {
  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      backgroundColor: Colors.white,
      title: 'Skeleton 骨架屏',
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RulePanel(
            '骨架屏用于内容加载前的占位反馈,支持文本/头像/图片/宫格预设主题,'
            '以及自定义行列结构和渐变扫光/闪烁动画。',
            maxLines: 3,
          ),
          SantoSection(
            title: '预设主题',
            description: 'theme 内置 text、avatar、image 与 grid 四种占位主题',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('text 文本', style: TextStyle(fontSize: 12)),
                const SizedBox(height: 8),
                const SantoSkeleton(theme: SantoSkeletonTheme.text),
                const SizedBox(height: 16),
                const Text('avatar 头像', style: TextStyle(fontSize: 12)),
                const SizedBox(height: 8),
                const SantoSkeleton(theme: SantoSkeletonTheme.avatar),
                const SizedBox(height: 16),
                const Text('image 图片', style: TextStyle(fontSize: 12)),
                const SizedBox(height: 8),
                const SantoSkeleton(theme: SantoSkeletonTheme.image),
                const SizedBox(height: 16),
                const Text('grid 宫格', style: TextStyle(fontSize: 12)),
                const SizedBox(height: 8),
                const SantoSkeleton(theme: SantoSkeletonTheme.grid),
              ],
            ),
          ),
          SantoSection(
            title: '自定义行列结构',
            description: 'fromRowCol 可自由组合行列结构，rowSpacing 控制行距',
            child: const SantoSkeleton.fromRowCol(
              rowCol: SantoSkeletonRowCol(objects: [
                [SantoSkeletonRowColObj.circle(size: 48)],
                [SantoSkeletonRowColObj(), SantoSkeletonRowColObj.spacer()],
                [
                  SantoSkeletonRowColObj.text(flex: 3),
                  SantoSkeletonRowColObj.spacer(),
                ],
              ], rowSpacing: 12),
            ),
          ),
          SantoSection(
            title: '闪烁动画',
            description: 'animation 设为 flashed 时使用闪烁动画替代渐变扫光',
            child: const SantoSkeleton(
              theme: SantoSkeletonTheme.avatar,
              animation: SantoSkeletonAnimation.flashed,
            ),
          ),
          SantoSection(
            title: '无动画',
            description: 'animation 设为 none 时骨架保持静态，可减少性能开销',
            child: const SantoSkeleton(
              theme: SantoSkeletonTheme.avatar,
              animation: SantoSkeletonAnimation.none,
            ),
          ),
          SantoSection(
            title: '延迟显示 (500ms)',
            description: 'delay 设置延迟毫秒数，避免加载过快时的骨架闪烁',
            child: const SantoSkeleton(
              theme: SantoSkeletonTheme.text,
              delay: 500,
            ),
          ),
          SantoSection(
            title: '加载完成切换内容',
            description: '加载完成后用真实内容替换骨架，通过状态切换控制',
            child: Column(
              children: [
                _loading
                    ? const SantoSkeleton(theme: SantoSkeletonTheme.avatar)
                    : Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: const Color(0xFF1677FF),
                            child: const Icon(Icons.person,
                                color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('内容标题',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500)),
                              Text('内容加载完成后的真实内容',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: SantoNormalButton(
                    text: _loading ? '加载完成' : '重新加载',
                    onTap: () {
                      setState(() {
                        _loading = !_loading;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
