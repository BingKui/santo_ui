import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/rule_panel.dart';
import 'package:flutter/material.dart';

class ButtonEntryPage extends StatefulWidget {
  @override
  State<ButtonEntryPage> createState() => _ButtonEntryPageState();
}

class _ButtonEntryPageState extends State<ButtonEntryPage> {
  SantoMultipleBottomController _selectionController =
      SantoMultipleBottomController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(
        title: '按钮',
      ),
      body: ListView(
        children: <Widget>[
          _buildBigMainButtonSection(),
          _buildBigOutlineButtonSection(),
          _buildBigFuButtonSection(),
          _buildBigGhostButtonSection(),
          _buildSmallMainButtonSection(),
          _buildSmallOutlineButtonSection(),
          _buildButtonPanelSection(),
          _buildTextButtonPanelSection(),
          _buildBottomButtonPanelSection(),
          _buildSelectionBottomButtonSection(),
          _buildIconButtonSection(),
        ],
      ),
    );
  }

  /// 大主按钮
  Widget _buildBigMainButtonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RulePanel(
          '按钮宽度为屏幕宽度，按钮的高度为48，按钮的背景色主题色，按钮的圆角为4。\n'
          '按钮的文案最多居中显示一行，字号16号，文字颜色为白色。',
          maxLines: 3,
        ),
        SantoPanel(
          title: '大主按钮 - 正常案例',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoBigMainButton(
                title: '提交',
                onTap: () {
                  SantoToast.show('点击了主按钮', context);
                },
              )
            ],
          ),
        ),
        SantoPanel(
          title: '大主按钮 - 正常案例 不响应点击事件',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoBigMainButton(
                title: '提交',
              )
            ],
          ),
        ),
        SantoPanel(
          title: '大主按钮 - 置灰案例',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoBigMainButton(
                title: '提交',
                isEnable: false,
                onTap: () {
                  SantoToast.show('点击了主按钮', context);
                },
              )
            ],
          ),
        ),
        SantoPanel(
          title: '大主按钮 - 文案过长',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoBigMainButton(
                title: '主按钮的文案特别长主按钮的文案特别长主按钮的文案特别长主按钮的文案特别长',
                onTap: () {
                  SantoToast.show('点击了主按钮', context);
                },
              ),
              SantoNormalButton(
                isEnable: false,
                alignment: Alignment.center,
                text: '主案特别长',
                onTap: () {
                  SantoToast.show('点击了主按钮', context);
                },
              )
            ],
          ),
        ),
        SantoPanel(
          title: '大主按钮 - 自定义颜色、圆角、字号',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoBigMainButton(
                title: '登录',
                bgColor: Colors.red,
                themeData: SantoButtonConfig(
                  bigButtonRadius: 255,
                  bigButtonHeight: 50,
                  bigButtonFontSize: 20,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  /// 大边框按钮
  Widget _buildBigOutlineButtonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RulePanel(
          '按钮宽度为屏幕宽度，按钮的高度为48，按钮的背景色主题色，按钮的圆角为4。按钮的边框线为0xffD7D7D7\n'
          '按钮的文案最多居中显示一行，字号16号，字体w500，文字颜色为0xff222222。',
          maxLines: 3,
        ),
        SantoPanel(
          title: '大边框按钮 - 正常案例',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                child: SantoBigOutlineButton(
                  title: '提交',
                  onTap: () {
                    SantoToast.show('点击了按钮', context);
                  },
                ),
              )
            ],
          ),
        ),
        SantoPanel(
          title: '大边框按钮 - 正常案例 无点击事件',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoBigOutlineButton(
                title: '提交',
              )
            ],
          ),
        ),
        SantoPanel(
          title: '大边框按钮 - 置灰案例',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoBigOutlineButton(
                title: '提交',
                isEnable: false,
                onTap: () {
                  SantoToast.show('点击了按钮', context);
                },
              )
            ],
          ),
        ),
        SantoPanel(
          title: '大边框按钮 - 文案过长',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoBigOutlineButton(
                title: '按钮的文案特别长按钮的文案特别长按钮的文案特别长按钮的文案特别长',
                onTap: () {
                  SantoToast.show('点击了按钮', context);
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  /// 大辅助色按钮
  Widget _buildBigFuButtonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RulePanel(
          '按钮宽度为屏幕宽度，按钮的高度为48，按钮的背景色主题色的5%透明度，按钮的圆角为4。\n'
          '按钮的文案最多居中显示一行，字号16号，字体w500，文字颜色为主题色。',
          maxLines: 3,
        ),
        SantoPanel(
          title: '大辅助色按钮 - 正常案例',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoBigGhostButton(
                title: '提交',
                onTap: () {
                  SantoToast.show('点击了按钮', context);
                },
              )
            ],
          ),
        ),
        SantoPanel(
          title: '大辅助色按钮 - 文案过长',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoBigGhostButton(
                title: '按钮的文案特别长按钮的文案特别长按钮的文案特别长按钮的文案特别长',
                onTap: () {
                  SantoToast.show('点击了按钮', context);
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  /// 大幽灵按钮
  Widget _buildBigGhostButtonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RulePanel(
          '按钮宽度为屏幕宽度，按钮的高度为48，按钮的背景色主题色的5%透明度，按钮的圆角为4。\n'
          '按钮的文案最多居中显示一行，字号16号，字体w500，文字颜色为主题色。',
          maxLines: 3,
        ),
        SantoPanel(
          title: '大幽灵按钮 - 正常案例',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoBigGhostButton(
                title: '提交',
                onTap: () {
                  SantoToast.show('点击了按钮', context);
                },
              )
            ],
          ),
        ),
        SantoPanel(
          title: '大幽灵按钮 - 文案过长',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoBigGhostButton(
                title: '按钮的文案特别长按钮的文案特别长按钮的文案特别长按钮的文案特别长',
                onTap: () {
                  SantoToast.show('点击了按钮', context);
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  /// 小主按钮
  Widget _buildSmallMainButtonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RulePanel(
          '按钮的最小宽度为84，按钮的高度为32，按钮的背景色主题色，按钮的圆角为2。左右边距8\n'
          '按钮的文案最多居中显示一行，字号14号，文字颜色为白色。',
          maxLines: 3,
        ),
        SantoPanel(
          title: '小主按钮 - 正常案例',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoSmallMainButton(
                title: '提交',
                onTap: () {
                  SantoToast.show('点击了按钮', context);
                },
              )
            ],
          ),
        ),
        SantoPanel(
          title: '小主按钮 - 正常案例 自定义颜色',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoSmallMainButton(
                title: '提交',
                bgColor: Colors.amber,
              )
            ],
          ),
        ),
        SantoPanel(
          title: '小主按钮 - 正常案例 两字文案',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoSmallMainButton(
                title: '提交提交',
                onTap: () {
                  SantoToast.show('点击了按钮', context);
                },
              )
            ],
          ),
        ),
        SantoPanel(
          title: '小主按钮 - 正常案例 三字文案',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoSmallMainButton(
                title: '提交提交提交',
                onTap: () {
                  SantoToast.show('点击了按钮', context);
                },
              )
            ],
          ),
        ),
        SantoPanel(
          title: '小主按钮 - 置灰案例',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoSmallMainButton(
                title: '提交',
                isEnable: false,
                onTap: () {
                  SantoToast.show('点击了主按钮', context);
                },
              )
            ],
          ),
        ),
        SantoPanel(
          title: '小主按钮 - 文案过长',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoSmallMainButton(
                title: '按钮的文案特别长按钮的文案特别长按钮的文案特别长按钮的文案特别长',
                onTap: () {
                  SantoToast.show('点击了按钮', context);
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  /// 小边框按钮
  Widget _buildSmallOutlineButtonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RulePanel(
          '按钮的最小宽度为84，按钮的高度为32，按钮的背景色白色，按钮的圆角为2。左右边距8\n'
          '按钮的文案最多居中显示一行，字号14号，文字颜色为222222。',
          maxLines: 3,
        ),
        SantoPanel(
          title: '小边框按钮 - 正常案例',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: SantoSmallOutlineButton(
                        title: '提交',
                        onTap: () {
                          SantoToast.show('点击了按钮', context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Expanded(
                      child: SantoSmallOutlineButton(
                        title: '提交',
                        onTap: () {
                          SantoToast.show('点击了按钮', context);
                        },
                      ),
                    )
                  ],
                ),
              ),
              SantoSmallOutlineButton(
                title: '提交',
                onTap: () {
                  SantoToast.show('点击了按钮', context);
                },
              )
            ],
          ),
        ),
        SantoPanel(
          title: '小边框按钮 - 正常案例 两字文案',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoSmallOutlineButton(
                title: '提交提交',
                onTap: () {
                  SantoToast.show('点击了按钮', context);
                },
              )
            ],
          ),
        ),
        SantoPanel(
          title: '小边框按钮 - 正常案例 自定义颜色',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoSmallOutlineButton(
                lineColor: Colors.red,
                textColor: Colors.red,
                title: '驳回',
                onTap: () {
                  SantoToast.show('点击了按钮', context);
                },
              )
            ],
          ),
        ),
        SantoPanel(
          title: '小边框按钮 - 正常案例 三字文案',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoSmallOutlineButton(
                title: '提交提交提交',
                onTap: () {
                  SantoToast.show('点击了按钮', context);
                },
              )
            ],
          ),
        ),
        SantoPanel(
          title: '小边框按钮 - 置灰案例',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoSmallOutlineButton(
                title: '提交',
                isEnable: false,
                onTap: () {
                  SantoToast.show('点击了主按钮', context);
                },
              )
            ],
          ),
        ),
        SantoPanel(
          title: '小边框按钮 - 文案过长',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoSmallOutlineButton(
                title: '按钮的文案特别长按钮的文案特别长按钮的文案特别长按钮的文案特别长',
                onTap: () {
                  SantoToast.show('点击了按钮', context);
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  /// 按钮集合 SantoButtonPanel
  Widget _buildButtonPanelSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RulePanel(
          '靠右的横排展示，每个按钮的间距是8，按钮的组的间距是16'
          '，次按钮数目不超过两个时，优先展示主按钮，次按钮平分剩余空间，'
          '次按钮超过两个时，显示更多，剩下的空间主次按钮平分',
          maxLines: 3,
        ),
        SantoPanel(
          title: '按钮集合 - 正常案例',
          child: SantoButtonPanel(
            mainButtonName: '主按钮',
            mainButtonOnTap: () {
              SantoToast.show('主按钮点击', context);
            },
            secondaryButtonOnTap: (index) {
              SantoToast.show('第$index个次按钮点击了', context);
            },
          ),
        ),
        SantoPanel(
          title: '按钮集合 - 主按钮置灰',
          child: SantoButtonPanel(
            mainButtonName: '主按钮',
            mainButtonOnTap: () {
              SantoToast.show('主按钮点击', context);
            },
            isMainBtnEnable: false,
            secondaryButtonNameList: ['次按钮1'],
            secondaryButtonOnTap: (index) {
              SantoToast.show('第$index个次按钮点击了', context);
            },
          ),
        ),
        SantoPanel(
          title: '按钮集合 - 两个次按钮',
          child: SantoButtonPanel(
            mainButtonName: '主按钮',
            mainButtonOnTap: () {
              SantoToast.show('主按钮点击', context);
            },
            secondaryButtonNameList: ['次按钮1', '次按钮2'],
            secondaryButtonOnTap: (index) {
              SantoToast.show('第$index个次按钮点击了', context);
            },
          ),
        ),
        SantoPanel(
          title: '按钮集合 - 次按钮1置灰',
          child: SantoButtonPanel(
            mainButtonName: '主按钮',
            mainButtonOnTap: () {
              SantoToast.show('主按钮点击', context);
            },
            secondaryButtonList: [
              SantoButtonPanelConfig(name: '次按钮1', isEnable: false),
              SantoButtonPanelConfig(name: '次按钮2', isEnable: true)
            ],
            secondaryButtonOnTap: (index) {
              SantoToast.show('第$index个次按钮点击了', context);
            },
          ),
        ),
        SantoPanel(
          title: '按钮集合 - 主按钮文字长',
          child: SantoButtonPanel(
            mainButtonName: '主按钮主按钮主按钮主按钮主按钮主按钮主按钮',
            mainButtonOnTap: () {
              SantoToast.show('主按钮点击', context);
            },
            secondaryButtonNameList: ['次按钮1', '次按钮2'],
            secondaryButtonOnTap: (index) {
              SantoToast.show('第$index个次按钮点击了', context);
            },
          ),
        ),
        SantoPanel(
          title: '按钮集合 - 次按钮文字长',
          child: SantoButtonPanel(
            mainButtonName: '主按钮',
            mainButtonOnTap: () {
              SantoToast.show('主按钮点击', context);
            },
            secondaryButtonNameList: ['次按钮1', '次按钮次按钮次按钮次按钮次按钮次按钮次按钮'],
            secondaryButtonOnTap: (index) {
              SantoToast.show('第$index个次按钮点击了', context);
            },
          ),
        ),
        SantoPanel(
          title: '按钮集合 - 次按钮多',
          child: SantoButtonPanel(
            mainButtonName: '主按钮',
            mainButtonOnTap: () {
              SantoToast.show('主按钮点击', context);
            },
            secondaryButtonList: [
              SantoButtonPanelConfig(name: '次按钮1', isEnable: false),
              SantoButtonPanelConfig(name: '次按钮2', isEnable: true),
              SantoButtonPanelConfig(name: '次按钮3', isEnable: true),
              SantoButtonPanelConfig(name: '次按钮4', isEnable: false),
              SantoButtonPanelConfig(name: '次按钮5', isEnable: true),
            ],
            secondaryButtonOnTap: (index) {
              SantoToast.show('第$index个次按钮点击了', context);
            },
          ),
        ),
        SantoPanel(
          title: '按钮集合 - 主按钮文字超长',
          child: SantoButtonPanel(
            mainButtonName: '主按钮主按钮主按钮主按钮主按钮主按钮主按钮主按钮主按钮主按钮',
            mainButtonOnTap: () {
              SantoToast.show('主按钮点击', context);
            },
            secondaryButtonNameList: [
              '次按钮1',
              '次按钮2',
              '次按钮3',
            ],
            secondaryButtonOnTap: (index) {
              SantoToast.show('第$index个次按钮点击了', context);
            },
          ),
        ),
        SantoPanel(
          title: '按钮集合 - 更多弹出方向向上',
          child: SantoButtonPanel(
            mainButtonName: '主按钮',
            mainButtonOnTap: () {
              SantoToast.show('主按钮点击', context);
            },
            popDirection: SantoPopupDirection.top,
            secondaryButtonNameList: [
              '次按钮次按钮次按钮次按钮次按钮次按钮次按钮次按钮',
              '次按钮2',
              '次按钮3',
              '次按钮4',
              '次按钮5',
              '次按钮6',
            ],
            secondaryButtonOnTap: (index) {
              SantoToast.show('第$index个次按钮点击了', context);
            },
          ),
        ),
        SantoPanel(
          title: '按钮集合 - 按钮字符串为空',
          child: SantoButtonPanel(
            mainButtonName: '',
            mainButtonOnTap: () {
              SantoToast.show('主按钮点击', context);
            },
            secondaryButtonNameList: [
              '',
              '',
              '',
            ],
            secondaryButtonOnTap: (index) {
              SantoToast.show('第$index个次按钮点击了', context);
            },
          ),
        ),
      ],
    );
  }

  /// 文本按钮集合 SantoTextButtonPanel
  Widget _buildTextButtonPanelSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RulePanel(
          '平分屏幕展示,不超过4个时全部展示，超过4个了，则只展示3个，剩余的放在更多里面',
          maxLines: 3,
        ),
        SantoPanel(
          title: '文本按钮集合 - 一个操作',
          child: SantoTextButtonPanel(
            nameList: ['操作1'],
            onTap: (index) {
              SantoToast.show('第$index个操作', context);
            },
          ),
        ),
        SantoPanel(
          title: '文本按钮集合 - 两个操作',
          child: SantoTextButtonPanel(
            nameList: ['操作1', '操作2'],
            onTap: (index) {
              SantoToast.show('第$index个操作', context);
            },
          ),
        ),
        SantoPanel(
          title: '文本按钮集合 - 三个操作',
          child: SantoTextButtonPanel(
            nameList: ['操作1', '操作2', '操作3'],
            onTap: (index) {
              SantoToast.show('第$index个操作', context);
            },
          ),
        ),
        SantoPanel(
          title: '文本按钮集合 - 四个操作',
          child: SantoTextButtonPanel(
            nameList: ['操作1', '操作2', '操作3', '操作4'],
            onTap: (index) {
              SantoToast.show('第$index个操作', context);
            },
          ),
        ),
        SantoPanel(
          title: '文本按钮集合 - 操作文本长',
          child: SantoTextButtonPanel(
            nameList: ['操作1操作1操作1操作1操作1操作1操作1操作1', '操作2', '操作3'],
            onTap: (index) {
              SantoToast.show('第$index个操作', context);
            },
          ),
        ),
        SantoPanel(
          title: '文本按钮集合 - 操作太多弹出更多',
          child: SantoTextButtonPanel(
            nameList: ['操作1', '操作2', '操作3', '操作4', '操作5', '操作6'],
            popDirection: SantoPopupDirection.top,
            onTap: (index) {
              SantoDialogManager.showSingleButtonDialog(context,
                  message: 'index $index clicked!',
                  label: 'OK', onTap: () {
                Navigator.pop(context);
              });
            },
          ),
        ),
        SantoPanel(
          title: '文本按钮集合 - 按钮字符串为空',
          child: SantoTextButtonPanel(
            nameList: [
              '',
              '',
              '',
              '',
            ],
            onTap: (index) {
              SantoToast.show('第$index个操作', context);
            },
          ),
        ),
      ],
    );
  }

  /// 吸底按钮 SantoBottomButtonPanel
  Widget _buildBottomButtonPanelSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RulePanel(
          '文字按钮最多两个：主按钮和次按钮，可以展示三种按钮的排列组合\n'
          '主按钮和次按钮的宽度大小是 不固定的，随着icon按钮的多少而变化\n'
          '上下padding：16，18。左右padding：20',
          maxLines: 3,
        ),
        SantoPanel(
          title: '吸底按钮 - 仅主按钮',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoBottomButtonPanel(
                mainButtonName: '主按钮',
                mainButtonOnTap: () {
                  SantoToast.show('主按钮', context);
                },
              )
            ],
          ),
        ),
        SantoPanel(
          title: '吸底按钮 - 次按钮置灰',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoBottomButtonPanel(
                mainButtonName: '主按钮',
                mainButtonOnTap: () {
                  SantoToast.show('主按钮', context);
                },
                secondaryButtonName: '次按钮',
                enableSecondaryButton: false,
                secondaryButtonOnTap: () {
                  SantoToast.show('次按钮', context);
                },
              )
            ],
          ),
        ),
        SantoPanel(
          title: '吸底按钮 - 一个icon按钮',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoBottomButtonPanel(
                mainButtonName: '主按钮',
                mainButtonOnTap: () {
                  SantoToast.show('主按钮', context);
                },
                secondaryButtonName: '次按钮',
                secondaryButtonOnTap: () {
                  SantoToast.show('次按钮', context);
                },
                iconButtonList: [
                  SantoVerticalIconButton(
                    name: '写备注',
                    iconWidget: Icon(Icons.add),
                  ),
                ],
              )
            ],
          ),
        ),
        SantoPanel(
          title: '吸底按钮 - 两个icon按钮',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoBottomButtonPanel(
                mainButtonName: '主按钮',
                mainButtonOnTap: () {
                  SantoToast.show('主按钮', context);
                },
                secondaryButtonName: '次按钮',
                secondaryButtonOnTap: () {
                  SantoToast.show('次按钮', context);
                },
                iconButtonList: [
                  SantoVerticalIconButton(
                    name: '写备注',
                    iconWidget: Icon(Icons.add),
                  ),
                  SantoVerticalIconButton(
                    name: '写跟进',
                    iconWidget: Icon(Icons.functions),
                  ),
                ],
              )
            ],
          ),
        ),
        SantoPanel(
          title: '吸底按钮 - 三个icon按钮',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoBottomButtonPanel(
                mainButtonName: '主按钮',
                mainButtonOnTap: () {
                  SantoToast.show('主按钮', context);
                },
                secondaryButtonName: '次按钮',
                secondaryButtonOnTap: () {
                  SantoToast.show('次按钮', context);
                },
                iconButtonList: [
                  SantoVerticalIconButton(
                    name: '写备注',
                    iconWidget: Icon(Icons.add),
                  ),
                  SantoVerticalIconButton(
                    name: '写跟进',
                    iconWidget: Icon(Icons.functions),
                  ),
                  SantoVerticalIconButton(
                    name: '更多',
                    iconWidget: Icon(Icons.input),
                  ),
                ],
              )
            ],
          ),
        ),
        SantoPanel(
          title: '吸底按钮 - 主按钮不可用',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoBottomButtonPanel(
                mainButtonName: '主按钮',
                enableMainButton: false,
                mainButtonOnTap: () {
                  SantoToast.show('主按钮', context);
                },
                secondaryButtonName: '次按钮',
                secondaryButtonOnTap: () {
                  SantoToast.show('次按钮', context);
                },
                iconButtonList: [
                  SantoVerticalIconButton(
                    name: '写备注',
                    iconWidget: Icon(Icons.add),
                  ),
                  SantoVerticalIconButton(
                    name: '写跟进',
                    iconWidget: Icon(Icons.functions),
                  ),
                  SantoVerticalIconButton(
                    name: '更多',
                    onTap: () {
                      SantoToast.show('更多', context);
                    },
                    iconWidget: Icon(Icons.input),
                  ),
                ],
              ),
              SantoBottomButtonPanel(
                mainButtonName: '主按钮',
                enableMainButton: false,
                mainButtonOnTap: () {
                  SantoToast.show('主按钮', context);
                },
                secondaryButtonName: '次按钮',
                secondaryButtonOnTap: () {
                  SantoToast.show('次按钮', context);
                },
              ),
              SantoBottomButtonPanel(
                mainButtonName: '主按钮',
                enableMainButton: false,
                mainButtonOnTap: () {
                  SantoToast.show('主按钮', context);
                },
              )
            ],
          ),
        ),
        SantoPanel(
          title: '吸底按钮 - 按钮文本长',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoBottomButtonPanel(
                mainButtonName: '主按钮主按钮主按钮主按钮主按钮主按钮主按钮主按钮主按钮主按钮主按钮',
                mainButtonOnTap: () {
                  SantoToast.show('主按钮', context);
                },
              ),
              SantoBottomButtonPanel(
                mainButtonName: '主按钮主按钮主按钮主按钮主按钮主按钮主按钮主按钮主按钮主按钮主按钮',
                secondaryButtonName: '次按钮次按钮次按钮次按钮次按钮次按钮次按钮次按钮次按钮次按钮',
                mainButtonOnTap: () {
                  SantoToast.show('主按钮', context);
                },
                secondaryButtonOnTap: () {
                  SantoToast.show('次按钮', context);
                },
              ),
              SantoBottomButtonPanel(
                mainButtonName: '主按钮主按钮主按钮主按钮主按钮主按钮主按钮主按钮主按钮主按钮主按钮',
                secondaryButtonName: '次按钮次按钮次按钮次按钮次按钮次按钮次按钮次按钮次按钮次按钮',
                mainButtonOnTap: () {
                  SantoToast.show('主按钮', context);
                },
                secondaryButtonOnTap: () {
                  SantoToast.show('次按钮', context);
                },
                iconButtonList: [
                  SantoVerticalIconButton(
                    name: '写备注',
                    iconWidget: Icon(Icons.add),
                  ),
                  SantoVerticalIconButton(
                    name: '写跟进',
                    iconWidget: Icon(Icons.functions),
                  ),
                  SantoVerticalIconButton(
                    name: '更多',
                    iconWidget: Icon(Icons.input),
                  ),
                ],
              )
            ],
          ),
        ),
        SantoPanel(
          title: '吸底按钮 - 按钮文本为空串',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoBottomButtonPanel(
                mainButtonName: '',
                secondaryButtonName: '',
                mainButtonOnTap: () {
                  SantoToast.show('主按钮', context);
                },
                secondaryButtonOnTap: () {
                  SantoToast.show('次按钮', context);
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  /// 多选吸底按钮 SantoMultipleBottomButton
  Widget _buildSelectionBottomButtonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RulePanel(
          '文字按钮最多两个：主按钮和次按钮，可以展示三种按钮的排列组合\n'
          '主按钮和次按钮的宽度大小是 不固定的，随着icon按钮的多少而变化\n'
          '上下padding：16，18。左右padding：20',
          maxLines: 3,
        ),
        SantoPanel(
          title: '多选吸底按钮 - 正常案例',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SantoMultipleBottomButton(
                bottomController: _selectionController,
                onSelectAll: (state) {
                  SantoToast.show('全选状态为 : $state', context);
                },
                onSelectedButtonTap: selectedButtonOnTap,
                hasArrow: true,
                mainButton: '主要按钮',
                subButton: '次要按钮',
                onMainButtonTap: () {
                  _selectionController.setState(selectedCount: 11);
                  SantoToast.show('已选数量置为 : 11', context);
                },
                onSubButtonTap: () {
                  _selectionController.setState(selectedCount: 0);
                  SantoToast.show('已选数量置为 : 0', context);
                },
              ),
              SantoMultipleBottomButton(
                onSelectedButtonTap: selectedButtonOnTap,
                hasArrow: true,
                mainButton: '主要按钮',
                onMainButtonTap: () {
                  SantoToast.show('主按钮点击', context);
                },
              ),
              SantoMultipleBottomButton(
                onSelectedButtonTap: selectedButtonOnTap,
                hasArrow: false,
                mainButton: '主要按钮',
                onMainButtonTap: () {
                  SantoToast.show('主按钮点击', context);
                },
              ),
              SantoMultipleBottomButton(
                onSelectedButtonTap: selectedButtonOnTap,
                hasArrow: false,
                mainButton: '主要按钮',
                onMainButtonTap: () {
                  SantoToast.show('主按钮点击', context);
                },
                subButton: '次要按钮',
              ),
              SantoMultipleBottomButton(
                bottomController: SantoMultipleBottomController(
                    initMultiSelectState:
                        MultiSelectState(selectedCount: 99)),
                onSelectedButtonTap: selectedButtonOnTap,
                hasArrow: false,
                mainButton: '主要按钮',
                onMainButtonTap: () {
                  SantoToast.show('主按钮点击', context);
                },
                subButton: '次要按钮',
              )
            ],
          ),
        ),
      ],
    );
  }

  void selectedButtonOnTap(SantoMultipleButtonArrowState state) {
    String info = "";
    switch (state) {
      case SantoMultipleButtonArrowState.unfold:
        info = '展开状态';
        break;
      case SantoMultipleButtonArrowState.cantUnfold:
        info = '无法展开状态';
        break;
      case SantoMultipleButtonArrowState.fold:
        info = '收起状态';
        break;
      case SantoMultipleButtonArrowState.defaultStatus:
        break;
    }
    SantoToast.show('已选择状态为 : $info', context);
  }

  /// 图文按钮 SantoIconButton
  Widget _buildIconButtonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SantoPanel(
          title: '图文按钮 - 文字在下',
          child: Center(
            child: SantoIconButton(
                name: '文字在下',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF808695),
                ),
                direction: Direction.bottom,
                padding: 4,
                iconHeight: 30,
                iconWidth: 30,
                iconWidget: Icon(Icons.arrow_upward),
                onTap: () {
                  SantoToast.show('按钮被点击', context);
                }),
          ),
        ),
        SantoPanel(
          title: '图文按钮 - 文字在上',
          child: Center(
            child: SantoIconButton(
                name: '文字在上',
                direction: Direction.top,
                padding: 4,
                iconWidget: Icon(Icons.assignment),
                onTap: () {
                  SantoToast.show('按钮被点击', context);
                }),
          ),
        ),
        SantoPanel(
          title: '图文按钮 - 文字在右',
          child: Center(
            child: SantoIconButton(
                name: '文字在右',
                direction: Direction.right,
                padding: 4,
                iconWidget: Icon(Icons.autorenew),
                onTap: () {
                  SantoToast.show('按钮被点击', context);
                }),
          ),
        ),
        SantoPanel(
          title: '图文按钮 - 文字在左',
          child: Center(
            child: SantoIconButton(
                name: '文字在左',
                direction: Direction.left,
                padding: 4,
                iconWidget: Icon(Icons.backspace),
                onTap: () {
                  SantoToast.show('按钮被点击', context);
                }),
          ),
        ),
      ],
    );
  }
}
