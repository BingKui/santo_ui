import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// SantoPanel 面板示例
class PanelExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(title: 'Panel 面板'),
      body: ListView(
        children: [
          SantoPanel(
            title: '基础面板',
            child: Text('这是一个基础面板,内容自适应高度,圆角 12px。'),
          ),
          SantoPanel(
            title: '带描述面板',
            description: '这是标题下方的描述信息,字号更小,颜色为灰色',
            child: Text('Header 标题下方展示描述信息。'),
          ),
          SantoPanel(
            title: '带操作面板',
            actions: [
              SantoSmallOutlineButton(
                title: '取消',
                onTap: () => SantoToast.show('点击了取消', context),
              ),
              SizedBox(width: 12),
              SantoSmallMainButton(
                title: '确定',
                onTap: () => SantoToast.show('点击了确定', context),
              ),
            ],
            child: Text('Header 左侧为标题,右侧为操作按钮区,按钮使用小号尺寸。'),
          ),
          SantoPanel(
            title: '可滚动面板',
            actions: [
              Text(' maxHeight: 120', style: TextStyle(color: Colors.grey)),
            ],
            maxHeight: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                20,
                (i) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text('滚动内容条目 ${i + 1}'),
                ),
              ),
            ),
          ),
          SantoPanel(
            title: '标题后置控件',
            titleExtra: SantoSegmented<String>(
              options: const [
                SantoSegmentedOption(value: 'day', label: '日'),
                SantoSegmentedOption(value: 'week', label: '周'),
                SantoSegmentedOption(value: 'month', label: '月'),
              ],
              defaultValue: 'day',
              shape: SantoSegmentedShape.round,
              size: SantoSegmentedSize.small,
              onChange: (value) => SantoToast.show('切换到 $value', context),
            ),
            child: Text('titleExtra 可放 Segmented 等其他控件,位于标题与右侧操作区之间。'),
          ),
          SantoPanel(
            title: '标题后置控件 + 操作区',
            titleExtra: SantoSegmented<String>(
              options: const [
                SantoSegmentedOption(value: 'on', label: '启用'),
                SantoSegmentedOption(value: 'off', label: '停用'),
              ],
              defaultValue: 'on',
              shape: SantoSegmentedShape.round,
              size: SantoSegmentedSize.small,
            ),
            actions: [
              SantoSmallMainButton(
                title: '确定',
                onTap: () => SantoToast.show('点击了确定', context),
              ),
            ],
            child: Text('标题空间不足时由标题收缩让位,后置控件与操作区保持完整展示。'),
          ),
          SantoPanel(
            title: '无内容边距面板',
            contentPadding: false,
            child: Container(
              color: Color(0xFFF5F6FA),
              width: double.infinity,
              padding: EdgeInsets.all(16),
              child: Text('contentPadding: false,内容紧贴面板边缘,可自行控制留白。'),
            ),
          ),
        ],
      ),
    );
  }
}
