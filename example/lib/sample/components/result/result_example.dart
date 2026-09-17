import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// Result 结果页示例
class ResultExample extends StatefulWidget {
  @override
  _ResultExampleState createState() => _ResultExampleState();
}

class _ResultExampleState extends State<ResultExample> {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: 'Result 示例',
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 成功状态
          SantoSection(
            title: '成功状态',
            description: 'status 为 success 时展示成功图标与主题色标题',
            child: SantoResult(
              status: SantoResultStatus.success,
              title: '操作成功',
              description: '内容已提交，审核通过后将同步至线上',
            ),
          ),
          // 失败状态
          SantoSection(
            title: '失败状态',
            description: 'status 为 error 时图标与配色切换为失败态',
            child: SantoResult(
              status: SantoResultStatus.error,
              title: '提交失败',
              description: '网络异常，请稍后重试',
            ),
          ),
          // 警告状态
          SantoSection(
            title: '警告状态',
            description: 'status 为 warning 时展示警示图标与对应主题色',
            child: SantoResult(
              status: SantoResultStatus.warning,
              title: '存在风险',
              description: '检测到部分内容可能违规，请检查后重新提交',
            ),
          ),
          // 信息状态
          SantoSection(
            title: '信息状态',
            description: 'status 为 info 时展示信息图标，适合审核中等中间态',
            child: SantoResult(
              status: SantoResultStatus.info,
              title: '审核中',
              description: '我们会在 1-3 个工作日内完成审核',
            ),
          ),
          // 带操作按钮
          SantoSection(
            title: '带操作按钮',
            description: 'actions 传入按钮列表，点击回调里可做跳转或提示',
            child: SantoResult(
              status: SantoResultStatus.success,
              title: '支付成功',
              description: '订单编号：202609150001',
              actions: [
                SantoSmallOutlineButton(
                  title: '查看订单',
                  onTap: () {
                    SantoToast.show('点击了查看订单', context);
                  },
                ),
                SantoSmallMainButton(
                  title: '返回首页',
                  onTap: () {
                    SantoToast.show('点击了返回首页', context);
                  },
                ),
              ],
            ),
          ),
          // 自定义图标和颜色
          SantoSection(
            title: '自定义图标和颜色',
            description: 'icon 与 iconColor 可覆盖默认图标及配色',
            child: SantoResult(
              status: SantoResultStatus.info,
              title: '等待支付',
              description: '订单已锁定 30 分钟，请尽快完成支付',
              icon: Icons.timelapse,
              iconColor: Color(0xFF1677FF),
            ),
          ),
        ],
      ),
    );
  }
}
