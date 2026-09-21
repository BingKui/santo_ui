import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

/// 级联选择器示例
class CascaderExample extends StatefulWidget {
  @override
  _CascaderExampleState createState() => _CascaderExampleState();
}

class _CascaderExampleState extends State<CascaderExample> {
  String _selectedRegion = '请选择地区';
  String _selectedAddress = '请选择地址';

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
    return SantoPageLayout(      title: 'Cascader 级联选择器示例',
      children: <Widget>[
        ExampleIntro('cascader'),
        // 场景1：内置省/市/区数据选择
        SantoSection(
          title: '省/市/区 三级联动（内置数据）',
          description:
              'showArea 使用内置 vant 行政区划数据，onConfirm 回传 SantoAreaResult（codes/names/text）',
          child: GestureDetector(
            onTap: () {
              SantoCascader.showArea(
                context: context,
                title: '请选择地区',
                onConfirm: (result) {
                  setState(() {
                    _selectedRegion = result.text;
                  });
                  SantoToast.show(
                      'code: ${result.codes.join(" / ")}\nname: ${result.names.join(" / ")}',
                      context);
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
          description: 'initialValues 传行政区划码，预置广东省(440000)、深圳市(440300)、南山区(440305)',
          child: GestureDetector(
            onTap: () {
              SantoCascader.showArea(
                context: context,
                title: '请选择地区',
                initialValues: ['440000', '440300', '440305'],
                onConfirm: (result) {
                  SantoToast.show(
                      '选择了: ${result.text}\n${result.codes.join(" / ")}', context);
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
    );
  }
}
