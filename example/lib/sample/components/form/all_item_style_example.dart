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
    return Scaffold(
        appBar: SantoAppBar(
          title: _title,
        ),
        body: this.getBodyWidget(context));
  }

  Widget getBodyWidget(BuildContext context) {
    return ListView(
      children: <Widget>[

        // 基础类型
        SantoPanel(
          title: '基础标题表单项',
          child: BaseTitleExamplePage(),
        ),
        SantoPanel(
          title: '基础通用表单项',
          child: GeneralFormExamplePage(),
        ),

        // 选择类型
        SantoPanel(
          title: '文本选择表单项',
          child: TextSelectInputExamplePage(),
        ),
        SantoPanel(
          title: '快速选择输入表单项',
          child: TextQuickSelectInputExamplePage(),
        ),

        // 文本输入类型
        SantoPanel(
          title: '文本输入表单项',
          child: TextInputExamplePage(),
        ),
        SantoPanel(
          title: '块文本输入表单项',
          child: TextBlockInputExamplePage(),
        ),
        SantoPanel(
          title: '范围输入表单项',
          child: RangeInputExamplePage(),
        ),
        SantoPanel(
          title: '比例输入表单项',
          child: RatioInputExamplePage(),
        ),
        SantoPanel(
          title: 'Title选择输入表单项',
          child: TitleSelectInputExamplePage(),
        ),

        // 单选&多选类型
        SantoPanel(
          title: '横向单选表单项',
          child: RadioInputExamplePage(),
        ),
        SantoPanel(
          title: '纵向单选表单项',
          child: RadioPortraitInputExamplePage(),
        ),
        SantoPanel(
          title: '横向多选表单项',
          child: MultiChoiceInputExamplePage(),
        ),
        SantoPanel(
          title: '纵向多选表单项',
          child: MultiChoicePortraitInputExamplePage(),
        ),

        // 其他类型
        SantoPanel(
          title: '标题表单项（杂项）',
          child: TitleExamplePage(),
        ),
        SantoPanel(
          title: '全选表单项',
          child: SelectAllTitleExamplePage(),
        ),
        SantoPanel(
          title: '评星表单项',
          child: StarInputExamplePage(),
        ),
        SantoPanel(
          title: '递增表单项',
          child: StepInputExamplePage(),
        ),
        SantoPanel(
          title: 'Switch表单项',
          child: SwitchInputExamplePage(),
        ),

        // 组类型
        SantoPanel(
          title: '添加组表单项',
          child: GroupAddExamplePage(),
        ),
        SantoPanel(
          title: '普通分组表单项',
          child: NormalGroupExample(),
        ),
        SantoPanel(
          title: '可展开收起分组表单项',
          child: ExpansionGroupExample(),
        ),
      ],
    );
  }
}
