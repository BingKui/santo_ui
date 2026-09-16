"""移除更多菜单的编辑操作,仅保留标题。"""

p = 'lib/src/components/menu_bar/santo_menu_bar_more_menu.dart'
s = open(p).read()

# 文档注释示例
s = s.replace("""///     actionText: '编辑',
""", "")

# 字段
s = s.replace("""  /// 右上角操作文案(如"编辑")
  final String? actionText;

  /// 右上角操作点击回调
  final VoidCallback? onActionTap;

""", "")

# 构造参数
s = s.replace("""    this.actionText,
    this.onActionTap,
""", "")

# show 参数
s = s.replace("""    String? actionText,
    VoidCallback? onActionTap,
""", "")

# show 内构造调用
s = s.replace("""        actionText: actionText,
        onActionTap: onActionTap,
""", "")

# copyWith 内
s = s.replace("""      actionText: actionText,
      onActionTap: onActionTap,
""", "")

# 头部操作控件移除
s = s.replace("""                        if (widget.actionText != null)
                          GestureDetector(
                            onTap: () {
                              widget.onActionTap?.call();
                              Navigator.of(context).pop();
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                widget.actionText!,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: _commonConfig.brandPrimary,
                                ),
                              ),
                            ),
                          ),
""", "")

open(p, 'w').write(s)

# 示例:去掉编辑配置
p = 'example/lib/sample/components/menu_bar/menu_bar_controlled_example.dart'
s = open(p).read()
s = s.replace("""          actionText: '编辑',
          onActionTap: () => SantoToast.show('点击了编辑', context),
""", "")
open(p, 'w').write(s)

# 测试:去掉编辑配置
p = 'test/santo_menu_bar_test.dart'
s = open(p).read()
s = s.replace("""            actionText: '编辑',
""", "")
open(p, 'w').write(s)
print('done')
