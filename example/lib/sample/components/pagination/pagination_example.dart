import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// SantoPagination 分页示例
class PaginationExample extends StatefulWidget {
  const PaginationExample({Key? key}) : super(key: key);

  @override
  State<PaginationExample> createState() => _PaginationExampleState();
}

class _PaginationExampleState extends State<PaginationExample> {
  int _basicPage = 3;
  int _simplePage = 1;
  int _ellipsesPage = 10;
  int _pageSizePage = 6;
  int _noButtonPage = 2;
  int _customTextPage = 4;
  int _byCountPage = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(title: 'Pagination 分页'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 12),
            SantoSection(
              title: '基础用法',
              description: 'totalItems 与 itemsPerPage 决定总页数，当前页由 current 控制',
              child: _center(SantoPagination(
                current: _basicPage,
                totalItems: 50,
                itemsPerPage: 10,
                onChange: (page) => setState(() => _basicPage = page),
              )),
            ),
            SantoSection(
              title: '简单模式',
              description: 'mode 为 simple 时只展示当前页/总页数，不展示页码列表',
              child: _center(SantoPagination(
                mode: SantoPaginationMode.simple,
                current: _simplePage,
                totalItems: 50,
                itemsPerPage: 10,
                onChange: (page) => setState(() => _simplePage = page),
              )),
            ),
            SantoSection(
              title: '显示省略号',
              description: 'forceEllipses 在页码区间两侧补省略号，点击跳到相邻页',
              child: _center(SantoPagination(
                current: _ellipsesPage,
                totalItems: 200,
                itemsPerPage: 10,
                forceEllipses: true,
                onChange: (page) => setState(() => _ellipsesPage = page),
              )),
            ),
            SantoSection(
              title: '展示页码数量',
              description: 'showPageSize 控制同时展示的页码数量，默认 5',
              child: _center(SantoPagination(
                current: _pageSizePage,
                totalItems: 200,
                itemsPerPage: 10,
                showPageSize: 3,
                forceEllipses: true,
                onChange: (page) => setState(() => _pageSizePage = page),
              )),
            ),
            SantoSection(
              title: '隐藏前后按钮',
              description: 'showPrevButton 与 showNextButton 可单独关闭上一页/下一页',
              child: _center(SantoPagination(
                current: _noButtonPage,
                totalItems: 50,
                itemsPerPage: 10,
                showPrevButton: false,
                showNextButton: false,
                onChange: (page) => setState(() => _noButtonPage = page),
              )),
            ),
            SantoSection(
              title: '自定义按钮文案',
              description: 'prevText 与 nextText 替换默认的上一页/下一页文案',
              child: _center(SantoPagination(
                current: _customTextPage,
                totalItems: 50,
                itemsPerPage: 10,
                prevText: '上一步',
                nextText: '下一步',
                onChange: (page) => setState(() => _customTextPage = page),
              )),
            ),
            SantoSection(
              title: '指定总页数',
              description: 'pageCount 直接指定总页数，优先于 totalItems',
              child: _center(SantoPagination(
                current: _byCountPage,
                pageCount: 8,
                onChange: (page) => setState(() => _byCountPage = page),
              )),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  /// 分页条宽度由内容决定,示例里居中展示
  Widget _center(Widget pagination) {
    return Align(alignment: Alignment.center, child: pagination);
  }
}
