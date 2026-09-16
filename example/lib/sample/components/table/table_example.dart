import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// Table 表格示例页面
class TableExample extends StatefulWidget {
  @override
  _TableExampleState createState() => _TableExampleState();
}

class _TableExampleState extends State<TableExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(title: 'Table 表格示例'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 基础用法
            SantoPanel(
              title: '基础用法',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '简单的数据表格，支持边框和表头',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  SantoTable(
                    columns: [
                      SantoTableColumn(title: '姓名'),
                      SantoTableColumn(title: '年龄'),
                      SantoTableColumn(title: '城市'),
                    ],
                    data: [
                      ['张三', '25', '北京'],
                      ['李四', '30', '上海'],
                      ['王五', '28', '广州'],
                      ['赵六', '35', '深圳'],
                    ],
                  ),
                ],
              ),
            ),

            // 自定义列宽和对齐
            SantoPanel(
              title: '自定义列宽和对齐',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '通过 width 和 align 设置列宽和对齐方式',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  SantoTable(
                    columns: [
                      SantoTableColumn(
                        title: '排名',
                        width: 60,
                        align: SantoTableAlign.center,
                      ),
                      SantoTableColumn(
                        title: '产品名称',
                        align: SantoTableAlign.left,
                      ),
                      SantoTableColumn(
                        title: '价格',
                        width: 80,
                        align: SantoTableAlign.right,
                      ),
                      SantoTableColumn(
                        title: '销量',
                        width: 80,
                        align: SantoTableAlign.right,
                      ),
                    ],
                    data: [
                      ['1', 'iPhone 15 Pro', '¥8999', '12,580'],
                      ['2', 'Samsung S24', '¥6999', '8,920'],
                      ['3', 'Xiaomi 14', '¥4299', '15,320'],
                      ['4', 'OPPO Find X7', '¥3999', '6,780'],
                      ['5', 'vivo X100', '¥3699', '9,450'],
                    ],
                  ),
                ],
              ),
            ),

            // 斑马纹样式
            SantoPanel(
              title: '斑马纹样式',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '设置 striped: true 启用斑马纹效果',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  SantoTable(
                    columns: [
                      SantoTableColumn(title: '日期', width: 100),
                      SantoTableColumn(title: '项目', align: SantoTableAlign.left),
                      SantoTableColumn(title: '金额', width: 100,
                          align: SantoTableAlign.right),
                      SantoTableColumn(title: '状态', width: 80),
                    ],
                    data: [
                      ['09-01', '办公用品采购', '¥2,580', '已完成'],
                      ['09-03', '差旅报销', '¥4,200', '审批中'],
                      ['09-05', '设备维修', '¥1,800', '已完成'],
                      ['09-08', '市场推广', '¥15,000', '待审批'],
                      ['09-10', '员工培训', '¥3,600', '已完成'],
                      ['09-12', '软件采购', '¥8,900', '审批中'],
                    ],
                    striped: true,
                  ),
                ],
              ),
            ),

            // 自定义表头颜色
            SantoPanel(
              title: '自定义表头颜色',
              child: SantoTable(
                columns: [
                  SantoTableColumn(title: '序号', width: 60),
                  SantoTableColumn(title: '任务名称',
                      align: SantoTableAlign.left),
                  SantoTableColumn(title: '负责人', width: 80),
                  SantoTableColumn(title: '进度', width: 80),
                ],
                data: [
                  ['1', 'UI 设计', '张三', '100%'],
                  ['2', '前端开发', '李四', '75%'],
                  ['3', '后端开发', '王五', '60%'],
                  ['4', '测试验证', '赵六', '30%'],
                ],
                headerColor: Color(0xFF52C41A),
              ),
            ),

            // 自定义单元格内容
            SantoPanel(
              title: '自定义单元格内容',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '通过 cellBuilder 自定义单元格显示',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  SantoTable(
                    columns: [
                      SantoTableColumn(title: '姓名', width: 80),
                      SantoTableColumn(title: '部门', width: 100),
                      SantoTableColumn(
                        title: '状态',
                        width: 100,
                        cellBuilder: (data, row, col) {
                          Color statusColor;
                          IconData statusIcon;
                          switch (data.toString()) {
                            case '在职':
                              statusColor = Color(0xFF52C41A);
                              statusIcon = Icons.check_circle;
                              break;
                            case '休假':
                              statusColor = Color(0xFFFAAD14);
                              statusIcon = Icons.access_time;
                              break;
                            case '离职':
                              statusColor = Color(0xFFFF4D4F);
                              statusIcon = Icons.cancel;
                              break;
                            default:
                              statusColor = Colors.grey;
                              statusIcon = Icons.help;
                          }
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(statusIcon, color: statusColor, size: 16),
                              SizedBox(width: 4),
                              Text(
                                data.toString(),
                                style: TextStyle(
                                    color: statusColor, fontSize: 13),
                              ),
                            ],
                          );
                        },
                      ),
                      SantoTableColumn(
                        title: '操作',
                        width: 100,
                        cellBuilder: (data, row, col) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showSnackBar('编辑第${row + 1}行');
                                },
                                child: Text(
                                  '编辑',
                                  style: TextStyle(
                                    color: Color(0xFF1677FF),
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              GestureDetector(
                                onTap: () {
                                  _showSnackBar('删除第${row + 1}行');
                                },
                                child: Text(
                                  '删除',
                                  style: TextStyle(
                                    color: Color(0xFFFF4D4F),
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                    data: [
                      ['张三', '技术部', '在职'],
                      ['李四', '产品部', '在职'],
                      ['王五', '设计部', '休假'],
                      ['赵六', '市场部', '离职'],
                    ],
                  ),
                ],
              ),
            ),

            // 无边框表格
            SantoPanel(
              title: '无边框表格',
              child: SantoTable(
                columns: [
                  SantoTableColumn(title: '指标', width: 100),
                  SantoTableColumn(title: '本月', width: 100),
                  SantoTableColumn(title: '上月', width: 100),
                  SantoTableColumn(title: '环比', width: 80),
                ],
                data: [
                  ['用户数', '12,580', '11,200', '+12.3%'],
                  ['订单量', '8,920', '7,800', '+14.4%'],
                  ['营收', '¥258万', '¥230万', '+12.2%'],
                  ['转化率', '3.2%', '2.8%', '+14.3%'],
                ],
                border: false,
                headerColor: Color(0xFFF5F5F5),
                headerTextColor: Color(0xFF17233D),
                striped: true,
                oddRowColor: Colors.white,
                evenRowColor: Color(0xFFFAFAFA),
              ),
            ),
            SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
