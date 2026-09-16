import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// 树形控件示例
class TreeExample extends StatefulWidget {
  @override
  _TreeExampleState createState() => _TreeExampleState();
}

class _TreeExampleState extends State<TreeExample> {
  /// 单选树数据
  late List<SantoTreeNode> _singleSelectData;

  /// 多选树数据
  late List<SantoTreeNode> _multiSelectData;

  /// 默认展开树数据
  late List<SantoTreeNode> _expandedData;

  /// 多选选中值
  List<String> _multiSelectedValues = [];

  /// 当前操作信息
  String _lastAction = '无';

  @override
  void initState() {
    super.initState();

    _singleSelectData = [
      SantoTreeNode(
        label: '中国',
        value: 'china',
        icon: Icons.flag,
        children: [
          SantoTreeNode(
            label: '广东省',
            value: 'guangdong',
            children: [
              SantoTreeNode(label: '广州市', value: 'guangzhou'),
              SantoTreeNode(label: '深圳市', value: 'shenzhen'),
              SantoTreeNode(label: '东莞市', value: 'dongguan'),
            ],
          ),
          SantoTreeNode(
            label: '浙江省',
            value: 'zhejiang',
            children: [
              SantoTreeNode(label: '杭州市', value: 'hangzhou'),
              SantoTreeNode(label: '宁波市', value: 'ningbo'),
              SantoTreeNode(label: '温州市', value: 'wenzhou'),
            ],
          ),
          SantoTreeNode(
            label: '北京市',
            value: 'beijing',
          ),
          SantoTreeNode(
            label: '上海市',
            value: 'shanghai',
          ),
        ],
      ),
    ];

    _multiSelectData = [
      SantoTreeNode(
        label: '技术栈',
        value: 'tech',
        expanded: true,
        children: [
          SantoTreeNode(
            label: '前端',
            value: 'frontend',
            children: [
              SantoTreeNode(label: 'Flutter', value: 'flutter'),
              SantoTreeNode(label: 'React', value: 'react'),
              SantoTreeNode(label: 'Vue', value: 'vue'),
              SantoTreeNode(label: 'Angular', value: 'angular'),
            ],
          ),
          SantoTreeNode(
            label: '后端',
            value: 'backend',
            children: [
              SantoTreeNode(label: 'Dart', value: 'dart'),
              SantoTreeNode(label: 'Java', value: 'java'),
              SantoTreeNode(label: 'Python', value: 'python'),
              SantoTreeNode(label: 'Go', value: 'go'),
            ],
          ),
          SantoTreeNode(
            label: '数据库',
            value: 'database',
            children: [
              SantoTreeNode(label: 'MySQL', value: 'mysql'),
              SantoTreeNode(label: 'PostgreSQL', value: 'postgresql'),
              SantoTreeNode(label: 'MongoDB', value: 'mongodb'),
            ],
          ),
        ],
      ),
    ];

    _expandedData = [
      SantoTreeNode(
        label: '公司架构',
        value: 'company',
        expanded: true,
        children: [
          SantoTreeNode(
            label: '技术部',
            value: 'tech_dept',
            expanded: true,
            children: [
              SantoTreeNode(label: 'iOS 组', value: 'ios_team'),
              SantoTreeNode(label: 'Android 组', value: 'android_team'),
              SantoTreeNode(label: '后端组', value: 'backend_team'),
            ],
          ),
          SantoTreeNode(
            label: '产品部',
            value: 'product_dept',
            expanded: true,
            children: [
              SantoTreeNode(label: '产品设计', value: 'design'),
              SantoTreeNode(label: '用户研究', value: 'research'),
            ],
          ),
          SantoTreeNode(
            label: '市场部',
            value: 'marketing_dept',
            children: [
              SantoTreeNode(label: '品牌推广', value: 'brand'),
              SantoTreeNode(label: '渠道运营', value: 'channel'),
            ],
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(title: 'Tree 树形控件示例'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 场景1：基础单选树
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '基础单选树',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '最近操作: $_lastAction',
                style: TextStyle(fontSize: 13, color: Color(0xFF808695)),
              ),
            ),
            SantoTree(
              data: _singleSelectData,
              onNodeTap: (node) {
                setState(() {
                  _lastAction = '点击了: ${node.label}';
                });
              },
              onNodeExpand: (node, expanded) {
                setState(() {
                  _lastAction = '${expanded ? "展开" : "收起"}了: ${node.label}';
                });
              },
            ),

            Divider(height: 24),

            // 场景2：多选树
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '多选树',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '已选择: ${_multiSelectedValues.isEmpty ? "无" : _multiSelectedValues.join(", ")}',
                style: TextStyle(fontSize: 13, color: Color(0xFF808695)),
              ),
            ),
            SantoTree(
              data: _multiSelectData,
              multiple: true,
              selectedValues: _multiSelectedValues,
              onSelectionChanged: (values) {
                setState(() {
                  _multiSelectedValues = values;
                });
              },
              onNodeExpand: (node, expanded) {
                setState(() {});
              },
            ),

            Divider(height: 24),

            // 场景3：默认展开的树
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '默认展开的树',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            SantoTree(
              data: _expandedData,
              onNodeTap: (node) {
                SantoToast.show('点击了: ${node.label}', context);
              },
              onNodeExpand: (node, expanded) {
                setState(() {});
              },
            ),

            Divider(height: 24),

            // 场景4：自定义主题色
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '自定义主题色（绿色）',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            SantoTree(
              data: _multiSelectData,
              multiple: true,
              activeColor: Color(0xFF52C41A),
              onSelectionChanged: (values) {},
              onNodeExpand: (node, expanded) {
                setState(() {});
              },
            ),

            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
