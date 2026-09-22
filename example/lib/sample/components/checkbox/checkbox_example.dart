import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

/// SantoCheckbox 多选框示例
class CheckboxExample extends StatefulWidget {
  @override
  State<CheckboxExample> createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<CheckboxExample> {
  /// 全选演示:分组控制器 + 勾选项
  final SantoCheckboxGroupController _controller = SantoCheckboxGroupController();

  static const _allSelectCount = 4;

  Color get _primary =>
      SantoThemeConfigurator.instance.getConfig().commonConfig.brandPrimary;

  Color get _unselected => SantoThemeConfigurator.instance
      .getConfig()
      .commonConfig
      .borderColorBase;

  @override
  void initState() {
    super.initState();
    // 全选演示默认勾选中间两项
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.toggle('index:2', true);
      _controller.toggle('index:3', true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: 'Checkbox 多选框',
      backgroundColor: const Color(0xFFF5F6FA),
      children: <Widget>[
        ExampleIntro('checkbox'),
        SantoSection(
          title: '纵向多选框',
          description: '默认纵向排列,支持多行标题与副标题',
          child: SantoCheckboxGroup(
            checkedIds: const ['index:1'],
            child: Column(
              children: [
                ...List.generate(4, (index) {
                  final isLongTitle = index == 2;
                  return SantoCheckbox(
                    id: 'index:$index',
                    title: isLongTitle
                        ? '多选标题多行多选标题多行多选标题多行多选标题多行'
                        : '多选',
                    titleMaxLine: 2,
                    subTitle: index == 3 ? '描述信息描述信息描述信息描述信息' : null,
                    subTitleMaxLine: 2,
                  );
                }),
              ],
            ),
          ),
        ),
        SantoSection(
          title: '横向多选框',
          description: 'SantoCheckboxGroupContainer 设置 direction 为 horizontal',
          child: SantoCheckboxGroupContainer(
            selectIds: const ['1'],
            direction: Axis.horizontal,
            directionalCheckboxes: const [
              SantoCheckbox(
                id: '0',
                title: '多选标题',
                insetSpacing: 12,
                showDivider: false,
              ),
              SantoCheckbox(
                id: '1',
                title: '多选标题',
                insetSpacing: 12,
                showDivider: false,
              ),
              SantoCheckbox(
                id: '2',
                title: '上限四字',
                insetSpacing: 12,
                showDivider: false,
              ),
            ],
          ),
        ),
        SantoSection(
          title: '横向换行',
          description: 'rowCount 控制每行个数,超出自动换行',
          child: SantoCheckboxGroupContainer(
            selectIds: const ['0', '1'],
            direction: Axis.horizontal,
            rowCount: 2,
            directionalCheckboxes: const [
              SantoCheckbox(
                id: '0',
                title: '多选标题0',
                insetSpacing: 12,
                showDivider: false,
              ),
              SantoCheckbox(
                id: '1',
                title: '多选标题1',
                insetSpacing: 12,
                showDivider: false,
              ),
              SantoCheckbox(
                id: '2',
                title: '多选标题2',
                insetSpacing: 12,
                showDivider: false,
              ),
              SantoCheckbox(
                id: '3',
                title: '多选标题3',
                insetSpacing: 12,
                showDivider: false,
              ),
            ],
          ),
        ),
        SantoSection(
          title: '带全选',
          description: '控制器统一操作组内勾选,自定义指示器表达全选/半选',
          child: SantoCheckboxGroupContainer(
            controller: _controller,
            selectIds: const [],
            child: Column(
              children: [
                SizedBox(
                  height: 56,
                  child: SantoCheckbox(
                    id: 'index:0',
                    title: '全选',
                    customIconBuilder: (context, checked) {
                      final ids = _controller
                          .allChecked()
                          .where((id) => id != 'index:0')
                          .toList();
                      final allChecked =
                          ids.length == _allSelectCount - 1;
                      final halfSelected =
                          !allChecked && ids.isNotEmpty;
                      return Icon(
                        allChecked
                            ? Icons.check_circle
                            : halfSelected
                                ? Icons.remove_circle
                                : Icons.radio_button_unchecked,
                        size: 24,
                        color: allChecked || halfSelected
                            ? _primary
                            : _unselected,
                      );
                    },
                    onChanged: (checked) => _controller.toggleAll(checked),
                  ),
                ),
                ...List.generate(_allSelectCount - 1, (index) {
                  final id = 'index:${index + 1}';
                  return SizedBox(
                    height: 56,
                    child: SantoCheckbox(
                      id: id,
                      title: '多选',
                      onChanged: (checked) {
                        final ids = _controller
                            .allChecked()
                            .where((e) => e != 'index:0')
                            .toList();
                        _controller
                            .toggle('index:0', ids.length == _allSelectCount - 1);
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        SantoSection(
          title: '多选框状态',
          description: 'enable 为 false 时置灰且不可点击',
          child: SantoCheckboxGroup(
            checkedIds: const ['0'],
            child: const Column(
              children: [
                SantoCheckbox(id: '0', title: '选项禁用-已选', enable: false),
                SantoCheckbox(id: '1', title: '选项禁用-默认', enable: false),
              ],
            ),
          ),
        ),
        SantoSection(
          title: '勾选样式',
          description: 'style 内置圆形、方形、无背景勾选三种样式',
          child: Column(
            children: [
              for (final entry in const [
                ('圆形', SantoCheckboxStyle.circle),
                ('方形', SantoCheckboxStyle.square),
                ('对号', SantoCheckboxStyle.check),
              ])
                SantoCheckboxGroup(
                  checkedIds: const ['0'],
                  child: SantoCheckbox(
                    id: '0',
                    title: '${entry.$1}样式',
                    style: entry.$2,
                  ),
                ),
            ],
          ),
        ),
        SantoSection(
          title: '勾选显示位置',
          description: 'contentDirection 控制内容在指示器左侧或右侧',
          child: Column(
            children: [
              SantoCheckboxGroup(
                contentDirection: SantoContentDirection.right,
                checkedIds: const ['index:0'],
                child: const SantoCheckbox(id: 'index:0', title: '内容在右'),
              ),
              SantoCheckboxGroup(
                contentDirection: SantoContentDirection.left,
                checkedIds: const ['index:1'],
                child: const SantoCheckbox(id: 'index:1', title: '内容在左'),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '非通栏样式',
          description: 'passThrough 为 true 时整体裁切圆角并向两侧留出外边距',
          child: SantoCheckboxGroupContainer(
            selectIds: const ['index:0'],
            passThrough: true,
            child: Column(
              children: List.generate(
                4,
                (index) => SantoCheckbox(
                  id: 'index:$index',
                  title: '多选',
                  size: SantoCheckBoxSize.large,
                ),
              ),
            ),
          ),
        ),
        SantoSection(
          title: '纵向卡片样式',
          description: 'cardMode 为 true 时展示为卡片,选中显示边框与右侧同色 check-circle 图标',
          child: SantoCheckboxGroupContainer(
            selectIds: const ['index:1'],
            cardMode: true,
            direction: Axis.vertical,
            directionalCheckboxes: const [
              SantoCheckbox(
                id: 'index:0',
                title: '多选',
                titleMaxLine: 2,
                subTitle: '描述信息',
                subTitleMaxLine: 2,
                cardMode: true,
              ),
              SantoCheckbox(
                id: 'index:1',
                title: '多选',
                titleMaxLine: 2,
                subTitle: '描述信息',
                subTitleMaxLine: 2,
                cardMode: true,
              ),
              SantoCheckbox(
                id: 'index:2',
                title: '多选',
                titleMaxLine: 2,
                subTitle: '描述信息',
                subTitleMaxLine: 2,
                cardMode: true,
              ),
            ],
          ),
        ),
        SantoSection(
          title: '横向卡片样式',
          description: '卡片模式横向排列,单个卡片自适应等分',
          child: SantoCheckboxGroupContainer(
            selectIds: const ['index:1'],
            cardMode: true,
            direction: Axis.horizontal,
            directionalCheckboxes: const [
              SantoCheckbox(id: 'index:0', title: '多选', cardMode: true),
              SantoCheckbox(id: 'index:1', title: '多选', cardMode: true),
              SantoCheckbox(id: 'index:2', title: '多选', cardMode: true),
            ],
          ),
        ),
        SantoSection(
          title: '自定义指示器',
          description: 'customIconBuilder 可完全替换指示器',
          child: SantoCheckboxGroup(
            checkedIds: const ['index:0'],
            child: SantoCheckbox(
              id: 'index:0',
              title: '自定义图标',
              customIconBuilder: (context, checked) => Icon(
                Icons.star,
                size: 24,
                color: checked ? _primary : _unselected,
              ),
            ),
          ),
        ),
        SantoSection(
          title: '自定义颜色与字体',
          description: 'selectColor、disableColor、titleColor 与 titleStyle 均可自定义',
          child: SantoCheckboxGroup(
            checkedIds: const ['index:0'],
            child: const Column(
              children: [
                SantoCheckbox(
                  id: 'index:0',
                  title: '自定义选中色',
                  subTitle: '描述信息',
                  selectColor: Color(0xFFE34D59),
                  disableColor: Color(0xFFF9DCDE),
                ),
                SantoCheckbox(
                  id: 'index:1',
                  title: '自定义文字颜色',
                  titleColor: Color(0xFF07C160),
                  subTitle: '描述信息',
                  subTitleColor: Color(0xFF0984F9),
                  titleStyle: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
