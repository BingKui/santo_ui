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
        _buildLoadFailSection(context),
        _buildOfflineSection(context),
        _buildListEmptySection(context),
        _buildImageTypesSection(),
        _buildSingleButtonSection(context),
        _buildDoubleButtonSection(context),
        _buildSmallModuleSection(context),
        _buildCustomImageSection(context),
      ],
    );
  }

  /// 加载失败 + 操作
  Widget _buildLoadFailSection(BuildContext context) {
    return SantoSection(
      title: '加载失败+操作',
      description: 'imageType 为 loadFail 时展示加载失败插画，operateAreaType 为 textButton 时展示文字操作',
      child: _centerDemoBox(
        context,
        SantoEmpty(
          imageType: SantoEmptyImageType.loadFail,
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

  /// 网络未连接居中展示
  Widget _buildOfflineSection(BuildContext context) {
    return SantoSection(
      title: '网络未连接居中展示',
      description: 'imageType 为 offline 时展示断网插画，isCenterVertical 为 true 时内容在可用空间内垂直居中',
      child: _centerDemoBox(
        context,
        SantoEmpty(
          isCenterVertical: true,
          imageType: SantoEmptyImageType.offline,
          title: SantoIntl.of(context).localizedResource.netErrorAndRetryLater,
        ),
      ),
    );
  }

  /// 列表为空默认展示
  Widget _buildListEmptySection(BuildContext context) {
    return SantoSection(
      title: '列表为空默认展示',
      description: 'imageType 为 listEmpty 时展示列表为空插画，不设置 isCenterVertical 时按内容高度从上往下排列',
      child: SantoEmpty(
        imageType: SantoEmptyImageType.listEmpty,
        title: '暂无数据',
      ),
    );
  }

  /// 全部内置插画
  Widget _buildImageTypesSection() {
    return SantoSection(
      title: '全部内置插画',
      description:
          'imageType 对应 assets/empty 下的 12 张 SVG 插画，配置不同 imageType 展示不同图片',
      child: Column(
        children: <Widget>[
          for (final row in _typeRows)
            Row(
              children: <Widget>[
                for (final (label, type) in row)
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        SantoEmpty(imageType: type),
                        const SizedBox(height: 8),
                        Text(label, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  /// 12 张插画按每行 4 个分组
  static List<List<(String, SantoEmptyImageType)>> get _typeRows {
    const types = <(String, SantoEmptyImageType)>[
      ('404', SantoEmptyImageType.notFound),
      ('内容为空', SantoEmptyImageType.contentEmpty),
      ('导入加载中', SantoEmptyImageType.importLoading),
      ('列表为空', SantoEmptyImageType.listEmpty),
      ('加载失败', SantoEmptyImageType.loadFail),
      ('无访问权限', SantoEmptyImageType.noAccess),
      ('未开通支付方式', SantoEmptyImageType.notOpenPayType),
      ('网络未连接', SantoEmptyImageType.offline),
      ('订单为空', SantoEmptyImageType.orderEmpty),
      ('搜索无结果', SantoEmptyImageType.searchEmpty),
      ('账号未绑定', SantoEmptyImageType.unbindAccount),
      ('敬请期待', SantoEmptyImageType.wait),
    ];
    return [
      for (int i = 0; i < types.length; i += 4)
        types.sublist(i, (i + 4).clamp(0, types.length)),
    ];
  }

  /// 单按钮效果
  Widget _buildSingleButtonSection(BuildContext context) {
    return SantoSection(
      title: '单按钮效果',
      description: 'operateAreaType 为 singleButton 时展示一个主操作按钮',
      child: SantoEmpty(
        imageType: SantoEmptyImageType.orderEmpty,
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
        imageType: SantoEmptyImageType.searchEmpty,
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

  /// 无图片空态
  Widget _buildSmallModuleSection(BuildContext context) {
    return SantoSection(
      title: '无图片空态',
      description: '不传 imageType 与 img 时不展示图片，只展示文字，适用于小面积空态',
      child: SantoEmpty(
        content: '您的门店暂无用户',
      ),
    );
  }

  /// 自定义图片
  Widget _buildCustomImageSection(BuildContext context) {
    return SantoSection(
      title: '自定义图片',
      description: 'img 传任意图片组件(Image / SvgPicture)时展示自定义图片，优先级高于 imageType',
      child: SantoEmpty(
        img: Image.asset(
          'assets/image/content_failed.png',
          scale: 3.0,
        ),
        content: '您的门店暂无用户',
      ),
    );
  }
}
