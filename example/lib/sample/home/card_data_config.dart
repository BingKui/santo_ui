import 'dart:convert';

import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/components/actionsheet/actionsheet_entry_page.dart';
import 'package:example/sample/components/appraise/appraise_example.dart';
import 'package:example/sample/components/menu_bar/menu_bar_example.dart';
import 'package:example/sample/components/panel/panel_example.dart';
import 'package:example/sample/components/pagination/pagination_example.dart';
import 'package:example/sample/components/section/section_example.dart';
import 'package:example/sample/components/share/share_example.dart';
import 'package:example/sample/components/safe_area/safe_area_example.dart';
import 'package:example/sample/components/space/space_example.dart';
import 'package:example/sample/components/masonry/masonry_example.dart';
import 'package:example/sample/components/skeleton/skeleton_example.dart';
import 'package:example/sample/components/button/button_entry_page.dart';
import 'package:example/sample/components/calendar/calendar_example.dart';
import 'package:example/sample/components/card/santo_shadow_card_example.dart';
import 'package:example/sample/components/bubble_text/bubble_text_example.dart';
import 'package:example/sample/components/card/content/text_content_entry_page.dart';
import 'package:example/sample/components/card_title/title_example.dart';
import 'package:example/sample/components/charts/chart_entry_example.dart';
import 'package:example/sample/components/charts/doughnut_chart_example.dart';
import 'package:example/sample/components/charts/line/santo_broken_line_example.dart';
import 'package:example/sample/components/charts/line/db_data_node_model.dart';
import 'package:example/sample/components/charts/progress_bar_chart_example.dart';
import 'package:example/sample/components/charts/progress_chart_entry_page.dart';
import 'package:example/sample/components/dialog/dialog_entry_page.dart';
import 'package:example/sample/components/empty/empty_entry_page.dart';
import 'package:example/sample/components/form/all_item_style_example.dart';
import 'package:example/sample/components/gallery/gallery_example.dart';
import 'package:example/sample/components/guide/guide_entry_page.dart';
import 'package:example/sample/components/input/input_example.dart';
import 'package:example/sample/components/divider/divider_example.dart';
import 'package:example/sample/components/floating_panel/floating_panel_example.dart';
import 'package:example/sample/components/layout/app_layout_example.dart';
import 'package:example/sample/components/layout/page_layout_example.dart';
import 'package:example/sample/components/highlight/highlight_example.dart';
import 'package:example/sample/components/text_ellipsis/text_ellipsis_example.dart';
import 'package:example/sample/components/action_bar/action_bar_example.dart';
import 'package:example/sample/components/loading/loading_widget_example.dart';
import 'package:example/sample/components/navbar/appbar_entry_page.dart';
import 'package:example/sample/components/noticebar/santo_notice_bar_example.dart';
import 'package:example/sample/components/picker/picker_entry_page.dart';
import 'package:example/sample/components/tooltip/tooltip_example.dart';
import 'package:example/sample/components/popup/overlay_window_example.dart';
import 'package:example/sample/components/rate/rate_example.dart';
import 'package:example/sample/components/scroll_anchor/scroll_actor_tab_example.dart';
import 'package:example/sample/components/selection/selection_entry_page.dart';
import 'package:example/sample/components/step/step_example.dart';
import 'package:example/sample/components/sugsearch/search_text_example.dart';
import 'package:example/sample/components/switch/santo_switch_example.dart';
import 'package:example/sample/components/checkbox/checkbox_example.dart';
import 'package:example/sample/components/radio/radio_example.dart';
import 'package:example/sample/components/tabbar/santo_tab_example.dart';
import 'package:example/sample/components/tag/tag_example.dart';
import 'package:example/sample/components/toast/toast_example.dart';
import 'package:example/sample/components/badge/badge_example.dart';
import 'package:example/sample/components/avatar/avatar_example.dart';
import 'package:example/sample/components/cell/cell_example.dart';
import 'package:example/sample/components/footer/footer_example.dart';
import 'package:example/sample/components/link/link_example.dart';
import 'package:example/sample/components/image/image_example.dart';
import 'package:example/sample/components/result/result_example.dart';
import 'package:example/sample/components/backtop/backtop_example.dart';
import 'package:example/sample/components/collapse/collapse_example.dart';
import 'package:example/sample/components/drawer/drawer_example.dart';
import 'package:example/sample/components/progress/progress_example.dart';
import 'package:example/sample/components/slider/slider_example.dart';
import 'package:example/sample/components/stepper/stepper_example.dart';
import 'package:example/sample/components/swipe_cell/swipe_cell_example.dart';
import 'package:example/sample/components/swiper/swiper_example.dart';
import 'package:example/sample/components/cascader/cascader_example.dart';
import 'package:example/sample/components/dropdown_menu/dropdown_menu_example.dart';
import 'package:example/sample/components/popover/popover_example.dart';
import 'package:example/sample/components/sidebar/sidebar_example.dart';
import 'package:example/sample/components/tree/tree_example.dart';
import 'package:example/sample/components/fab/fab_example.dart';
import 'package:example/sample/components/message/message_example.dart';
import 'package:example/sample/components/refresh/refresh_example.dart';
import 'package:example/sample/components/time_counter/time_counter_example.dart';
import 'package:example/sample/components/table/table_example.dart';
import 'package:example/sample/components/segmented/segmented_example.dart';
import 'package:example/sample/components/statistic/statistic_example.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 卡片信息
class GroupInfo {
  int? groupId;
  String groupName;
  String desc;
  bool isExpand;
  List<GroupInfo>? children;
  Function(BuildContext context)? navigatorPage;

