"""重写 santo_swipe_cell.dart 的 build 方法(修复括号错乱 + cell 撑满整宽)。"""

NEW_TAIL = '''
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      _cellWidth = constraints.maxWidth;
      final leftPanel = widget.left;
      final rightPanel = widget.right;

      final leftActions = leftPanel == null
          ? null
          : Row(
              children: leftPanel.actions
                  .map((a) => _buildAction(a, SantoSwipeDirection.left))
                  .toList(),
            );

      final rightActions = rightPanel == null
          ? null
          : Row(
              children: rightPanel.actions
                  .map((a) => _buildAction(a, SantoSwipeDirection.right))
                  .toList(),
            );

      return GestureDetector(
        onHorizontalDragStart: widget.disabled ? null : _onDragStart,
        onHorizontalDragUpdate: widget.disabled ? null : _onDragUpdate,
        onHorizontalDragEnd: widget.disabled ? null : _onDragEnd,
        child: ClipRect(
          child: Stack(
            children: [
              // 操作面板背景
              Positioned.fill(
                child: Stack(
                  children: [
                    if (leftActions != null)
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        child: leftActions,
                      ),
                    if (rightActions != null)
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: rightActions,
                      ),
                  ],
                ),
              ),
              // 前景内容
              Transform.translate(
                offset: Offset(_dragOffset, 0),
                child: SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () {
                      if (_openDirection != null) {
                        _close();
                      } else if (widget.closeWhenTapped &&
                          widget.groupTag != null) {
                        _closeGroup();
                      }
                    },
                    child: widget.cell,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

/// 滑动单元格控制器,用于外部关闭当前单元格
class SantoSwipeCellController {
  final Set<_SantoSwipeCellState> _states = {};

  void _attach(_SantoSwipeCellState state) {
    _states.add(state);
  }

  void _detach(_SantoSwipeCellState state) {
    _states.remove(state);
  }

  /// 关闭已打开的单元格
  void close() {
    for (final state in _states) {
      state._close(notify: false);
    }
  }
}
'''

p = 'lib/src/components/swipe_cell/santo_swipe_cell.dart'
src = open(p).read()
build_idx = src.index('  Widget build(BuildContext context) {')
# 找 build 方法所在行的行首
line_start = src.rfind('\n', 0, build_idx) + 1
open(p, 'w').write(src[:line_start] + NEW_TAIL.lstrip('\n'))
print('rewritten tail from line', src[:line_start].count('\n') + 1)
