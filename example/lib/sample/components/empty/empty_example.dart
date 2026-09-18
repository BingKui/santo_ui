import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

/// Empty 空状态示例
///
/// 排版参考其他组件示例：每个演示点一个 SantoSection
class EmptyExample extends StatelessWidget {
  const EmptyExample({Key? key}) : super(key: key);

  /// 居中类演示的基础容器高度(随字体缩放放大),便于观察 isCenterVertical 的居中效果
  static const double _centerDemoHeight = 320;

  /// 居中类演示容器:高度随字体缩放放大,避免放大字体时内容溢出
  Widget _centerDemoBox(BuildContext context, Widget child) {
    final double scale = MediaQuery.textScalerOf(context).scale(1.0);
    return SizedBox(height: _centerDemoHeight * scale, child: child);
  }

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: 'Empty 空状态',
      children: <Widget>[
        ExampleIntro('empty'),
        _buildErrorWithActionSection(context),
        _buildErrorCenterSection(context),
        _buildErrorDefaultSection(context),
        _buildLargeModuleSection(context),
        _buildSingleButtonSection(context),
        _buildDoubleButtonSection(context),
        _buildSmallModuleSection(context),
      ],
    );
  }

  /// 异常信息 + 操作
  Widget _buildErrorWithActionSection(BuildContext context) {
    return SantoSection(
      title: '异常信息+操作',
      description: 'operateAreaType 为 textButton 时展示文字操作，action 回调返回按钮下标',
      child: _centerDemoBox(
        context,
        SantoEmpty(
          img: Image.asset(
            'assets/image/content_failed.png',
            scale: 3.0,
          ),
          isCenterVertical: true,
          title: '获取数据失败，请重试',
          operateTexts: <String>['请点击页面重试'],
          operateAreaType: OperateAreaType.textButton,
          action: (index) {
            SantoToast.show('获取数据失败，请重试', context);
          },
        ),
      ),
    );
  }

  /// 异常信息居中展示
  Widget _buildErrorCenterSection(BuildContext context) {
    return SantoSection(
      title: '异常信息居中展示',
      description: 'isCenterVertical 为 true 时内容在可用空间内垂直居中',
      child: _centerDemoBox(
        context,
        SantoEmpty(
          isCenterVertical: true,
          img: Image.asset(
            'assets/image/no_data.png',
            scale: 3.0,
          ),
          title: SantoIntl.of(context).localizedResource.noDataTip,
        ),
      ),
    );
  }

  /// 异常信息默认展示
  Widget _buildErrorDefaultSection(BuildContext context) {
    return SantoSection(
      title: '异常信息默认展示',
      description: '不设置 isCenterVertical 时按内容高度从上往下排列',
      child: SantoEmpty(
        img: Image.asset(
          'assets/image/network_error.png',
          scale: 3.0,
        ),
        title: '网络数据异常',
      ),
    );
  }

  /// 大模块空态
  Widget _buildLargeModuleSection(BuildContext context) {
    return SantoSection(
      title: '大模块空态',
      description: '只传 content 时展示纯文字空态',
      child: SantoEmpty(
        img: Image.asset(
          'assets/image/no_data.png',
          scale: 3.0,
        ),
        content: '您的门店暂无用户',
      ),
    );
  }

  /// 单按钮效果
  Widget _buildSingleButtonSection(BuildContext context) {
    return SantoSection(
      title: '单按钮效果',
      description: 'operateAreaType 为 singleButton 时展示一个主操作按钮',
      child: SantoEmpty(
        img: Image.asset(
          'assets/image/no_data.png',
          scale: 3.0,
        ),
        title: '这是副标题内容这是副标题内容这是副标',
        content: '您的门店暂无用户',
        operateAreaType: OperateAreaType.singleButton,
        operateTexts: ['切换账号'],
        action: (index) {
          SantoToast.show('第$index个按钮被点击了', context);
        },
      ),
    );
  }

  /// 双按钮效果
  Widget _buildDoubleButtonSection(BuildContext context) {
    return SantoSection(
      title: '双按钮效果',
      description: 'operateAreaType 为 doubleButton 时展示主次两个按钮',
      child: SantoEmpty(
        img: Image.asset(
          'assets/image/no_data.png',
          scale: 3.0,
        ),
        title: '暂无',
        content: '您还没有在维护的信息哦',
        operateAreaType: OperateAreaType.doubleButton,
        operateTexts: ['去添加', '去修改'],
        action: (index) {
          SantoToast.show('第$index个按钮被点击了', context);
        },
      ),
    );
  }

  /// 小模块空态
  Widget _buildSmallModuleSection(BuildContext context) {
    return SantoSection(
      title: '小模块空态',
      description: '不传 img 时只展示文字，适用于卡片内的小面积空态',
      child: SantoEmpty(
        content: '您的门店暂无用户',
      ),
    );
  }
}
