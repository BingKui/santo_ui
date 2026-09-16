import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

class BubbleTextExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(
        title: '气泡信息',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSection('左侧气泡（start）', [
              SantoBubbleText(
                maxLines: 3,
                placement: SantoBubblePlacement.start,
                text: '最多显示三行文本，整体圆角12，左上角是小圆角，\n '
                    '文本的字号是14，颜色为深色',
              ),
            ]),
            SizedBox(height: 24),
            _buildSection('右侧气泡（end）', [
              SantoBubbleText(
                maxLines: 3,
                placement: SantoBubblePlacement.end,
                text: '最多显示三行文本，整体圆角12，右上角是小圆角，\n '
                    '文本的字号是14，颜色为深色',
              ),
            ]),
            SizedBox(height: 24),
            _buildSection('自定义圆角', [
              SantoBubbleText(
                placement: SantoBubblePlacement.start,
                radius: 24,
                text: '大圆角气泡 radius 24',
              ),
              SizedBox(height: 12),
              SantoBubbleText(
                placement: SantoBubblePlacement.end,
                radius: 4,
                text: '小圆角气泡 radius 4',
              ),
            ]),
            SizedBox(height: 24),
            _buildSection('自定义背景色和文字颜色', [
              SantoBubbleText(
                placement: SantoBubblePlacement.end,
                bgColor: Color(0xFF0984F9),
                textColor: Colors.white,
                text: '蓝色气泡，白色文字',
              ),
              SizedBox(height: 12),
              SantoBubbleText(
                placement: SantoBubblePlacement.start,
                bgColor: Color(0xFFE8F8EE),
                textColor: Color(0xFF07C160),
                text: '绿色气泡，绿色文字',
              ),
            ]),
            SizedBox(height: 24),
            _buildSection('展开收起', [
              SantoBubbleText(
                maxLines: 2,
                text: '推荐理由："满五唯一""临近地铁""首付低"，多出折行显示，文字展开的样式文式文文字展开的样式文式文。问我',
                onExpanded: (isExpanded) {
                  String str = isExpanded ? "展开了" : "收起了";
                  SantoToast.show("我$str", context);
                },
              ),
            ]),
            SizedBox(height: 24),
            _buildSection('正常案例', [
              SantoInsertInfo(
                infoText: '推荐理由："满五唯一""临近地铁""首付低"，多出折行显示，文字展开的样式文。',
              ),
            ]),
            SizedBox(height: 24),
            _buildSection('异常案例文案过长', [
              SantoInsertInfo(
                infoText:
                    '推荐理由："满五唯一""临近地铁""首付低"，多出折行显示，文字展开的样式文。按钮的文案特别长按钮的文案特别长按钮的文案特别长按钮的文案特别长',
              ),
            ]),
            SizedBox(height: 24),
            _buildSection('异常案例文案过少', [
              SantoInsertInfo(
                infoText: '推荐理由',
              ),
            ]),
            SizedBox(height: 24),
            _buildSection('异常案例文案长度为0', [
              SantoInsertInfo(
                infoText: '',
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF222222),
          ),
        ),
        SizedBox(height: 12),
        ...children,
      ],
    );
  }
}
