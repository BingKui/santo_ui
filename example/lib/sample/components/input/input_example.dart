import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

/// SantoInputText 输入框示例
class SantoInputTextExample extends StatefulWidget {
  const SantoInputTextExample({Key? key}) : super(key: key);

  @override
  State<SantoInputTextExample> createState() => _SantoInputTextExampleState();
}

class _SantoInputTextExampleState extends State<SantoInputTextExample> {
  final TextEditingController _clearController = TextEditingController();
  final TextEditingController _counterController = TextEditingController();

  @override
  void dispose() {
    _clearController.dispose();
    _counterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brandPrimary =
        SantoThemeConfigurator.instance.getConfig().commonConfig.brandPrimary;
    return SantoPageLayout(      title: 'Input 输入框',
      children: <Widget>[
        ExampleIntro('input'),
        SantoPanel(
          title: '基础输入框',
          child: SantoInputText(
            hintText: '请输入文字',
            onChanged: (text) {},
          ),
        ),
        SantoPanel(
          title: '左侧标签与必填标识',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoInputText(
                label: '标签文字',
                labelWidth: 80,
                hintText: '请输入文字',
                onChanged: (text) {},
              ),
              SizedBox(height: 16),
              SantoInputText(
                label: '手机号',
                labelWidth: 80,
                required: true,
                hintText: '请输入手机号',
                inputFormat: SantoInputFormat.phone,
                onChanged: (text) {},
              ),
            ],
          ),
        ),
        SantoPanel(
          title: '右侧标识 / 图标 / 按钮',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoInputText(
                label: '金额',
                labelWidth: 80,
                hintText: '请输入金额',
                inputFormat: SantoInputFormat.number,
                suffixText: '元',
                onChanged: (text) {},
              ),
              SizedBox(height: 16),
              SantoInputText(
                label: '账号',
                labelWidth: 80,
                hintText: '请输入账号',
                suffixIcon: Icon(Icons.info_outline),
                onChanged: (text) {},
              ),
              SizedBox(height: 16),
              SantoInputText(
                label: '验证码',
                labelWidth: 80,
                hintText: '请输入验证码',
                inputFormat: SantoInputFormat.digit,
                maxLength: 6,
                suffixButton: SantoButton(
                  type: SantoButtonType.normal,
                  text: '获取',
                  width: 56,
                  fontSize: 12,
                  lineColor: brandPrimary,
                  textColor: brandPrimary,
                  insertPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  onTap: () {},
                ),
                onChanged: (text) {},
              ),
              SizedBox(height: 16),
              SantoInputText(
                label: '状态',
                labelWidth: 80,
                initialValue: '已完成',
                readOnly: true,
                suffix: SantoTagCustom(
                  tagText: '已验证',
                  textColor: Color(0xFF07C160),
                  backgroundColor: Color(0x2407C160),
                ),
                onChanged: (text) {},
              ),
            ],
          ),
        ),
        SantoPanel(
          title: '输入类型限制',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoInputText(
                label: '纯数字',
                labelWidth: 80,
                hintText: '只能输入数字',
                inputFormat: SantoInputFormat.digit,
                onChanged: (text) {},
              ),
              SizedBox(height: 16),
              SantoInputText(
                label: '数字',
                labelWidth: 80,
                hintText: '可输入小数和负号',
                inputFormat: SantoInputFormat.number,
                onChanged: (text) {},
              ),
              SizedBox(height: 16),
              SantoInputText(
                label: '身份证',
                labelWidth: 80,
                hintText: '数字与 X',
                inputFormat: SantoInputFormat.idCard,
                maxLength: 18,
                onChanged: (text) {},
              ),
              SizedBox(height: 16),
              SantoInputText(
                label: '邮箱',
                labelWidth: 80,
                hintText: '请输入邮箱',
                inputFormat: SantoInputFormat.email,
                onChanged: (text) {},
              ),
            ],
          ),
        ),
        SantoPanel(
          title: '带字数限制输入框',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoInputText(
                hintText: '最大 10 个字符（indicator 展示计数）',
                maxLength: 10,
                indicator: true,
                onChanged: (text) {},
              ),
              SizedBox(height: 16),
              SantoInputText(
                hintText: '最大 20 字符权重（中文算 2）',
                maxCharacter: 20,
                indicator: true,
                onChanged: (text) {},
              ),
            ],
          ),
        ),
        SantoPanel(
          title: '带操作输入框',
          child: SantoInputText(
            controller: _clearController,
            hintText: '输入内容后展示清除按钮',
            clearButtonMode: SantoInputClearButtonMode.always,
            onChanged: (text) {},
          ),
        ),
        SantoPanel(
          title: '带图标输入框',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoInputText(
                hintText: '搜索',
                prefix: Icon(Icons.search),
                clearButtonMode: SantoInputClearButtonMode.always,
                onChanged: (text) {},
              ),
              SizedBox(height: 16),
              SantoInputText(
                hintText: '带后缀',
                suffix: Icon(Icons.apps),
                onChanged: (text) {},
              ),
            ],
          ),
        ),
        SantoPanel(
          title: '特定类型输入框',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoInputText(
                hintText: '请输入密码',
                obscureText: true,
                showPasswordToggle: true,
                onChanged: (text) {},
              ),
              SizedBox(height: 16),
              SantoInputText(
                hintText: '请输入数字',
                inputType: TextInputType.number,
                onChanged: (text) {},
              ),
            ],
          ),
        ),
        SantoPanel(
          title: '输入框状态',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoInputText(
                hintText: '成功状态',
                initialValue: '成功状态',
                status: SantoInputStatus.success,
                onChanged: (text) {},
              ),
              SizedBox(height: 16),
              SantoInputText(
                hintText: '警告状态',
                initialValue: '警告状态',
                status: SantoInputStatus.warning,
                onChanged: (text) {},
              ),
              SizedBox(height: 16),
              SantoInputText(
                hintText: '错误状态',
                initialValue: '错误状态',
                status: SantoInputStatus.error,
                indicator: true,
                maxLength: 20,
                onChanged: (text) {},
              ),
            ],
          ),
        ),
        SantoPanel(
          title: '信息超长状态',
          child: SantoInputText(
            initialValue:
                '这是一段很长的信息这是一段很长的信息这是一段很长的信息这是一段很长的信息',
            maxLength: 20,
            indicator: true,
            status: SantoInputStatus.error,
            onChanged: (text) {},
          ),
        ),
        SantoPanel(
          title: '内容位置',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoInputText(
                hintText: '文字居中对齐',
                textAlign: TextAlign.center,
                onChanged: (text) {},
              ),
              SizedBox(height: 16),
              SantoInputText(
                hintText: '文字右对齐',
                textAlign: TextAlign.right,
                onChanged: (text) {},
              ),
            ],
          ),
        ),
        SantoPanel(
          title: '竖排样式（多行）',
          child: SantoInputText(
            hintText: '请输入多行文字',
            maxLines: null,
            minLines: 3,
            maxLength: 100,
            indicator: true,
            onChanged: (text) {},
          ),
        ),
        SantoPanel(
          title: '非通栏样式（无边框）',
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFFF5F6FA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SantoInputText(
              borderless: true,
              hintText: '无边框输入框',
              onChanged: (text) {},
            ),
          ),
        ),
        SantoPanel(
          title: '只读 / 禁用',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoInputText(
                initialValue: '只读模式，可选择复制但不可编辑',
                readOnly: true,
                onChanged: (text) {},
              ),
              SizedBox(height: 16),
              SantoInputText(
                initialValue: '禁用状态，不可交互',
                enabled: false,
                onChanged: (text) {},
              ),
            ],
          ),
        ),
        SantoPanel(
          title: '自定义样式输入框',
          child: SantoInputText(
            hintText: '自定义文字样式与光标颜色',
            style: TextStyle(fontSize: 18, color: Color(0xFF0984F9)),
            cursorColor: Color(0xFF0984F9),
            indicator: true,
            maxLength: 30,
            onChanged: (text) {},
          ),
        ),
      ],
    );
  }
}
