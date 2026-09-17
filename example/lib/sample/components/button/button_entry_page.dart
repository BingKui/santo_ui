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
    return SantoPageLayout(
      title: '按钮',
      padding: EdgeInsets.zero,
      scrollable: false,
      child: ListView(
        children: <Widget>[
          _buildButtonTypeSection(),
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

  /// 按钮类型(对标 antd Button type)
  Widget _buildButtonTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RulePanel(
          '通过 type 语法糖取预设样式：主按钮、默认按钮、虚线按钮、文本按钮、链接按钮。\n'
          '推荐主按钮在同一个操作区域最多出现一次。',
          maxLines: 3,
        ),
        SantoSection(
          title: '五种类型',
          description: '主按钮品牌色实心；默认按钮白底实线边框；虚线按钮白底虚线边框；'
              '文本按钮无底无边框；链接按钮无底无边框、文字为主题色',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SantoNormalButton(
                text: '主按钮',
                type: SantoButtonType.primary,
                insertPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                onTap: () {
                  SantoToast.show('点击了主按钮', context);
                },
              ),
              SantoNormalButton(
                text: '默认按钮',
                type: SantoButtonType.normal,
                insertPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                fontWeight: FontWeight.w500,
                textColor: const Color(0xFF17233D),
                onTap: () {
                  SantoToast.show('点击了默认按钮', context);
                },
              ),
              SantoNormalButton(
                text: '虚线按钮',
                type: SantoButtonType.dashed,
                insertPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                fontWeight: FontWeight.w500,
                onTap: () {
                  SantoToast.show('点击了虚线按钮', context);
                },
              ),
              SantoNormalButton(
                text: '文本按钮',
                type: SantoButtonType.text,
                insertPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                fontWeight: FontWeight.w500,
                onTap: () {
                  SantoToast.show('点击了文本按钮', context);
                },
              ),
              SantoNormalButton(
                text: '链接按钮',
                type: SantoButtonType.link,
                insertPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                fontWeight: FontWeight.w500,
                onTap: () {
                  SantoToast.show('点击了链接按钮', context);
                },
              ),
            ],
          ),
        ),
        SantoSection(
          title: '危险按钮',
          description: 'danger: true 时使用失败色,用于删除、授权等风险操作',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SantoNormalButton(
                text: '危险主按钮',
                type: SantoButtonType.primary,
                danger: true,
                insertPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                onTap: () {
                  SantoToast.show('点击了危险主按钮', context);
                },
              ),
              SantoNormalButton(
                text: '危险默认按钮',
                type: SantoButtonType.normal,
                danger: true,
                insertPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                fontWeight: FontWeight.w500,
                onTap: () {
                  SantoToast.show('点击了危险默认按钮', context);
                },
              ),
              SantoNormalButton(
                text: '危险虚线按钮',
                type: SantoButtonType.dashed,
                danger: true,
                insertPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                fontWeight: FontWeight.w500,
                onTap: () {
                  SantoToast.show('点击了危险虚线按钮', context);
                },
              ),
              SantoNormalButton(
                text: '危险链接按钮',
                type: SantoButtonType.link,
                danger: true,
                insertPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                fontWeight: FontWeight.w500,
                onTap: () {
                  SantoToast.show('点击了危险链接按钮', context);
                },
              ),
            ],
          ),
        ),
        SantoSection(
          title: '加载中',
          description: 'loading: true 时文案前展示 loading 图标,且不可点击,避免重复提交',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SantoNormalButton(
                text: '提交',
                type: SantoButtonType.primary,
                loading: true,
                insertPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                onTap: () {},
              ),
              SantoNormalButton(
                text: '提交',
                type: SantoButtonType.normal,
                loading: true,
                insertPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                fontWeight: FontWeight.w500,
                onTap: () {},
              ),
              SantoNormalButton(
                text: '提交',
                type: SantoButtonType.dashed,
                loading: true,
                insertPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                fontWeight: FontWeight.w500,
                onTap: () {},
              ),
            ],
          ),
        ),
        SantoSection(
          title: '图标位置',
          description: 'iconPlacement 控制图标在文案前(start,默认)或文案后(end)',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SantoNormalButton(
                text: '搜索',
                type: SantoButtonType.primary,
                icon: const Icon(Icons.search, size: 16, color: Colors.white),
                insertPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                onTap: () {
                  SantoToast.show('点击了搜索', context);
                },
              ),
              SantoNormalButton(
                text: '下一步',
                type: SantoButtonType.primary,
                iconPlacement: SantoButtonIconPlacement.end,
                icon: const Icon(Icons.arrow_forward,
                    size: 16, color: Colors.white),
                insertPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                onTap: () {
                  SantoToast.show('点击了下一步', context);
                },
              ),
              SantoNormalButton(
                text: '下载',
                type: SantoButtonType.normal,
                icon: const Icon(Icons.download, size: 16),
                insertPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                fontWeight: FontWeight.w500,
                onTap: () {
                  SantoToast.show('点击了下载', context);
                },
              ),
            ],
          ),
        ),
        SantoSection(
          title: '占满宽度与自动空格',
          description: 'block: true 时撑满父布局宽度;两个汉字的文案会自动在中间补空格(可关闭)',
          child: Column(
            children: [
              SantoNormalButton(
                text: '确定',
                type: SantoButtonType.primary,
                block: true,
                insertPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                onTap: () {
                  SantoToast.show('点击了确定', context);
                },
              ),
              SizedBox(height: 12),
              SantoNormalButton(
                text: '取消',
                type: SantoButtonType.normal,
                block: true,
                autoInsertSpace: false,
                insertPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                fontWeight: FontWeight.w500,
                onTap: () {
                  SantoToast.show('点击了取消', context);
                },
              ),
            ],
          ),
        ),
        SantoSection(
          title: '禁用',
          description: 'isEnable: false 时不可点击;实心按钮置灰,描边/文本类按钮文字置灰',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SantoNormalButton(
                text: '主按钮',
                type: SantoButtonType.primary,
                isEnable: false,
                insertPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                onTap: () {},
              ),
              SantoNormalButton(
                text: '默认按钮',
                type: SantoButtonType.normal,
                isEnable: false,
                insertPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                fontWeight: FontWeight.w500,
                onTap: () {},
              ),
              SantoNormalButton(
                text: '链接按钮',
                type: SantoButtonType.link,
                isEnable: false,
                insertPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                fontWeight: FontWeight.w500,
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
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
        SantoSection(
          title: '正常案例',
          description: '点击后触发 onTap 回调并弹出轻提示，用于验证默认样式与点击交互反馈',
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
        SantoSection(
          title: '正常案例 不响应点击事件',
          description: '不传 onTap 时按钮外观保持不变但点击无响应，便于对比有回调时的交互差异',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoBigMainButton(
                title: '提交',
              )
            ],
          ),
        ),
        SantoSection(
          title: '置灰案例',
          description: '设置 isEnable 为 false 后按钮置灰且点击不响应，适用于无权限或流程未完成的场景',
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
        SantoSection(
          title: '文案过长',
          description: '超长文案在按钮内单行居中显示并自动省略，用于验证极端文案下的截断表现',
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
        SantoSection(
          title: '自定义颜色、圆角、字号',
          description: '通过 bgColor 和 themeData 定制背景色、圆角、高度与字号等外观参数',
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
        SantoSection(
          title: '正常案例',
          description: '外层容器宽度设为100，按钮撑满可用宽度，点击触发 onTap 回调',
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
        SantoSection(
          title: '正常案例 无点击事件',
          description: '不传 onTap 时点击无响应，用于对比边框按钮有无回调时的交互差异',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoBigOutlineButton(
                title: '提交',
              )
            ],
          ),
        ),
        SantoSection(
          title: '置灰案例',
          description: '设置 isEnable 为 false 后按钮置灰，点击不再触发 onTap 回调',
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
        SantoSection(
          title: '文案过长',
          description: '超长文案单行居中并自动省略，用于验证边框按钮在极端文案下的排版表现',
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
        SantoSection(
          title: '正常案例',
          description: '点击触发 onTap 回调，背景为主题色低透明度填充，用于区分操作层级',
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
        SantoSection(
          title: '文案过长',
          description: '超长文案单行居中并自动省略，用于观察低透明度背景下长文案的展示效果',
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
        SantoSection(
          title: '正常案例',
          description: '点击触发 onTap 回调，按钮无边框且以主题色淡色铺底，展示默认幽灵效果',
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
        SantoSection(
          title: '文案过长',
          description: '超长文案单行居中并自动省略，验证幽灵按钮在极端文案下的展示效果',
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
        SantoSection(
          title: '正常案例',
          description: '点击触发 onTap 回调并弹出轻提示，展示最小宽度84下的默认按钮样式',
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
        SantoSection(
          title: '正常案例 自定义颜色',
          description: '通过 bgColor 传入 Colors.amber 替换默认背景色，其余样式保持不变',
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
        SantoSection(
          title: '正常案例 两字文案',
          description: '文案字数变化时按钮宽度自动适配内容，验证最小宽度84以上的自适应表现',
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
        SantoSection(
          title: '正常案例 三字文案',
          description: '文案加长后按钮同步变宽，用于对比不同文案长度下的布局差异',
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
        SantoSection(
          title: '置灰案例',
          description: '设置 isEnable 为 false 后按钮置灰且点击不响应，用于无权限或暂不可操作的场景',
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
        SantoSection(
          title: '文案过长',
          description: '超长文案单行居中并自动省略，用于验证小主按钮的最长展示宽度与截断效果',
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
        SantoSection(
          title: '正常案例',
          description: 'Row 中用 Expanded 均分宽度展示两个按钮，下方再附一个独立按钮对比布局',
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
        SantoSection(
          title: '正常案例 两字文案',
          description: '文案加长时按钮宽度随内容自适应增长，验证不同字数下的排版表现',
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
        SantoSection(
          title: '正常案例 自定义颜色',
          description: '通过 lineColor 与 textColor 将边框和文字改为红色，模拟驳回等警示操作',
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
        SantoSection(
          title: '正常案例 三字文案',
          description: '文案增至三字后按钮宽度随之增加，用于对比不同字数的布局差异',
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
        SantoSection(
          title: '置灰案例',
          description: '设置 isEnable 为 false 后按钮变为灰色态，点击不再有任何响应',
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
        SantoSection(
          title: '文案过长',
          description: '超长文案单行居中并自动省略，用于验证小边框按钮在极端文案下的截断表现',
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
        SantoSection(
          title: '正常案例',
          description: '仅传 mainButtonName 的最小用法，单独展示靠右的主按钮并触发点击回调',
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
        SantoSection(
          title: '主按钮置灰',
          description: '设置 isMainBtnEnable 为 false 后主按钮置灰，次按钮仍可正常点击回调',
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
        SantoSection(
          title: '两个次按钮',
          description: '两个次按钮平分主按钮之外的剩余空间，点击次按钮回传对应索引',
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
        SantoSection(
          title: '次按钮1置灰',
          description: '通过 SantoButtonPanelConfig 的 isEnable 单独置灰第一个次按钮',
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
        SantoSection(
          title: '主按钮文字长',
          description: '主按钮文案超长时按最大宽度132截断，次按钮排版不受影响',
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
        SantoSection(
          title: '次按钮文字长',
          description: '次按钮文案超长时单行省略，用于验证次按钮宽度与主按钮的分配关系',
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
        SantoSection(
          title: '次按钮多',
          description: '次按钮超过两个时收起多余的为更多图标，点击更多弹出剩余次按钮列表',
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
        SantoSection(
          title: '主按钮文字超长',
          description: '主按钮文案超长并搭配三个次按钮，验证极端文案与多按钮的布局表现',
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
        SantoSection(
          title: '更多弹出方向向上',
          description: '通过 popDirection 控制更多弹窗向上弹出，避免弹出层被底部遮挡',
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
        SantoSection(
          title: '按钮字符串为空',
          description: '主按钮与次按钮名称都传空串，验证空文案下按钮的占位与排版是否稳定',
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
        SantoSection(
          title: '一个操作',
          description: '仅传一个操作名的最小用法，点击后 onTap 回调返回下标 index',
          child: SantoTextButtonPanel(
            nameList: ['操作1'],
            onTap: (index) {
              SantoToast.show('第$index个操作', context);
            },
          ),
        ),
        SantoSection(
          title: '两个操作',
          description: '两个操作平分整行宽度，点击任意操作通过 onTap 回传对应索引',
          child: SantoTextButtonPanel(
            nameList: ['操作1', '操作2'],
            onTap: (index) {
              SantoToast.show('第$index个操作', context);
            },
          ),
        ),
        SantoSection(
          title: '三个操作',
          description: '三个操作平分整行宽度，验证多操作下文本按钮的等分排布',
          child: SantoTextButtonPanel(
            nameList: ['操作1', '操作2', '操作3'],
            onTap: (index) {
              SantoToast.show('第$index个操作', context);
            },
          ),
        ),
        SantoSection(
          title: '四个操作',
          description: '操作不超过4个时全部展示并平分宽度，用于观察数量达到上限的布局',
          child: SantoTextButtonPanel(
            nameList: ['操作1', '操作2', '操作3', '操作4'],
            onTap: (index) {
              SantoToast.show('第$index个操作', context);
            },
          ),
        ),
        SantoSection(
          title: '操作文本长',
          description: '操作文案超长时单行省略，用于验证文本按钮固定宽度下的截断表现',
          child: SantoTextButtonPanel(
            nameList: ['操作1操作1操作1操作1操作1操作1操作1操作1', '操作2', '操作3'],
            onTap: (index) {
              SantoToast.show('第$index个操作', context);
            },
          ),
        ),
        SantoSection(
          title: '操作太多弹出更多',
          description: '操作超过4个时只显示3个加更多入口，点击更多向上弹出剩余操作',
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
        SantoSection(
          title: '按钮字符串为空',
          description: '所有操作名都传空串，验证空文案下文本按钮与竖向分割线的占位效果',
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
        SantoSection(
          title: '仅主按钮',
          description: '仅传 mainButtonName 的最小用法，主按钮撑满可用宽度并触发点击回调',
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
        SantoSection(
          title: '次按钮置灰',
          description: '设置 enableSecondaryButton 为 false 后次按钮置灰，主按钮仍可点击',
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
        SantoSection(
          title: '一个icon按钮',
          description: 'iconButtonList 只有一个图标按钮，主次按钮宽度随之收缩',
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
        SantoSection(
          title: '两个icon按钮',
          description: 'iconButtonList 传入两个图标按钮，观察主次按钮与图标的宽度分配变化',
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
        SantoSection(
          title: '三个icon按钮',
          description: '图标按钮增加到三个，主次按钮继续收缩，用于观察多图标下的布局',
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
        SantoSection(
          title: '主按钮不可用',
          description: 'enableMainButton 设为 false 后主按钮置灰，对比带次按钮和图标的多种组合',
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
        SantoSection(
          title: '按钮文本长',
          description: '主次按钮文案超长时单行省略，验证文本过长对按钮宽度的影响',
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
        SantoSection(
          title: '按钮文本为空串',
          description: '主次按钮名称都传空串，验证空文案下按钮仍保留位置与点击区域',
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
        SantoSection(
          title: '正常案例',
          description: '演示全选、已选数量与主次按钮组合，hasArrow 控制箭头，数量由 bottomController 驱动',
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
    return SantoSection(
      title: '文字位置',
      description: 'direction 控制文字相对图标的位置：下（bottom）、上（top）、'
          '右（right）、左（left），点击触发 onTap 回调',
      child: Wrap(
        spacing: 24,
        runSpacing: 12,
        children: <Widget>[
          SantoIconButton(
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
          SantoIconButton(
              name: '文字在上',
              direction: Direction.top,
              padding: 4,
              iconWidget: Icon(Icons.assignment),
              onTap: () {
                SantoToast.show('按钮被点击', context);
              }),
          SantoIconButton(
              name: '文字在右',
              direction: Direction.right,
              padding: 4,
              iconWidget: Icon(Icons.autorenew),
              onTap: () {
                SantoToast.show('按钮被点击', context);
              }),
          SantoIconButton(
              name: '文字在左',
              direction: Direction.left,
              padding: 4,
              iconWidget: Icon(Icons.backspace),
              onTap: () {
                SantoToast.show('按钮被点击', context);
              }),
        ],
      ),
    );
  }
}
