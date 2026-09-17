import 'package:santo_ui/src/components/gallery/config/santo_basic_gallery_config.dart';
import 'package:santo_ui/src/components/gallery/config/santo_controller.dart';
import 'package:santo_ui/src/components/gallery/page/santo_gallery_detail_page.dart';
import 'package:santo_ui/src/components/navbar/santo_appbar.dart';
import 'package:santo_ui/src/components/scroll_anchor/santo_scroll_anchor_tab.dart';
import 'package:santo_ui/src/components/tabbar/normal/santo_tab_bar.dart';
import 'package:santo_ui/src/l10n/santo_intl.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

/// 查看大图交互模式-列表页：组件提供了（列表页<-->详情页）这种交互模式的骨架.
/// 适用于查看图片，视频 PDF 等场景。
/// 默认只实现了图片的查看，如果想要扩展视频或者 pdf 自行扩展配置接口可实现。
class SantoGallerySummaryPage extends StatefulWidget {
  /// 显示的所有配置信息
  final List<SantoBasicGroupConfig> allConfig;

  /// 每一行的数量
  final int rowCount;

  /// 是否从详情页跳转，一般情况不使用
  final bool fromDetail;

  /// 图片详情页右上角自定义设置按钮，若为空，则展示 "全部图片"
  final Widget Function(int? groupId, int? indexId)? detailRightAction;

  /// 控制图片查看刷新
  final SantoGalleryController? controller;

  SantoGallerySummaryPage(
      {required this.allConfig,
      this.rowCount = 4,
      this.fromDetail = false,
      this.detailRightAction,
      this.controller});

  @override
  _SantoGallerySummaryPageState createState() => _SantoGallerySummaryPageState();
}

class _SantoGallerySummaryPageState extends State<SantoGallerySummaryPage> {
  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      widget.controller!.addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  void didUpdateWidget(SantoGallerySummaryPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != null &&
        oldWidget.controller != widget.controller) {
      widget.controller!.addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SantoAppBar(
        title: SantoIntl.of(context).localizedResource.allPics,
      ),
      body: Container(color: Colors.white, child: _body()),
    );
  }

  Widget _body() {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    List<SantoBasicGroupConfig> allConfig = widget.allConfig;
    if (allConfig.length == 1) {
      return SingleChildScrollView(child: _buildItem(allConfig[0], 0));
    } else {
      return Padding(
        padding: EdgeInsets.only(bottom: commonConfig.vSpacingLg),
        child: SantoAnchorTab(
            widgetIndexedBuilder: (c, i) {
              return _buildItem(allConfig[i], i);
            },
            tabIndexedBuilder: (c, i) {
              return BadgeTab(
                  text:
                      '${allConfig[i].title ?? ""}(${allConfig[i].configList?.length ?? 0})');
            },
            itemCount: allConfig.length),
      );
    }
  }

  Widget _buildItem(SantoBasicGroupConfig? groupConfig, int groupId) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    if (groupConfig == null) return Row();
    List<Widget> columnViews = <Widget>[];
    if (groupConfig.title != null) {
      columnViews.add(Container(
        height: 53,
        child: Padding(
          padding: EdgeInsets.only(
              top: 16,
              bottom: 12,
              left: commonConfig.hSpacingLg,
              right: commonConfig.hSpacingLg),
          child: Text(
            '${groupConfig.title}(${groupConfig.configList?.length ?? 0})',
            style: TextStyle(
                color: Color(0xFF17233D),
                fontSize: commonConfig.fontSizeHead,
                fontWeight: FontWeight.w500),
          ),
        ),
      ));
    }
    if (groupConfig.configList != null) {
      List<Widget> gridViews = <Widget>[];
      for (int i = 0; i < groupConfig.configList!.length; i++) {
        gridViews.add(GestureDetector(
          onTap: () {
            //页面的跳转不应该交个子Widget处理
            if (widget.fromDetail) {
              Navigator.of(context).pop([groupId, i]);
            } else {
              Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
                return SantoGalleryDetailPage(
                  allConfig: widget.allConfig,
                  initGroupId: groupId,
                  initIndexId: i,
                  fromSummary: true,
                  detailRightAction: widget.detailRightAction,
                  controller: widget.controller,
                );
              }));
            }
          },
          child: groupConfig.configList![i]
              .buildSummaryWidget(context, widget.allConfig, groupId, i),
        ));
      }
      columnViews.add(GridView.count(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        //水平子Widget之间间距
        crossAxisSpacing: commonConfig.hSpacingSm,
        //垂直子Widget之间间距
        mainAxisSpacing: commonConfig.vSpacingSm,
        //GridView内边距
        padding: EdgeInsets.only(
            left: commonConfig.hSpacingLg, right: commonConfig.hSpacingLg),
        //一行的Widget数量
        crossAxisCount: widget.rowCount,
        //子Widget宽高比例
        childAspectRatio: 1.0,
        children: gridViews,
      ));
    }

    return Column(
      children: columnViews,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
