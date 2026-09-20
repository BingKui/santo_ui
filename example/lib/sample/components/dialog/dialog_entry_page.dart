import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 弹窗示例,分组与 antd Modal 文档保持一致
///
/// [SantoDialog] 是库内唯一的弹窗入口:图标、标题、辅助文案、输入框、底部两个按钮、
/// 右上角关闭六项全部通过参数配置;强提示、长文本、单选列表、多选列表、分享渠道
/// 五种业务形态由命名构造承接。
class DialogEntryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: 'Dialog 对话框',
      children: <Widget>[
        ExampleIntro('dialog'),
        _buildBasicSection(context),
        _buildIconSection(context),
        _buildMessageSection(context),
        _buildInputSection(context),
        _buildWarningSection(context),
        _buildClosableSection(context),
        _buildFooterSection(context),
        _buildAlertSection(context),
        _buildPresetSection(context),
        _buildRichTextSection(context),
        _buildSingleSelectSection(context),
        _buildMultiSelectSection(context),
        _buildShareSection(context),
        _buildTagSection(context),
      ],
    );
  }

  /// 基础用法:标题 + 辅助文案 + 两个按钮
  Widget _buildBasicSection(BuildContext context) {
    return SantoSection(
      title: '基础用法',
      description: '不传按钮文案则没有底部按钮;两个按钮时左侧为取消(主色浅填充),右侧为确定(主色实心)',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _trigger(
            '标题 + 辅助文案 + 双按钮',
            () => _show(
              context,
              SantoDialog(
                title: '确定关注我吗?',
                message: '辅助内容信息辅助内容信息辅助内容信息',
                cancelText: '取消',
                okText: '确定',
                onOk: () => _toast(context, '点击了确定'),
                onCancel: () => _toast(context, '点击了取消'),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _trigger(
            '无标题 + 单按钮',
            () => _show(
              context,
              SantoDialog(
                message: '辅助内容信息辅助内容信息辅助内容信息',
                okText: '知道了',
                onOk: () => _toast(context, '点击了知道了'),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _trigger(
            '无标题 + 无按钮',
            () => _show(
              context,
              SantoDialog(message: '辅助内容信息辅助内容信息辅助内容信息'),
            ),
          ),
        ],
      ),
    );
  }

  /// 图标
  Widget _buildIconSection(BuildContext context) {
    return SantoSection(
      title: '图标',
      description: 'iconType 取内置的提示(info)/警示(warning)/失败(error)/成功(success)图标,'
          '统一是 SantoIcon 的 solid 实心图标并取对应语义色;需要线图标或别的图形时用 icon 传 widget',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: <Widget>[
          _trigger(
            '提示图标',
            () => _show(
              context,
              SantoDialog(
                iconType: SantoDialogIconType.info,
                title: '恭喜你完成填写',
                message: '辅助内容信息辅助内容信息',
                okText: '确定',
              ),
            ),
          ),
          _trigger(
            '警示图标',
            () => _show(
              context,
              SantoDialog(
                iconType: SantoDialogIconType.warning,
                title: '存在风险',
                message: '辅助内容信息辅助内容信息',
                okText: '确定',
              ),
            ),
          ),
          _trigger(
            '失败图标',
            () => _show(
              context,
              SantoDialog(
                iconType: SantoDialogIconType.error,
                title: '提交失败',
                message: '辅助内容信息辅助内容信息',
                okText: '确定',
              ),
            ),
          ),
          _trigger(
            '成功图标',
            () => _show(
              context,
              SantoDialog(
                iconType: SantoDialogIconType.success,
                title: '提交成功',
                message: '辅助内容信息辅助内容信息',
                okText: '确定',
              ),
            ),
          ),
          _trigger(
            '自定义图标',
            () => _show(
              context,
              SantoDialog(
                icon: const Icon(Icons.savings, size: 36, color: Color(0xFF1677FF)),
                title: '自定义图标',
                message: 'icon 传入任意 widget,尺寸固定为 36',
                okText: '确定',
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 辅助文案
  Widget _buildMessageSection(BuildContext context) {
    return SantoSection(
      title: '辅助文案',
      description: 'message 是纯文案,富文本或自定义内容用 messageWidget;'
          'messageMaxHeight 限定文案区最大高度,超出后文案区内部滚动',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: <Widget>[
          _trigger(
            '富文本文案',
            () => _show(
              context,
              SantoDialog(
                title: '富文本辅助文案',
                messageWidget: SantoCSS2Text.toTextView(
                  "这是一条使用标签修改文字颜色的示例<font color = '#8ac6d1'>我是带颜色的文字</font>，"
                  "这是颜色标签后边的文字",
                  linksCallback: (String? text, String? linkUrl) =>
                      _toast(context, '$text clicked! Url is $linkUrl'),
                ),
                cancelText: '取消',
                okText: '确定',
              ),
            ),
          ),
          _trigger(
            '超长文案',
            () => _show(
              context,
              SantoDialog(
                title: '超长文案',
                message: _longText,
                messageMaxHeight: 300,
                okText: '知道了',
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 输入框
  Widget _buildInputSection(BuildContext context) {
    return SantoSection(
      title: '输入框',
      description: 'showInput 展示内置的 SantoInputText,input* 一组参数透传给它;'
          '确定时从 inputController 取值,输入框在键盘弹起时不会被遮挡',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: <Widget>[
          _trigger('单行输入', () {
            final TextEditingController controller = TextEditingController();
            _show(
              context,
              SantoDialog(
                title: '拒绝理由',
                message: '请输入拒绝理由',
                showInput: true,
                inputHintText: '请输入',
                inputController: controller,
                inputMaxLength: 20,
                inputAutoFocus: true,
                cancelText: '取消',
                okText: '确定',
                onOk: () => _toast(context, '输入内容:${controller.text}'),
              ),
            );
          }),
          _trigger('多行输入', () {
            final TextEditingController controller = TextEditingController();
            _show(
              context,
              SantoDialog(
                title: '备注',
                showInput: true,
                inputHintText: '最多 20 个字符',
                inputController: controller,
                inputMaxLength: 20,
                inputMinLines: 2,
                inputMaxLines: 3,
                cancelText: '取消',
                okText: '确定',
                onOk: () => _toast(context, '输入内容:${controller.text}'),
              ),
            );
          }),
          _trigger('仅数字', () {
            final TextEditingController controller = TextEditingController();
            _show(
              context,
              SantoDialog(
                title: '仅可输入数字',
                showInput: true,
                inputHintText: '请输入数字',
                inputController: controller,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                cancelText: '取消',
                okText: '确定',
                onOk: () => _toast(context, '输入内容:${controller.text}'),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// 警示文案
  Widget _buildWarningSection(BuildContext context) {
    return SantoSection(
      title: '警示文案',
      description: 'warningText 用主题警示色展示在内容下方;需要勾选协议一类的交互用 warningWidget',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: <Widget>[
          _trigger(
            '警示文案',
            () => _show(
              context,
              SantoDialog(
                title: '删除后不可恢复',
                message: '辅助内容信息辅助内容信息',
                warningText: '警示文案',
                cancelText: '取消',
                okText: '确定',
              ),
            ),
          ),
          _trigger('自定义警示 UI', () {
            bool agreed = false;
            _show(
              context,
              StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return SantoDialog(
                    title: '服务协议',
                    message: '辅助内容信息辅助内容信息',
                    warningWidget: Row(
                      children: <Widget>[
                        Checkbox(
                          value: agreed,
                          onChanged: (bool? value) =>
                              setState(() => agreed = value ?? false),
                        ),
                        const Expanded(child: Text('已阅读并同意《服务协议》')),
                      ],
                    ),
                    cancelText: '取消',
                    okText: '确定',
                    onOk: () => _toast(context, '同意状态:$agreed'),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  /// 右上角关闭
  Widget _buildClosableSection(BuildContext context) {
    return SantoSection(
      title: '右上角关闭',
      description: 'closable 在右上角展示关闭图标,点击先关闭弹窗再执行 onClose',
      child: _trigger(
        '带关闭图标',
        () => _show(
          context,
          SantoDialog(
            title: '可以关掉的弹窗',
            message: '右上角关闭图标与底部取消按钮都会关闭弹窗',
            closable: true,
            onClose: () => _toast(context, '点击了右上角关闭'),
            cancelText: '取消',
            okText: '确定',
          ),
        ),
      ),
    );
  }

  /// 自定义底部
  Widget _buildFooterSection(BuildContext context) {
    return SantoSection(
      title: '自定义底部',
      description: 'footer 完全接管底部区域,两个按钮以上的组合由调用方用 Row / Column 拼装',
      child: _trigger(
        '三个按钮',
        () => _show(
          context,
          SantoDialog(
            title: '请选择处理方式',
            message: '辅助内容信息辅助内容信息',
            footer: Column(
              children: <Widget>[
                SantoButton(
                  text: '选项一',
                  type: SantoButtonType.primary,
                  size: SantoButtonSize.large,
                  block: true,
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(height: 12),
                SantoButton(
                  text: '选项二',
                  type: SantoButtonType.normal,
                  size: SantoButtonSize.large,
                  block: true,
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(height: 12),
                SantoButton(
                  text: '选项三',
                  type: SantoButtonType.normal,
                  size: SantoButtonSize.large,
                  block: true,
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 强提示弹窗
  Widget _buildAlertSection(BuildContext context) {
    return SantoSection(
      title: '强提示弹窗',
      description: 'SantoDialog.alert 纵向排布主次按钮:主按钮整行实心,次要按钮为主色文字链',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: <Widget>[
          _trigger(
            '单按钮',
            () => _show(
              context,
              SantoDialog.alert(
                iconType: SantoDialogIconType.warning,
                title: '强提示文案',
                message: '这里是文案这里是文案这里是文案',
                mainButtonText: '我知道了',
                onMainButton: () => _toast(context, '点击了主要按钮'),
              ),
            ),
          ),
          _trigger(
            '主次按钮',
            () => _show(
              context,
              SantoDialog.alert(
                title: '强提示文案',
                message: '这里是文案这里是文案这里是文案',
                mainButtonText: '主要按钮',
                secondaryButtonText: '次要信息可点击',
                onMainButton: () => _toast(context, '点击了主要按钮'),
                onSecondaryButton: () => _toast(context, '点击了次要按钮'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 语义弹窗
  Widget _buildPresetSection(BuildContext context) {
    return SantoSection(
      title: '语义弹窗',
      description: 'confirm / info / success / warning / error 是静态方法,'
          '省去自己 new 与 pop;confirm 返回 true(确定)/ false(取消)/ null(点击蒙层)',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: <Widget>[
          _trigger('confirm', () async {
            final bool? result = await SantoDialog.confirm(
              context,
              title: '确定删除吗?',
              message: '删除后不可恢复',
              onOk: () => _toast(context, '点击了确定'),
            );
            _toast(context, 'confirm 结果:$result');
          }),
          _trigger(
            'info',
            () => SantoDialog.info(context,
                title: '提示', message: '辅助内容信息辅助内容信息'),
          ),
          _trigger(
            'success',
            () => SantoDialog.success(context,
                title: '提交成功', message: '辅助内容信息辅助内容信息'),
          ),
          _trigger(
            'warning',
            () => SantoDialog.warning(context,
                title: '存在风险', message: '辅助内容信息辅助内容信息'),
          ),
          _trigger(
            'error',
            () => SantoDialog.error(context,
                title: '提交失败', message: '辅助内容信息辅助内容信息'),
          ),
        ],
      ),
    );
  }

  /// 长文本
  Widget _buildRichTextSection(BuildContext context) {
    return SantoSection(
      title: '长文本',
      description: 'SantoDialog.richText 的内容走 CSS2 富文本解析,超过 220 高可滚动;'
          'isShowOperateWidget 为 false 时不展示提交按钮',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: <Widget>[
          _trigger(
            '长文本 + 提交',
            () => _show(
              context,
              SantoDialog.richText(
                title: '服务协议',
                contentText: '纯文本内容纯文本内容纯文本内容纯文本内容纯文本内容纯文本内容纯文本内容'
                    '纯文本内容纯文本内容纯文本内容纯文本内容纯文本内容纯文本内容纯文本内容'
                    '纯文本内容纯文本内容纯文本内容纯文本内容纯文本内容纯文本内容纯文本内容'
                    '纯文本内容纯文本内容纯文本内容纯文本内容纯文本内容纯文本内容纯文本内容',
                submitText: '提交',
                onSubmit: () => _toast(context, '点击了提交'),
              ),
            ),
          ),
          _trigger(
            '含富文本链接',
            () => _show(
              context,
              SantoDialog.richText(
                title: '服务协议',
                contentText: '纯文本内容<font color = \'#008886\'>带颜色的文字</font>'
                    "纯文本内容<a href='www.baidu.com'>XXXXX</a>纯文本内容",
                linksCallback: (String? text, String? url) =>
                    _toast(context, '$text 的链接是 $url'),
                submitText: '提交',
                onSubmit: () => _toast(context, '点击了提交'),
              ),
            ),
          ),
          _trigger(
            '无提交按钮',
            () => _show(
              context,
              SantoDialog.richText(
                title: '服务协议',
                contentText: '纯文本内容纯文本内容纯文本内容纯文本内容纯文本内容'
                    '纯文本内容纯文本内容纯文本内容纯文本内容纯文本内容',
                isShowOperateWidget: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 单选列表
  Widget _buildSingleSelectSection(BuildContext context) {
    return SantoSection(
      title: '单选列表',
      description: 'SantoDialog.singleSelect 的选项为文案列表,选中项加粗并取主题色;'
          'isCustomFollowScroll 为 false 时列表自身在最高 300 内滚动',
      child: _trigger(
        '单选 + 提交',
        () => _show(
          context,
          SantoDialog.singleSelect(
            title: '请选择无效客源原因',
            message: '辅助内容信息辅助内容信息',
            conditions: _reasons,
            checkedItem: _reasons.first,
            submitText: '提交',
            onSubmit: (String? value) => _toast(context, '提交:$value'),
          ),
        ),
      ),
    );
  }

  /// 多选列表
  Widget _buildMultiSelectSection(BuildContext context) {
    return SantoSection(
      title: '多选列表',
      description: 'SantoDialog.multiSelect 的 onSubmit 返回 false 时不关闭弹窗,'
          '需要额外输入时把输入框放到 customWidget 里',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: <Widget>[
          _trigger(
            '多选 + 提交',
            () => _show(
              context,
              SantoDialog.multiSelect(
                title: '请选择放弃原因',
                conditions: _multiItems(),
                submitText: '提交',
                onSubmit: (List<MultiSelectItem> items) {
                  _toast(context, items.map((e) => e.content).join(' '));
                  return true;
                },
              ),
            ),
          ),
          _trigger(
            '多选 + 自定义输入',
            () => _show(
              context,
              SantoDialog.multiSelect(
                title: '请选择放弃原因',
                message: '选择放弃原因(多选)',
                conditions: _multiItems(),
                isCustomFollowScroll: false,
                customWidget: const SizedBox(
                  height: 44,
                  child: Text('这里可以放自定义输入框等内容'),
                ),
                submitText: '提交',
                onSubmit: (List<MultiSelectItem> items) {
                  _toast(context, items.map((e) => e.content).join(' '));
                  return true;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 分享渠道
  Widget _buildShareSection(BuildContext context) {
    return SantoSection(
      title: '分享渠道',
      description: 'SantoDialog.share 按渠道列表铺开分享入口,自定义渠道的名称与图标'
          '由 getCustomChannelTitle / getCustomChannelWidget 按下标提供;'
          '底部面板形态的分享请用 SantoShare',
      child: _trigger(
        '五个渠道',
        () => _show(
          context,
          SantoDialog.share(
            title: '分享到',
            message: '辅助内容信息辅助内容信息',
            shareChannels: const <int>[
              SantoShareItemConstants.shareWeiXin,
              SantoShareItemConstants.shareLink,
              SantoShareItemConstants.shareCustom,
              SantoShareItemConstants.shareQQ,
              SantoShareItemConstants.shareFriend,
            ],
            getCustomChannelTitle: (int index) =>
                index == 2 ? '自定义' : null,
            getCustomChannelWidget: (int index) => index == 2
                ? const Icon(Icons.link, size: 39)
                : null,
            onChannelTap: (int channel, int index) =>
                _toast(context, 'channel:$channel, index:$index'),
          ),
        ),
      ),
    );
  }

  /// 按 tag 关闭
  Widget _buildTagSection(BuildContext context) {
    return SantoSection(
      title: '按 tag 关闭',
      description: 'SantoDialog.show 按 tag 记录路由,由 SantoDialog.dismiss 精确关闭,'
          '不会误关页面上其他弹窗;同一个 tag 下可叠加多个弹窗,只关最后入栈的那个',
      child: _trigger('打开两个浮层并定时关闭', () {
        SantoDialog.show(
          context: context,
          tag: 'AA',
          builder: (BuildContext dialogContext) =>
              const SantoLoading(tip: 'dialog AA'),
        ).then((_) => _toast(context, 'AA 已关闭'));
        SantoDialog.show(
          context: context,
          builder: (BuildContext dialogContext) =>
              const SantoLoading(tip: 'dialog BB'),
        ).then((_) => _toast(context, 'BB 已关闭'));

        Future<void>.delayed(const Duration(seconds: 3)).then((_) {
          SantoDialog.dismiss(context: context, tag: 'AA', result: 'AA closed');
        });
        Future<void>.delayed(const Duration(seconds: 6)).then((_) {
          SantoDialog.dismiss(context: context, result: 'BB closed');
        });
      }),
    );
  }

  /// 统一的触发按钮
  Widget _trigger(String text, VoidCallback onTap) {
    return SantoButton(
      text: text,
      type: SantoButtonType.primary,
      onTap: onTap,
    );
  }

  void _show(BuildContext context, Widget dialog) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) => dialog,
    );
  }

  void _toast(BuildContext context, String message) {
    SantoToast.show(message, context);
  }
}

/// 单选列表的候选原因
const List<String> _reasons = <String>[
  '感兴趣待跟进',
  '感兴趣但对本商圈没兴趣',
  '接通后挂断/不感兴趣',
  '未接通',
  '号码错误',
];

List<MultiSelectItem> _multiItems() {
  return <MultiSelectItem>[
    MultiSelectItem('100', '感兴趣待跟进'),
    MultiSelectItem('101', '感兴趣但对本商圈没兴趣', isChecked: true),
    MultiSelectItem('102', '接通后挂断/不感兴趣', isChecked: true),
    MultiSelectItem('103', '未接通'),
    MultiSelectItem('104', '号码错误'),
  ];
}

/// 超长文案示例
const String _longText = '辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息'
    '辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息'
    '辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息'
    '辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息'
    '辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息'
    '辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息'
    '辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息'
    '辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息'
    '辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息'
    '辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息'
    '辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息辅助内容信息';
