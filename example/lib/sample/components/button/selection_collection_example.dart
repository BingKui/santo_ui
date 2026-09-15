import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

class SantoSelectionBottomButtonExample extends StatefulWidget {
  @override
  _SantoSelectionBottomButtonExampleState createState() =>
      _SantoSelectionBottomButtonExampleState();
}

class _SantoSelectionBottomButtonExampleState
    extends State<SantoSelectionBottomButtonExample> {
  SantoMultipleBottomController controller = SantoMultipleBottomController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(
        title: '多选吸底按钮',
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
SantoPanel(
            title: '规则',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SantoBubbleText(
              maxLines: 3,
              text: '文字按钮最多两个：主按钮和次按钮，可以展示三种按钮的排列组合\n'
                  '主按钮和次按钮的宽度大小是 不固定的，随着icon按钮的多少而变化\n'
                  '上下padding：16，18。左右padding：20',
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SantoMultipleBottomButton(
                  bottomController: controller,
                  onSelectAll: (state) {
                    SantoToast.show('全选状态为 : $state', context);
                  },
                  onSelectedButtonTap: selectedButtonOnTap,
                  hasArrow: true,
                  mainButton: '主要按钮',
                  subButton: '次要按钮',
                  onMainButtonTap: () {
                    controller.setState(selectedCount: 11);
                    SantoToast.show('已选数量置为 : 11', context);
                  },
                  onSubButtonTap: () {
                    controller.setState(selectedCount: 0);
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
            )
          ],
            ),
          ),
],
        ),
      ),
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
}