  GroupInfo({
    this.groupId,
    this.groupName = "",
    this.desc = "",
    this.isExpand = false,
    this.navigatorPage,
    this.children,
  });
}

/// 数据配置类
/// 分组参考 Ant Design 组件分类：通用、布局、导航、数据录入、数据展示、反馈、数据图表
class CardDataConfig {
  static List<GroupInfo> getAllGroup() {
    return [
      _getGeneralGroup(),
      _getLayoutGroup(),
      _getNavigationGroup(),
      _getDataEntryGroup(),
      _getDataDisplayGroup(),
      _getFeedbackGroup(),
      _getChartGroup(),
    ];
  }

  // ========== 通用 ==========
  static GroupInfo _getGeneralGroup() {
    List<GroupInfo> children = [
      _item("Button 按钮", "主按钮、次按钮、幽灵按钮、按钮集合、吸底按钮、图文按钮", ButtonEntryPage()),
      _item("Fab 悬浮按钮", "页面悬浮操作入口", FabExample()),
      _item("Link 链接", "文字链接", LinkExample()),
      _item("Panel 面板", "标题+操作+可滚动内容", PanelExample()),
      _item("Section 区块", "演示内容+标题描述", SectionExample()),
      _item("SafeArea 安全区域", "顶部与底部安全区域", SafeAreaExample()),
      _item("CardContent 卡片内容", "文本展示与展开", TextContentEntryPage()),
    ];
    return GroupInfo(groupName: "通用", children: children, isExpand: true);
  }

  // ========== 布局 ==========
  static GroupInfo _getLayoutGroup() {
    List<GroupInfo> children = [
      _item("Divider 分割线", "实线分割", DividerExample()),
      _item("Space 间距", "元素间距 gap", SpaceExample()),
      _item("Masonry 瀑布流", "多列瀑布流布局", MasonryExample()),
      _item("Skeleton 骨架屏", "加载占位骨架", SkeletonExample()),
      _item("FloatingPanel 浮层面板", "拖动吸附的底部面板", FloatingPanelExample()),
      _item("AppLayout 应用布局", "底部悬浮菜单栏 + 多页面", AppLayoutExample()),
      _item("PageLayout 页面布局", "可配置导航栏 + 滚动内容容器", PageLayoutExample()),
    ];
    return GroupInfo(groupName: "布局", children: children);
  }

