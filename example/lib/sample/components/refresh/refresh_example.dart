import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// Refresh 下拉刷新示例页面
class RefreshExample extends StatefulWidget {
  @override
  _RefreshExampleState createState() => _RefreshExampleState();
}

class _RefreshExampleState extends State<RefreshExample> {
  /// 列表数据
  List<String> _items = List.generate(20, (index) => '列表项 ${index + 1}');

  /// 是否还有更多数据
  bool _hasMore = true;

  /// 总数据量
  int _totalCount = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SantoAppBar(title: 'Refresh 下拉刷新示例'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '下拉刷新 / 上拉加载更多',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
          Expanded(
            child: SantoRefresh(
              onRefresh: _onRefresh,
              onLoadMore: _onLoadMore,
              hasMore: _hasMore,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFEEEEEE),
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xFF0984F9).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: Color(0xFF0984F9),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _items[index],
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.grey[400],
                          size: 20,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 下拉刷新
  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _items = List.generate(20, (index) => '刷新后的列表项 ${index + 1}');
      _totalCount = 20;
      _hasMore = true;
    });
  }

  /// 上拉加载更多
  Future<void> _onLoadMore() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      final newItems = List.generate(
        10,
        (index) => '列表项 ${_totalCount + index + 1}',
      );
      _items.addAll(newItems);
      _totalCount += 10;
      if (_totalCount >= 50) {
        _hasMore = false;
      }
    });
  }
}
