import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

class SantoSwitchButtonExample extends StatefulWidget {
  @override
  _SantoSwitchButtonExampleState createState() =>
      _SantoSwitchButtonExampleState();
}

class _SantoSwitchButtonExampleState extends State<SantoSwitchButtonExample> {
  bool basicValue = true;
  bool disabledValue = true;
  bool offValue = false;
  bool loadingValue = true;
  bool textValue = true;
  bool longTextValue = true;
  bool colorValue = true;
  bool colorValue2 = false;
  bool externalValue = false;
  bool sizeValue = true;

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(      title: '开关元件',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SantoSection(
            title: '基础用法',
            description: 'value 与 onChanged 双向绑定，点击切换开关状态',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SantoBubbleText(maxLines: 2, text: '具备选中、未选中、以及禁用状态'),
                SizedBox(height: 12),
                SantoSwitchButton(
                  value: basicValue,
                  onChanged: (value) {
                    setState(() {
                      basicValue = value;
                    });
                  },
                ),
              ],
            ),
          ),
          SantoSection(
            title: '开/关文案',
            description: 'openText 与 closeText 传入文案，轨道按文案加宽，文案始终在滑块对侧',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SantoSwitchButton(
                  value: textValue,
                  openText: '开',
                  closeText: '关',
                  onChanged: (value) {
                    setState(() {
                      textValue = value;
                    });
                  },
                ),
                SizedBox(height: 16),
                SantoSwitchButton(
                  value: longTextValue,
                  openText: '启用',
                  closeText: '停用',
                  onChanged: (value) {
                    setState(() {
                      longTextValue = value;
                    });
                  },
                ),
              ],
            ),
          ),
          SantoSection(
            title: '自定义颜色',
            description:
                'activeColor、inactiveColor、thumbColor 分别控制选中轨道、未选中轨道与滑块颜色',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SantoSwitchButton(
                  value: colorValue,
                  activeColor: Color(0xFF52C41A),
                  inactiveColor: Color(0xFFF6FFED),
                  openText: '开',
                  closeText: '关',
                  onChanged: (value) {
                    setState(() {
                      colorValue = value;
                    });
                  },
                ),
                SizedBox(height: 16),
                SantoSwitchButton(
                  value: colorValue2,
                  activeColor: Color(0xFFFF4D4F),
                  inactiveColor: Color(0xFFFFF2F0),
                  thumbColor: Color(0xFFFFFBE6),
                  openText: '开',
                  closeText: '关',
                  onChanged: (value) {
                    setState(() {
                      colorValue2 = value;
                    });
                  },
                ),
              ],
            ),
          ),
          SantoSection(
            title: '外部控制状态',
            description: 'value 受控，onChanged 回传；父级直接改 value 即可从外部驱动开关',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SantoSwitchButton(
                  value: externalValue,
                  openText: '开',
                  closeText: '关',
                  onChanged: (value) {
                    setState(() {
                      externalValue = value;
                    });
                  },
                ),
                SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  children: [
                    SantoNormalButton.outline(
                      text: '外部开启',
                      fontSize: 12,
                      insertPadding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 12,
                      ),
                      onTap: () => setState(() => externalValue = true),
                    ),
                    SantoNormalButton.outline(
                      text: '外部关闭',
                      fontSize: 12,
                      insertPadding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 12,
                      ),
                      onTap: () => setState(() => externalValue = false),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SantoSection(
            title: '禁用状态',
            description: 'enabled 为 false 时组件置灰且不可切换',
            child: SantoSwitchButton(
              enabled: false,
              value: disabledValue,
              openText: '开',
              closeText: '关',
              onChanged: (value) {
                setState(() {
                  disabledValue = value;
                });
              },
            ),
          ),
          SantoSection(
            title: '未选中状态',
            description: 'value 为 false 时展示未选中的灰色轨道',
            child: SantoSwitchButton(
              value: offValue,
              onChanged: (value) {
                setState(() {
                  offValue = value;
                });
              },
            ),
          ),
          SantoSection(
            title: '加载状态',
            description: 'loading 为 true 时显示加载指示器并禁用交互',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SantoSwitchButton(
                  value: loadingValue,
                  loading: true,
                  onChanged: (value) {
                    setState(() {
                      loadingValue = value;
                    });
                  },
                ),
                SizedBox(height: 8),
                Text(
                  'loading 时显示加载指示器并禁用交互',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
          SantoSection(
            title: '自定义大小',
            description: 'size 传入 Size 自定义开关宽高，文案与滑块按尺寸等比缩放',
            child: SantoSwitchButton(
              size: Size(80, 40),
              value: sizeValue,
              openText: '开',
              closeText: '关',
              onChanged: (value) {
                setState(() {
                  sizeValue = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