  // ========== 导航 ==========
  static GroupInfo _getNavigationGroup() {
    List<GroupInfo> children = [
      _item("AppBar 导航栏", "页面顶部导航", AppbarEntryPage()),
      _item("Tabs 标签页", "内容分类切换", SantoTabExample()),
      _item("MenuBar 菜单栏", "默认/悬浮两种样式", MenuBarExample()),
      _item("Sidebar 侧边栏", "侧边导航菜单", SidebarExample()),
      _item("Steps 步骤条", "流程进度引导", StepExample()),
      _item("AnchorTab 锚点", "锚点定位导航", ScrollActorTabExample()),
      _item("BackTop 返回顶部", "长列表快速回顶", BacktopExample()),
      _item("Drawer 抽屉", "侧边滑出面板", DrawerExample()),
      _item("Guide 引导", "新手操作引导", GuideEntryPage()),
      _item("ActionBar 操作栏", "底部操作栏", ActionBarExample()),
    ];
    return GroupInfo(groupName: "导航", children: children);
  }

  // ========== 数据录入 ==========
  static GroupInfo _getDataEntryGroup() {
    List<GroupInfo> children = [
      _item("Input 输入框", "文本输入", SantoInputTextExample()),
      _item("Form 表单", "表单集合", AllFormItemStyleExamplePage()),
      _item("Radio 单选框", "单项选择", RadioExample()),
      _item("Checkbox 多选框", "多项选择", CheckboxExample()),
      _item("Switch 开关", "状态切换", SantoSwitchButtonExample()),
      _item("Rate 评分", "星级打分", RateExample()),
      _item("Stepper 步进器", "数量增减", StepperExample()),
      _item("Slider 滑动输入条", "范围数值选择", SliderExample()),
      _item("SearchText 搜索框", "搜索输入", SearchTextExample()),
      _item("Picker 选择器", "底部弹出选择", PickerEntryPage("选择器")),
      _item("Cascader 级联选择", "多级联动选择", CascaderExample()),
      _item("DropdownMenu 下拉菜单", "列表筛选下拉", DropdownMenuExample()),
      _item("Selection 筛选", "复杂条件筛选", SelectionEntryPage()),
      _item("Tree 树形控件", "树形结构选择", TreeExample()),
      _item("Calendar 日历", "日历日期选择", CalendarExample("日历组件")),
      _item("CitySelection 城市选择", "城市列表选择", _buildCitySelectionPage()),
    ];
    return GroupInfo(groupName: "数据录入", children: children, isExpand: false);
  }

  // ========== 数据展示 ==========
  static GroupInfo _getDataDisplayGroup() {
    List<GroupInfo> children = [
      _item("Avatar 头像", "用户头像展示", AvatarExample()),
      _item("Badge 徽标数", "红点/数字角标", BadgeExample()),
      _item("Cell 单元格", "列表标准行", CellExample()),
      _item("Card 卡片", "阴影卡片容器", SantoShadowCardExample()),
      _item("Swiper 轮播", "图片/内容轮播", SwiperExample()),
      _item("Collapse 折叠面板", "可展开/收起内容", CollapseExample()),
      _item("Image 图片", "增强图片组件", ImageExample()),
      _item("Table 表格", "数据表格展示", TableExample()),
      _item("Pagination 分页", "页码切换", PaginationExample()),
      _item("Segmented 分段选择器", "分段切换选择", SegmentedExample()),
      _item("Statistic 统计数值", "突出展示统计数字", StatisticExample()),
      _item("Tag 标签", "标记与分类", TagExample()),
      _item("BubbleText 气泡文本", "气泡文本", BubbleTextExample()),
      _item("Highlight 关键词高亮", "关键词高亮文本", HighlightExample()),
      _item("TextEllipsis 文本省略", "多行省略与展开收起", TextEllipsisExample()),
      _item("Popover 气泡卡片", "锚点弹出气泡", PopoverExample()),
      _item("CardTitle 卡片标题", "卡片头部标题", TitleExample()),
      _item("SwipeCell 滑动单元格", "列表项滑动操作", SwipeCellExample()),
      _item("NoticeBar 通知栏", "滚动通知条", SantoNoticeBarExample()),
      _item("Progress 进度条", "线性/环形进度", ProgressExample()),
      _item("TimeCounter 计时器", "倒计时/正计时", TimeCounterExample()),
      _item("Empty 空状态", "空数据提示", EmptyEntryPage("异常页面示例")),
      _item("Footer 页脚", "页面底部信息", FooterExample()),
      _item("Gallery 图片浏览", "大图预览", GalleryExample()),
    ];
    return GroupInfo(groupName: "数据展示", children: children);
  }

