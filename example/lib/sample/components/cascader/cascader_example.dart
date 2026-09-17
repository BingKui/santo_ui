import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// 级联选择器示例
class CascaderExample extends StatefulWidget {
  @override
  _CascaderExampleState createState() => _CascaderExampleState();
}

class _CascaderExampleState extends State<CascaderExample> {
  String _selectedRegion = '请选择地区';
  String _selectedAddress = '请选择地址';

  /// 省/市/区 三级数据
  final List<SantoCascaderItem> _regionData = [
    SantoCascaderItem(
      label: '北京市',
      value: 'beijing',
      children: [
        SantoCascaderItem(
          label: '北京市',
          value: 'beijing_city',
          children: [
            SantoCascaderItem(label: '东城区', value: 'dongcheng'),
            SantoCascaderItem(label: '西城区', value: 'xicheng'),
            SantoCascaderItem(label: '朝阳区', value: 'chaoyang'),
            SantoCascaderItem(label: '海淀区', value: 'haidian'),
            SantoCascaderItem(label: '丰台区', value: 'fengtai'),
          ],
        ),
      ],
    ),
    SantoCascaderItem(
      label: '上海市',
      value: 'shanghai',
      children: [
        SantoCascaderItem(
          label: '上海市',
          value: 'shanghai_city',
          children: [
            SantoCascaderItem(label: '黄浦区', value: 'huangpu'),
            SantoCascaderItem(label: '徐汇区', value: 'xuhui'),
            SantoCascaderItem(label: '长宁区', value: 'changning'),
            SantoCascaderItem(label: '静安区', value: 'jingan'),
            SantoCascaderItem(label: '浦东新区', value: 'pudong'),
          ],
        ),
      ],
    ),
    SantoCascaderItem(
      label: '广东省',
      value: 'guangdong',
      children: [
        SantoCascaderItem(
          label: '广州市',
          value: 'guangzhou',
          children: [
            SantoCascaderItem(label: '天河区', value: 'tianhe'),
            SantoCascaderItem(label: '越秀区', value: 'yuexiu'),
            SantoCascaderItem(label: '荔湾区', value: 'liwan'),
          ],
        ),
        SantoCascaderItem(
          label: '深圳市',
          value: 'shenzhen',
          children: [
            SantoCascaderItem(label: '南山区', value: 'nanshan'),
            SantoCascaderItem(label: '福田区', value: 'futian'),
            SantoCascaderItem(label: '罗湖区', value: 'luohu'),
          ],
        ),
      ],
    ),
    SantoCascaderItem(
      label: '浙江省',
      value: 'zhejiang',
      children: [
        SantoCascaderItem(
          label: '杭州市',
          value: 'hangzhou',
          children: [
            SantoCascaderItem(label: '西湖区', value: 'xihu'),
            SantoCascaderItem(label: '上城区', value: 'shangcheng'),
            SantoCascaderItem(label: '拱墅区', value: 'gongshu'),
          ],
        ),
        SantoCascaderItem(
          label: '宁波市',
          value: 'ningbo',
          children: [
            SantoCascaderItem(label: '海曙区', value: 'haishu'),
            SantoCascaderItem(label: '鄞州区', value: 'yinzhou'),
          ],
        ),
      ],
    ),
  ];

  /// 两级数据（如大类/小类）
  final List<SantoCascaderItem> _categoryData = [
    SantoCascaderItem(
      label: '电子产品',
      value: 'electronics',
      children: [
        SantoCascaderItem(label: '手机', value: 'phone'),
        SantoCascaderItem(label: '电脑', value: 'computer'),
        SantoCascaderItem(label: '平板', value: 'tablet'),
      ],
    ),
    SantoCascaderItem(
      label: '服装',
      value: 'clothing',
      children: [
        SantoCascaderItem(label: '男装', value: 'mens'),
        SantoCascaderItem(label: '女装', value: 'womens'),
        SantoCascaderItem(label: '童装', value: 'kids'),
      ],
    ),
    SantoCascaderItem(
      label: '食品',
      value: 'food',
      children: [
        SantoCascaderItem(label: '零食', value: 'snacks'),
        SantoCascaderItem(label: '饮料', value: 'drinks'),
        SantoCascaderItem(label: '生鲜', value: 'fresh'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 场景1：省/市/区三级选择
          SantoSection(
            title: '省/市/区 三级联动',
            description: 'columnCount 为 3，onConfirm 回传选中项并拼接展示',
            child: GestureDetector(
              onTap: () {
                SantoCascader.show(
                  context: context,
                  title: '请选择地区',
                  data: _regionData,
                  columnCount: 3,
                  onConfirm: (selectedItems, selectedValues) {
                    setState(() {
                      _selectedRegion = selectedItems.map((e) => e.label).join(' / ');
                    });
                  },
                );
              },
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFDCDEE2)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedRegion,
                        style: TextStyle(
                          fontSize: 14,
                          color: _selectedRegion == '请选择地区'
                              ? Color(0xFF808695)
                              : Color(0xFF17233D),
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF808695)),
                  ],
                ),
              ),
            ),
          ),

          // 场景2：两级分类选择
          SantoSection(
            title: '大类/小类 两级联动',
            description: 'columnCount 为 2，确认后回写所选分类到输入框',
            child: GestureDetector(
              onTap: () {
                SantoCascader.show(
                  context: context,
                  title: '请选择分类',
                  data: _categoryData,
                  columnCount: 2,
                  onConfirm: (selectedItems, selectedValues) {
                    setState(() {
                      _selectedAddress = selectedItems.map((e) => e.label).join(' / ');
                    });
                  },
                );
              },
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFDCDEE2)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedAddress,
                        style: TextStyle(
                          fontSize: 14,
                          color: _selectedAddress == '请选择地址'
                              ? Color(0xFF808695)
                              : Color(0xFF17233D),
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF808695)),
                  ],
                ),
              ),
            ),
          ),

          // 场景3：带初始值的选择
          SantoSection(
            title: '带初始值的选择',
            description: 'initialValues 预置广东省、深圳市、南山区为默认选中',
            child: GestureDetector(
              onTap: () {
                SantoCascader.show(
                  context: context,
                  title: '请选择地区',
                  data: _regionData,
                  columnCount: 3,
                  initialValues: ['guangdong', 'shenzhen', 'nanshan'],
                  onConfirm: (selectedItems, selectedValues) {
                    SantoToast.show(
                        '选择了: ${selectedValues.join(" / ")}', context);
                  },
                );
              },
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFDCDEE2)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '默认选中：广东省/深圳市/南山区',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF17233D),
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF808695)),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 40),
        ],
      ),
    );
  }
}
