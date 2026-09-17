import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// BackTop 返回顶部示例
class BacktopExample extends StatefulWidget {
  @override
  _BacktopExampleState createState() => _BacktopExampleState();
}

class _BacktopExampleState extends State<BacktopExample> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: 'BackTop 示例',
      // 回顶按钮要驱动页面滚动
      scrollController: _scrollController,
      children: <Widget>[
        for (int index = 0; index < 50; index++)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFF1677FF).withAlpha(0x14),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Color(0xFF1677FF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '这是第 ${index + 1} 条数据',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
      ],
      // 默认样式的返回顶部按钮:叠在内容之上
      overlay: SantoBackTop(
          scrollController: _scrollController,
          visibilityThreshold: 400,
    ),
    );
  }
}