  // ========== 反馈 ==========
  static GroupInfo _getFeedbackGroup() {
    List<GroupInfo> children = [
      _item("Dialog 对话框", "弹窗交互", DialogEntryPage("弹窗示例")),
      _item("ActionSheet 动作面板", "底部动作菜单", ActionSheetEntryPage("动作面板")),
      _item("Share 分享", "分享面板", ShareExample()),
      _item("Toast 轻提示", "轻量反馈提示", ToastExample()),
      _item("Message 全局提示", "顶部消息通知", MessageExample()),
      _item("Tooltip 文字提示", "定位气泡提示", TooltipExample()),
      _item("OverlayWindow 悬浮窗", "搜索悬浮层", OverlayWindowExample("悬浮窗示例")),
      _item("Loading 加载", "加载状态动画", LoadingExample()),
      _item("Refresh 下拉刷新", "下拉刷新/上拉加载", RefreshExample()),
      _item("Result 结果", "操作结果反馈", ResultExample()),
      _item("Appraise 评价", "评分评价组件", AppraiseExample()),
    ];
    return GroupInfo(groupName: "反馈", children: children, isExpand: false);
  }

  // ========== 数据图表 ==========
  static GroupInfo _getChartGroup() {
    List<GroupInfo> children = [
      _item("BrokenLine 折线图", "数据折线图", null, customNav: (context) {
        rootBundle.loadString('assets/brokenline_data.json').then((data) {
          var brokenData = <DBDataNodeModel>[]..addAll(
              ((JsonDecoder().convert(data) as List?) ?? [])
                  .map((o) => DBDataNodeModel.fromJson(o)));
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => BrokenLineExample(brokenData),
          ));
        });
      }),
      _item("Radar 雷达图", "多维数据展示", RadarChartExamplePage()),
      _item("Funnel 漏斗图", "漏斗数据展示", FunnelChartExamplePage()),
      _item("Doughnut 环状图", "环形数据图", DoughnutChartExample()),
      _item("ProgressChart 进度图", "进度展示图", ProgressChartExample()),
      _item("BarChart 柱状图", "柱状数据图", ProgressBarChartExample()),
    ];
    return GroupInfo(groupName: "数据图表", children: children, isExpand: true);
  }

  // ========== 工具方法 ==========
  static GroupInfo _item(
    String name,
    String desc,
    Widget? page, {
    Function(BuildContext)? customNav,
  }) {
    return GroupInfo(
      groupName: name,
      desc: desc,
      navigatorPage: customNav ?? (page != null ? (BuildContext context) {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => page,
        ));
      } : null),
    );
  }

  static Widget _buildCitySelectionPage() {
    List<SantoSelectCityModel> hotCityList = [
      SantoSelectCityModel(name: "北京市"),
      SantoSelectCityModel(name: "广州市"),
      SantoSelectCityModel(name: "成都市"),
      SantoSelectCityModel(name: "深圳市"),
      SantoSelectCityModel(name: "杭州市"),
      SantoSelectCityModel(name: "武汉市"),
    ];
    return SantoCitySelection(
      appBarTitle: '城市单选',
      hotCityTitle: '这里是推荐城市',
      hotCityList: hotCityList,
    );
  }
}
