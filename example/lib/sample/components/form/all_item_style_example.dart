import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/components/form/group_example/expansion_group_example.dart';
import 'package:example/sample/components/form/group_example/group_add_example.dart';
import 'package:example/sample/components/form/group_example/normal_group_example.dart';
import 'package:example/sample/components/form/items_example/base_title_example.dart';
import 'package:example/sample/components/form/items_example/multi_choice_example.dart';
import 'package:example/sample/components/form/items_example/multi_choice_protrait_example.dart';
import 'package:example/sample/components/form/items_example/radio_input_example.dart';
import 'package:example/sample/components/form/items_example/radio_protrait_example.dart';
import 'package:example/sample/components/form/items_example/range_input_example.dart';
import 'package:example/sample/components/form/items_example/ratio_input_example.dart';
import 'package:example/sample/components/form/items_example/select_all_title_example.dart';
import 'package:example/sample/components/form/items_example/star_example.dart';
import 'package:example/sample/components/form/items_example/step_input_example.dart';
import 'package:example/sample/components/form/items_example/switch_example.dart';
import 'package:example/sample/components/form/items_example/text_block_input_example.dart';
import 'package:example/sample/components/form/items_example/text_input_example.dart';
import 'package:example/sample/components/form/items_example/text_quick_select_input_example.dart';
import 'package:example/sample/components/form/items_example/text_select_example.dart';
import 'package:example/sample/components/form/items_example/title_example.dart';
import 'package:example/sample/components/form/items_example/title_select_example.dart';
import 'package:example/sample/components/form/items_example/general_item_example.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AllFormItemStyleExamplePage extends StatelessWidget {
  final String _title;
  bool hideAppBar = false;

  AllFormItemStyleExamplePage([this._title = 'Form 表单']);

  @override
  Widget build(BuildContext context) {
    if (this.hideAppBar) {
      return this.getBodyWidget(context);
    }
    return SantoPageLayout(
        appBar: SantoAppBar(
          title: _title,
        ),
        padding: EdgeInsets.zero,
        scrollable: false,
        child: this.getBodyWidget(context));
  }

  Widget getBodyWidget(BuildContext context) {
    return ListView(
      children: <Widget>[

        // 基础类型
        SantoSection(
          title: '基础标题表单项',
          description: 'subTitle 展示副标题，error 呈现校验失败态',
          child: BaseTitleExamplePage(),
        ),
        SantoSection(
          title: '基础通用表单项',
          description: 'isEdit 控制编辑态，operateWidget 替换右侧操作区',
          child: GeneralFormExamplePage(),
        ),

        // 选择类型
        SantoSection(
          title: '文本选择表单项',
          description: 'onTap 触发选择回调，autoLayout 支持自适应布局',
          child: TextSelectInputExamplePage(),
        ),
        SantoSection(
          title: '快速选择输入表单项',
          description: 'btnsTxt 渲染候选按钮，isBtnsScroll 支持横向滚动',
          child: TextQuickSelectInputExamplePage(),
        ),

        // 文本输入类型
        SantoSection(
          title: '文本输入表单项',
          description: 'unit 补充单位后缀，isEdit 控制文本是否可编辑',
          child: TextInputExamplePage(),
        ),
        SantoSection(
          title: '块文本输入表单项',
          description: 'minLines 与 maxLines 限定行数区间，hint 展示占位提示',
          child: TextBlockInputExamplePage(),
        ),
        SantoSection(
          title: '范围输入表单项',
          description: 'leftMaxCount 限制左侧输入位数，inputType 限定数字类型',
          child: RangeInputExamplePage(),
        ),
        SantoSection(
          title: '比例输入表单项',
          description: 'prefixIconType 切换加减图标，isEdit 控制比例是否可改',
          child: RatioInputExamplePage(),
        ),
        SantoSection(
          title: 'Title选择输入表单项',
          description: 'selectList 提供候选标题，selectedIndex 标记选中下标',
          child: TitleSelectInputExamplePage(),
        ),

        // 单选&多选类型
        SantoSection(
          title: '横向单选表单项',
          description: 'enableList 控制选项可用性，layoutRatio 调整标题占比',
          child: RadioInputExamplePage(),
        ),
        SantoSection(
          title: '纵向单选表单项',
          description: 'options 纵向排列选项，enableList 决定单项是否可选',
          child: RadioPortraitInputExamplePage(),
        ),
        SantoSection(
          title: '横向多选表单项',
          description: 'value 传入已选列表，onChanged 回传新旧选项集合',
          child: MultiChoiceInputExamplePage(),
        ),
        SantoSection(
          title: '纵向多选表单项',
          description: 'options 纵向换行排列，enableList 禁用部分选项',
          child: MultiChoicePortraitInputExamplePage(),
        ),

        // 其他类型
        SantoSection(
          title: '标题表单项（杂项）',
          description: 'operationLabel 提供右侧操作入口，onTap 由该入口点击触发',
          child: TitleExamplePage(),
        ),
        SantoSection(
          title: '全选表单项',
          description: 'selectState 控制全选状态，onSelectAll 回传勾选结果',
          child: SelectAllTitleExamplePage(),
        ),
        SantoSection(
          title: '评星表单项',
          description: 'sumStar 设置星级总数，value 指定初始选中值',
          child: StarInputExamplePage(),
        ),
        SantoSection(
          title: '递增表单项',
          description: 'canManualInput 支持手动输入数值，maxLimit 限制最大值',
          child: StepInputExamplePage(),
        ),
        SantoSection(
          title: 'Switch表单项',
          description: 'value 绑定开关状态，onChanged 同步最新布尔值',
          child: SwitchInputExamplePage(),
        ),

        // 组类型
        SantoSection(
          title: '添加组表单项',
          description: 'isEdit 控制可点击态，onTap 触发添加分组回调',
          child: GroupAddExamplePage(),
        ),
        SantoSection(
          title: '普通分组表单项',
          description: 'children 承载子表单项，deleteLabel 配置删除按钮文案',
          child: NormalGroupExample(),
        ),
        SantoSection(
          title: '可展开收起分组表单项',
          description: 'isExpand 控制初始展开态，deleteLabel 展示删除入口',
          child: ExpansionGroupExample(),
        ),
      ],
    );
  }
}
