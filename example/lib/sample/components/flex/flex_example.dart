import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

class FlexExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: 'Flex 弹性布局',
      children: <Widget>[
        ExampleIntro('flex'),
        // ---------- SantoFlex(参考 antd) ----------
        SantoSection(
          title: '基础用法',
          description: '默认水平排列,align 为 null 时向上对齐(参考 antd 水平方向默认对齐行为)',
          child: SantoFlex(
            gapSize: SantoSpaceSize.small,
            children: [
              _FlexBox('Box 1'),
              _FlexBox('Box 2'),
              _FlexBox('Box 3'),
            ],
          ),
        ),
        SantoSection(
          title: '垂直排列',
          description: 'orientation 设为 vertical,align 为 null 时默认 stretch 拉伸填满交叉轴',
          child: SizedBox(
            height: 160,
            child: SantoFlex(
              orientation: SantoFlexOrientation.vertical,
              gapSize: SantoSpaceSize.small,
              children: [
                _FlexBox('Box 1'),
                _FlexBox('Box 2'),
                _FlexBox('Box 3'),
              ],
            ),
          ),
        ),
        SantoSection(
          title: '交叉轴对齐(align)',
          description: '垂直方向下 align 分别取 start / center / end,配合固定高度对比展示',
          child: SizedBox(
            height: 220,
            child: SantoFlex(
              orientation: SantoFlexOrientation.vertical,
              justify: MainAxisAlignment.spaceAround,
              children: [
                SantoFlex(
                  gapSize: SantoSpaceSize.small,
                  align: CrossAxisAlignment.start,
                  children: [
                    _FlexBox('start', height: 30),
                    _FlexBox('高 60', height: 60),
                  ],
                ),
                SantoFlex(
                  gapSize: SantoSpaceSize.small,
                  align: CrossAxisAlignment.center,
                  children: [
                    _FlexBox('center', height: 30),
                    _FlexBox('高 60', height: 60),
                  ],
                ),
                SantoFlex(
                  gapSize: SantoSpaceSize.small,
                  align: CrossAxisAlignment.end,
                  children: [
                    _FlexBox('end', height: 30),
                    _FlexBox('高 60', height: 60),
                  ],
                ),
              ],
            ),
          ),
        ),
        SantoSection(
          title: '间距(gapSize / gap)',
          description: 'gapSize 三档取主题间距 token(默认 10/15/20),gap 可传任意自定义值并优先于 gapSize',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoFlex(
                gapSize: SantoSpaceSize.small,
                children: [_FlexBox('small'), _FlexBox('10'), _FlexBox('10')],
              ),
              const SizedBox(height: 12),
              SantoFlex(
                gapSize: SantoSpaceSize.middle,
                children: [_FlexBox('middle'), _FlexBox('15'), _FlexBox('15')],
              ),
              const SizedBox(height: 12),
              SantoFlex(
                gapSize: SantoSpaceSize.large,
                children: [_FlexBox('large'), _FlexBox('20'), _FlexBox('20')],
              ),
              const SizedBox(height: 12),
              SantoFlex(
                gap: 32,
                children: [_FlexBox('gap: 32'), _FlexBox('自定义'), _FlexBox('自定义')],
              ),
            ],
          ),
        ),
        SantoSection(
          title: '换行(wrap)',
          description: 'wrap 设为 true 后超出换行,间距同时作用于横向与纵向',
          child: SantoFlex(
            wrap: true,
            gapSize: SantoSpaceSize.middle,
            children: List.generate(
              8,
              (index) => _FlexBox('Box ${index + 1}', width: 90),
            ),
          ),
        ),
        SantoSection(
          title: '主轴对齐(justify)',
          description: '水平方向分别取 center / spaceBetween / spaceAround / spaceEvenly',
          child: Column(
            children: [
              SantoFlex(
                justify: MainAxisAlignment.center,
                children: [_FlexBox('center'), _FlexBox('居中')],
              ),
              const SizedBox(height: 12),
              SantoFlex(
                justify: MainAxisAlignment.spaceBetween,
                children: [_FlexBox('spaceBetween'), _FlexBox('两端')],
              ),
              const SizedBox(height: 12),
              SantoFlex(
                justify: MainAxisAlignment.spaceAround,
                children: [_FlexBox('spaceAround'), _FlexBox('环绕')],
              ),
              const SizedBox(height: 12),
              SantoFlex(
                justify: MainAxisAlignment.spaceEvenly,
                children: [_FlexBox('spaceEvenly'), _FlexBox('均分')],
              ),
            ],
          ),
        ),
        SantoSection(
          title: '等分伸缩(flex)',
          description: 'flex 传给每个子元素 Expanded,三个元素等分剩余空间',
          child: SizedBox(
            height: 48,
            child: SantoFlex(
              gapSize: SantoSpaceSize.small,
              flex: 1,
              children: [
                _FlexBox('1/3'),
                _FlexBox('1/3'),
                _FlexBox('1/3'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _FlexBox extends StatelessWidget {
  final String label;
  final double? width;
  final double height;

  const _FlexBox(this.label, {this.width, this.height = 44});

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: commonConfig.brandPrimary,
        borderRadius: BorderRadius.circular(commonConfig.radiusSm),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }
}
