import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_theme_config.dart';
import 'package:example/sample/home/list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/l10n.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final GlobalKey _localKey = GlobalKey();
  final GlobalKey _themeKey = GlobalKey();
  final TextEditingController _brandColorController = TextEditingController();

  @override
  void dispose() {
    _brandColorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      appBar: SantoAppBar(
        title: '设置',
        leading: SantoBackLeading(),
        automaticallyImplyLeading: false,
      ),
      children: <Widget>[
        ListItem(
          key: _localKey,
          title: "切换组件词条语言",
          describe: "仅改变组件内部词条语言，Demo示例部分不支持",
          onPressed: () {
            SantoPopupListWindow.showPopListWindow(context, _localKey,
                data: ['中文', '英文', '德语'], onItemClick: (int index, item) {
              switch (index) {
                case 0:
                  SantoToast.showInCenter(
                      text: "已切换为英语词条（SantoResourceZh）。\n注意：组件传入的默认值会影响词条展示",
                      context: context);
                  ChangeLocalEvent.locale = Locale('zh', 'CN');
                  ChangeLocalEvent()..dispatch(context);
                  break;
                case 1:
                  SantoToast.showInCenter(
                      text: "已切换为英语词条（SantoResourceEn）。\n注意：组件传入的默认值会影响词条展示",
                      context: context);
                  ChangeLocalEvent.locale = Locale('en', 'US');
                  ChangeLocalEvent()..dispatch(context);
                  break;
                case 2:
                  SantoToast.showInCenter(
                      text: "已切换为德语词条（ResourceDe 部分）。\n注意：组件传入的默认值会影响词条展示",
                      context: context);
                  ChangeLocalEvent.locale = Locale('de', 'DE');
                  ChangeLocalEvent()..dispatch(context);
                  break;
              }
              return false;
            }, arrowOffset: 100);
          },
        ),
        ListItem(
          key: _themeKey,
          title: "主题定制切换",
          describe: "当切换为 Pad 主题样式请选用 Pad 设备查看",
          onPressed: () {
            SantoPopupListWindow.showPopListWindow(context, _themeKey,
                data: ['App 主题样式', 'Pad 主题样式'],
                onItemClick: (int index, item) {
              ExampleThemeConfig.setPadStyle(index == 1);
              ChangeThemeEvent()..dispatch(context);
              SantoToast.showInCenter(
                  text: index == 0 ? "已切换为 App 主题样式" : "已切换为 Pad 主题样式",
                  context: context);
              return false;
            }, arrowOffset: 100);
          },
        ),
        ListItem(
          title: "主题色",
          describe: "修改品牌色 brandPrimary，示例内容随之换色",
          rightWidget: const _BrandColorPreview(),
          onPressed: () => _showBrandColorPicker(context),
        ),
      ],
    );
  }

  void _showBrandColorPicker(BuildContext context) {
    _brandColorController.clear();

    showDialog(
      context: context,
      builder: (dialogContext) {
        void apply(Color color, String toastText) {
          ExampleThemeConfig.setBrandPrimary(color);
          Navigator.of(dialogContext).pop();
          ChangeThemeEvent()..dispatch(context);
          SantoToast.showInCenter(text: toastText, context: context);
        }

        void submitHex() {
          final String input = _brandColorController.text.trim();
          if (input.isEmpty) {
            apply(ExampleThemeConfig.defaultBrandPrimary, "已恢复默认主题色");
            return;
          }
          final Color? color = ExampleThemeConfig.parseHexColor(input);
          if (color == null) {
            SantoToast.showInCenter(
                text: "颜色值不合法，请输入如 #FF5722 或 #80FF5722",
                context: context);
            return;
          }
          apply(
              color,
              color == ExampleThemeConfig.defaultBrandPrimary
                  ? "已恢复默认主题色"
                  : "已切换主题色 ${input.startsWith('#') ? input : '#$input'}");
        }

        return SantoDialog(
          title: '主题色',
          closable: true,
          messageWidget: _BrandColorPicker(
            onPick: (Color color) => apply(
                color,
                color == ExampleThemeConfig.defaultBrandPrimary
                    ? "已恢复默认主题色"
                    : "已切换主题色"),
          ),
          showInput: true,
          inputHintText: '自定义颜色，如 #FF5722',
          inputController: _brandColorController,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[#0-9a-fA-F]')),
            LengthLimitingTextInputFormatter(9),
          ],
          okText: '确定',
          cancelText: '取消',
          dismissOnActionTap: false,
          onOk: submitHex,
          onCancel: () => Navigator.of(dialogContext).pop(),
        );
      },
    );
  }
}

/// 当前主题色色块
class _BrandColorPreview extends StatelessWidget {
  const _BrandColorPreview();

  @override
  Widget build(BuildContext context) {
    final Color dividerColor =
        SantoThemeConfigurator.instance.getConfig().commonConfig.dividerColorBase;
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: ExampleThemeConfig.currentBrandPrimary,
        shape: BoxShape.circle,
        border: Border.all(color: dividerColor),
      ),
    );
  }
}

/// 主题色选择面板
class _BrandColorPicker extends StatelessWidget {
  final ValueChanged<Color> onPick;

  const _BrandColorPicker({required this.onPick});

  @override
  Widget build(BuildContext context) {
    final Color current = ExampleThemeConfig.currentBrandPrimary;
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: [
        for (final Color color in ExampleThemeConfig.brandPrimaryOptions)
          _swatch(context, color, color == current),
      ],
    );
  }

  Widget _swatch(BuildContext context, Color color, bool selected) {
    return GestureDetector(
      onTap: () => onPick(color),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: selected
              ? Border.all(
                  color: ExampleThemeConfig.defaultBrandPrimary, width: 2)
              : null,
        ),
        child: selected
            ? const Icon(Icons.check, size: 20, color: Colors.white)
            : null,
      ),
    );
  }
}
