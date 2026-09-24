import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

class GridExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: 'Grid 栅格',
      children: <Widget>[
        ExampleIntro('grid'),
        // ---------- SantoRow / SantoCol(参考 antd) ----------
        SantoSection(
          title: '基础用法',
          description: '24 等分栅格,span 总和不超过 24; span 为 0 时不渲染',
          child: Column(
            children: [
              SantoRow(children: [SantoCol(span: 24, child: _GridBox('span: 24'))]),
              const SizedBox(height: 12),
              SantoRow(children: [
                SantoCol(span: 12, child: _GridBox('span: 12')),
                SantoCol(span: 12, child: _GridBox('span: 12')),
              ]),
              const SizedBox(height: 12),
              SantoRow(children: [
                SantoCol(span: 8, child: _GridBox('8')),
                SantoCol(span: 8, child: _GridBox('8')),
                SantoCol(span: 8, child: _GridBox('8')),
              ]),
              const SizedBox(height: 12),
              SantoRow(children: [
                SantoCol(span: 6, child: _GridBox('6')),
                SantoCol(span: 6, child: _GridBox('6')),
                SantoCol(span: 6, child: _GridBox('6')),
                SantoCol(span: 6, child: _GridBox('6')),
              ]),
              const SizedBox(height: 12),
              SantoRow(children: [
                SantoCol(span: 8, child: _GridBox('8')),
                SantoCol(span: 8, child: _GridBox('8')),
                SantoCol(span: 0, child: _GridBox('span: 0 不渲染')),
                SantoCol(span: 8, child: _GridBox('8')),
              ]),
            ],
          ),
        ),
        SantoSection(
          title: '区块间隔(gutter)',
          description: 'gutter 控制列间距(相邻列间距 = gutter,首尾列与边缘齐平);span 超出 24 自动换行,verticalGutter 控制行间距',
          child: SantoRow(
            gutter: 15,
            verticalGutter: 15,
            children: [
              SantoCol(span: 12, child: _GridBox('span: 12')),
              SantoCol(span: 12, child: _GridBox('span: 12')),
              SantoCol(span: 8, child: _GridBox('8')),
              SantoCol(span: 8, child: _GridBox('8')),
              SantoCol(span: 8, child: _GridBox('8')),
            ],
          ),
        ),
        SantoSection(
          title: '左右偏移(offset)',
          description: 'offset 向右偏移指定栅格数,偏移量参与换行计算',
          child: Column(
            children: [
              SantoRow(children: [
                SantoCol(span: 8, child: _GridBox('span: 8')),
                SantoCol(span: 8, offset: 8, child: _GridBox('offset: 8')),
              ]),
              const SizedBox(height: 12),
              SantoRow(children: [
                SantoCol(span: 6, offset: 6, child: _GridBox('offset: 6')),
                SantoCol(span: 6, offset: 6, child: _GridBox('offset: 6')),
              ]),
              const SizedBox(height: 12),
              SantoRow(children: [
                SantoCol(span: 12, offset: 6, child: _GridBox('居中: span 12 + offset 6')),
              ]),
            ],
          ),
        ),
        SantoSection(
          title: '排序(order)',
          description: 'order 小的在前,相同 order 保持声明顺序;不改变 DOM 顺序只改变展示顺序',
          child: SantoRow(
            children: [
              SantoCol(span: 8, order: 3, child: _GridBox('order: 3', muted: true)),
              SantoCol(span: 8, order: 1, child: _GridBox('order: 1')),
              SantoCol(span: 8, order: 2, child: _GridBox('order: 2')),
            ],
          ),
        ),
        SantoSection(
          title: '视觉位移(push / pull)',
          description: 'push 右移 / pull 左移指定栅格数,仅视觉位移,不影响兄弟元素布局',
          child: SantoRow(
            children: [
              SantoCol(span: 18, push: 6, child: _GridBox('span: 18 + push: 6')),
              SantoCol(span: 6, pull: 18, child: _GridBox('pull: 18', muted: true)),
            ],
          ),
        ),
        SantoSection(
          title: '伸缩(flex)',
          description: 'flex 列以 Expanded 参与布局并忽略 span;可与固定 span 列混排',
          child: Column(
            children: [
              SantoRow(children: [
                SantoCol(flex: 2, child: _GridBox('flex: 2')),
                SantoCol(flex: 1, child: _GridBox('flex: 1')),
              ]),
              const SizedBox(height: 12),
              SantoRow(children: [
                SantoCol(flex: 1, child: _GridBox('flex: 1')),
                SantoCol(span: 8, child: _GridBox('span: 8')),
              ]),
            ],
          ),
        ),
        SantoSection(
          title: '对齐(align / justify)',
          description: 'align 控制垂直对齐(top/middle/bottom/stretch),justify 控制水平排布',
          child: Column(
            children: [
              SantoRow(
                align: CrossAxisAlignment.start,
                children: [
                  SantoCol(span: 8, child: _GridBox('top', height: 60)),
                  SantoCol(span: 8, child: _GridBox('align: start', height: 30)),
                ],
              ),
              const SizedBox(height: 12),
              SantoRow(
                align: CrossAxisAlignment.center,
                children: [
                  SantoCol(span: 8, child: _GridBox('middle', height: 60)),
                  SantoCol(span: 8, child: _GridBox('align: center', height: 30)),
                ],
              ),
              const SizedBox(height: 12),
              SantoRow(
                align: CrossAxisAlignment.end,
                children: [
                  SantoCol(span: 8, child: _GridBox('bottom', height: 60)),
                  SantoCol(span: 8, child: _GridBox('align: end', height: 30)),
                ],
              ),
              const SizedBox(height: 12),
              SantoRow(
                justify: MainAxisAlignment.spaceBetween,
                children: [
                  SantoCol(span: 6, child: _GridBox('6')),
                  SantoCol(span: 6, child: _GridBox('6')),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _GridBox extends StatelessWidget {
  final String label;
  final double height;
  final bool muted;

  const _GridBox(this.label, {this.height = 48, this.muted = false});

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return Container(
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: muted ? commonConfig.brandPrimaryBg : commonConfig.brandPrimary,
        borderRadius: BorderRadius.circular(commonConfig.radiusSm),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: muted ? commonConfig.brandPrimary : Colors.white,
          fontSize: 13,
        ),
      ),
    );
  }
}
