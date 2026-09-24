import 'dart:async';

import 'package:santo_ui/src/components/picker/time_picker/santo_date_time_formatter.dart';
import 'package:santo_ui/src/components/selection/bean/santo_selection_common_entity.dart';
import 'package:santo_ui/src/components/selection/santo_selection_util.dart';
import 'package:santo_ui/src/components/selection/dropdown_menu.dart';
import 'package:santo_ui/src/components/selection/controller/dropdown_menu_controller.dart';
import 'package:santo_ui/src/components/selection/widget/santo_selection_animate_widget.dart';
import 'package:santo_ui/src/components/selection/widget/santo_selection_list_widget.dart';
import 'package:santo_ui/src/components/selection/widget/santo_selection_menu_item_widget.dart';
import 'package:santo_ui/src/components/selection/widget/santo_selection_range_widget.dart';
import 'package:santo_ui/src/l10n/santo_intl.dart';
import 'package:santo_ui/src/theme/configs/santo_selection_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/utils/santo_event_bus.dart';
import 'package:santo_ui/src/utils/santo_tools.dart';
import 'package:flutter/material.dart';

typedef SantoOnMenuItemClick = bool Function(int index);

typedef SantoOnRangeSelectionConfirm = void Function(SantoSelectionEntity results,
    int firstIndex, int secondIndex, int thirdIndex);

/// 筛选菜单子组件
class SantoSelectionMenuWidget extends StatefulWidget {
  /// 筛选菜单数据
  final List<SantoSelectionEntity> data;
  final BuildContext context;

  /// 筛选菜单高度
  final double height;
  /// 筛选菜单宽度
  final double? width;

  /// 确认回调
  final SantoOnRangeSelectionConfirm? onConfirm;

  /// 筛选菜单项点击回调
  final SantoOnMenuItemClick? onMenuItemClick;

  /// 每行的 tag 数，用于子组件配置
  final SantoConfigTagCountPerRow? configRowCount;

  ///筛选所在列表的外部列表滚动需要收起筛选，此处为最外层列表，有点恶心，但是暂时只想到这个方法，有更好方式的一定要告诉我
  final ScrollController? extraScrollController;

  ///指定筛选固定的相对于屏幕的顶部距离，默认null不指定
  final double? constantTop;

  /// 筛选菜单主题
  final SantoSelectionConfig themeData;

  SantoSelectionMenuWidget(
      {Key? key,
      required this.context,
      required this.data,
      this.height = 50.0,
      this.width,
      this.onMenuItemClick,
      this.onConfirm,
      this.configRowCount,
      this.extraScrollController,
      this.constantTop,
      required this.themeData})
      : super(key: key);

  @override
  _SantoSelectionMenuWidgetState createState() => _SantoSelectionMenuWidgetState();
}

class _SantoSelectionMenuWidgetState extends State<SantoSelectionMenuWidget> {
  bool _needRefreshTitle = true;
  List<SantoSelectionEntity> result = [];
  List<String> titles = [];
  List<bool> menuItemActiveState = [];
  List<bool> menuItemHighlightState = [];
  SantoSelectionListViewController listViewController =
      SantoSelectionListViewController();
  ScrollController? _scrollController;

  late StreamSubscription _refreshTitleSubscription;

  late StreamSubscription _closeSelectionPopupWindowSubscription;

  @override
  void initState() {
    super.initState();
    _refreshTitleSubscription = EventBus.instance
        .on<RefreshMenuTitleEvent>()
        .listen((RefreshMenuTitleEvent event) {
      _needRefreshTitle = true;
      setState(() {});
    });

    _closeSelectionPopupWindowSubscription = EventBus.instance
        .on<CloseSelectionViewEvent>()
        .listen((CloseSelectionViewEvent event) {
      _closeSelectionPopupWindow();
    });

    if (widget.extraScrollController != null) {
      _scrollController = widget.extraScrollController!;
      _scrollController!.addListener(_closeSelectionPopupWindow);
    }

    for (SantoSelectionEntity parentEntity in widget.data) {
      titles.add(parentEntity.title);
      menuItemActiveState.add(false);
      menuItemHighlightState.add(false);
    }
  }

  void _closeSelectionPopupWindow() {
    if (listViewController.isShow) {
      listViewController.hide();
      setState(() {
        for (int i = 0; i < menuItemActiveState.length; i++) {
          if (i != listViewController.menuIndex) {
            menuItemActiveState[i] = false;
          } else {
            menuItemActiveState[i] = !menuItemActiveState[i];
          }
          if (widget.data[listViewController.menuIndex].type == 'more') {
            menuItemActiveState[i] = false;
          }
        }
      });
    }
  }

  dispose() {
    _scrollController?.removeListener(_closeSelectionPopupWindow);
    _refreshTitleSubscription.cancel();
    _closeSelectionPopupWindowSubscription.cancel();
    listViewController.hide();
    super.dispose();
  }

  /// 根据【Filter组】 创建 widget。
  OverlayEntry _createEntry(SantoSelectionEntity entity) {
    var content = _isRange(entity)
        ? _createRangeView(entity)
        : _createSelectionListView(entity);
    return OverlayEntry(builder: (context) {
      return GestureDetector(
        onTap: () {
          _closeSelectionPopupWindow();
        },
        child: Container(
          padding: EdgeInsets.only(
            top: listViewController.listViewTop ?? 0,
          ),
          child: Stack(
            children: <Widget>[
              SantoSelectionAnimationWidget(
                  controller: listViewController, view: content)
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return Container(
      height: widget.height,
      width: (widget.width != null)
          ? widget.width
          : MediaQuery.of(context).size.width,
      color: commonConfig.fillBase,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 990,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _configMenuItems(),
            ),
          ),
          Expanded(
            flex: 10,
            child: Container(
              height: commonConfig.borderWidthSm,
              color: widget.themeData.commonConfig.dividerColorBase,
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _configMenuItems() {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    List<Widget> itemViewList = [];
    itemViewList.add(Padding(
      padding: EdgeInsets.only(left: commonConfig.hSpacingMd),
    ));
    for (int index = 0; index < titles.length; index++) {
      if (_needRefreshTitle) {
        _refreshSelectionMenuTitle(index, widget.data[index]);
        if (index == titles.length - 1) {
          _needRefreshTitle = false;
        }
      }
      itemViewList.add(Padding(
        padding: EdgeInsets.only(left: commonConfig.hSpacingXs),
      ));
      itemViewList.add(SantoSelectionMenuItemWidget(
        title: titles[index],
        themeData: widget.themeData,
        active: menuItemActiveState[index],
        isHighLight:
            menuItemActiveState[index] || menuItemHighlightState[index],
        itemClickFunction: () {
          if (widget.onMenuItemClick != null) {
            /// 拦截 menuItem 点击。
            if (widget.onMenuItemClick!(index)) {
              return;
            }
          }
          RenderBox? dropDownItemRenderBox;
          if (context.findRenderObject() != null &&
              context.findRenderObject() is RenderBox) {
            dropDownItemRenderBox = context.findRenderObject() as RenderBox;
          }
          Offset? position =
              dropDownItemRenderBox?.localToGlobal(Offset.zero, ancestor: null);
          Size? size = dropDownItemRenderBox?.size;
          listViewController.listViewTop =
              (size?.height ?? 0) + (widget.constantTop ?? position?.dy ?? 0);
          if (listViewController.isShow &&
              listViewController.menuIndex != index) {
            listViewController.hide();
          }

          if (listViewController.isShow) {
            listViewController.hide();
          } else {
            /// 点击不是 More、自定义类型，则直接展开。
            if (widget.data[index].filterType != SantoSelectionFilterType.more &&
                widget.data[index].filterType !=
                    SantoSelectionFilterType.customHandle) {
              /// 创建 筛选组件的的入口
              OverlayEntry entry = _createEntry(widget.data[index]);
              Overlay.of(widget.context).insert(entry);

              listViewController.entry = entry;
              listViewController.show(index);
            } else if (widget.data[index].filterType ==
                SantoSelectionFilterType.customHandle) {
              /// 记录自定义筛选 menu 的点击状态，当点击自定义的 menu 时，menu 文案默认高亮。
              listViewController.show(index);
              _refreshSelectionMenuTitle(index, widget.data[index]);
            } else {
              _refreshSelectionMenuTitle(index, widget.data[index]);
            }
          }

          setState(() {
            for (int i = 0; i < menuItemActiveState.length; i++) {
              if (i != index) {
                menuItemActiveState[i] = false;
              } else {
                menuItemActiveState[i] = !menuItemActiveState[i];
              }
              if (widget.data[index].type == 'more') {
                menuItemActiveState[i] = false;
              }
            }
          });
        },
      ));
      itemViewList.add(Padding(
        padding: EdgeInsets.only(left: commonConfig.hSpacingXs),
      ));
    }
    itemViewList.add(Padding(
      padding: EdgeInsets.only(left: commonConfig.hSpacingMd),
    ));
    return itemViewList;
  }

  /// 1、子筛选项包含自定义范围的时候，使用 Tag 模式展示。
  /// 2、被指定为 Tag 模式展示。
  /// 3、只有一列筛选数据，且为多选时，使用 Tag 模式展示
  bool _isRange(SantoSelectionEntity entity) {
    if (SantoSelectionUtil.hasRangeItem(entity.children) ||
        entity.filterShowType == SantoSelectionWindowType.range) {
      return true;
    }
    var totalLevel = SantoSelectionUtil.getTotalLevel(entity);
    if (totalLevel == 1 &&
        entity.filterType == SantoSelectionFilterType.checkbox) {
      return true;
    }
    return false;
  }

  Widget _createRangeView(SantoSelectionEntity entity) {
    int? rowCount;
    if (widget.configRowCount != null) {
      rowCount = widget.configRowCount!(widget.data.indexOf(entity), entity) ??
          rowCount;
    }
    return SantoRangeSelectionGroupWidget(
      entity: entity,
      marginTop: listViewController.listViewTop ?? 0,
      maxContentHeight: DESIGN_SELECTION_HEIGHT /
          DESIGN_SCREEN_HEIGHT *
          MediaQuery.of(context).size.height,
      // UI 给出的内容高度比例 248:812
      themeData: widget.themeData,
      rowCount: rowCount,
      bgClickFunction: () {
        setState(() {
          menuItemActiveState[listViewController.menuIndex] = false;
          if (entity.selectedListWithoutUnlimit().isNotEmpty) {
            menuItemHighlightState[listViewController.menuIndex] = true;
          }
          listViewController.hide();
        });
      },
      onSelectionConfirm: (SantoSelectionEntity result, int firstIndex,
          int secondIndex, int thirdIndex) {
        setState(() {
          _onConfirmSelect(entity, result, firstIndex, secondIndex, thirdIndex);
        });
      },
    );
  }

  Widget _createSelectionListView(SantoSelectionEntity entity) {
    /// 顶层筛选 Tab
    return SantoListSelectionGroupWidget(
      entity: entity,
      maxContentHeight: DESIGN_SELECTION_HEIGHT /
          DESIGN_SCREEN_HEIGHT *
          MediaQuery.of(context).size.height,
      themeData: widget.themeData,
      // UI 给出的内容高度比例 248:812
      bgClickFunction: () {
        setState(() {
          menuItemActiveState[listViewController.menuIndex] = false;
          if (entity.selectedListWithoutUnlimit().isNotEmpty) {
            menuItemHighlightState[listViewController.menuIndex] = true;
          }
          listViewController.hide();
        });
      },
      onSelectionConfirm: (SantoSelectionEntity result, int firstIndex,
          int secondIndex, int thirdIndex) {
        setState(() {
          _onConfirmSelect(entity, result, firstIndex, secondIndex, thirdIndex);
        });
      },
    );
  }

  void _onConfirmSelect(SantoSelectionEntity entity, SantoSelectionEntity result,
      int firstIndex, int secondIndex, int thirdIndex) {
    if (listViewController.menuIndex < titles.length) {
      if (widget.onConfirm != null) {
        widget.onConfirm!(result, firstIndex, secondIndex, thirdIndex);
      }
      menuItemActiveState[listViewController.menuIndex] = false;
      _refreshSelectionMenuTitle(listViewController.menuIndex, entity);
      listViewController.hide();
    }
  }

  /// 筛选 Title 展示规则
  String? _getSelectedResultTitle(SantoSelectionEntity entity) {
    /// 更多筛选不改变 title.故返回 null
    if (entity.filterType == SantoSelectionFilterType.more) {
      return null;
    }
    if (SantoTools.isEmpty(entity.customTitle)) {
      return _getTitle(entity);
    } else {
      return entity.customTitle;
    }
  }

  String? _getTitle(SantoSelectionEntity entity) {
    String? title;
    List<SantoSelectionEntity> firstColumn =
        SantoSelectionUtil.currentSelectListForEntity(entity);
    List<SantoSelectionEntity> secondColumn = [];
    List<SantoSelectionEntity> thirdColumn = [];
    if (firstColumn.isNotEmpty) {
      for (SantoSelectionEntity firstEntity in firstColumn) {
        secondColumn
            .addAll(SantoSelectionUtil.currentSelectListForEntity(firstEntity));
        if (secondColumn.isNotEmpty) {
          for (SantoSelectionEntity secondEntity in secondColumn) {
            thirdColumn.addAll(
                SantoSelectionUtil.currentSelectListForEntity(secondEntity));
          }
        }
      }
    }

    if (firstColumn.isEmpty || firstColumn.length > 1) {
      title = entity.title;
    } else {
      /// 第一列选中了一个，为【不限】类型，使用上一级别的名字展示。
      if (firstColumn[0].isUnLimit()) {
        title = entity.title;
      } else if (firstColumn[0].filterType == SantoSelectionFilterType.range ||
          firstColumn[0].filterType == SantoSelectionFilterType.date ||
          firstColumn[0].filterType == SantoSelectionFilterType.dateRange ||
          firstColumn[0].filterType ==
              SantoSelectionFilterType.dateRangeCalendar) {
        title = _getDateAndRangeTitle(firstColumn, entity);
      } else {
        if (secondColumn.isEmpty || secondColumn.length > 1) {
          title = firstColumn[0].title;
        } else {
          /// 第二列选中了一个，为【不限】类型，使用上一级别的名字展示。
          if (secondColumn[0].isUnLimit()) {
            title = firstColumn[0].title;
          } else if (secondColumn[0].filterType ==
                  SantoSelectionFilterType.range ||
              secondColumn[0].filterType == SantoSelectionFilterType.date ||
              secondColumn[0].filterType == SantoSelectionFilterType.dateRange ||
              secondColumn[0].filterType ==
                  SantoSelectionFilterType.dateRangeCalendar) {
            title = _getDateAndRangeTitle(secondColumn, firstColumn[0]);
          } else {
            if (thirdColumn.isEmpty || thirdColumn.length > 1) {
              title = secondColumn[0].title;
            } else {
              /// 第三列选中了一个，为【不限】类型，使用上一级别的名字展示。
              if (thirdColumn[0].isUnLimit()) {
                title = secondColumn[0].title;
              } else if (thirdColumn[0].filterType ==
                      SantoSelectionFilterType.range ||
                  thirdColumn[0].filterType == SantoSelectionFilterType.date ||
                  thirdColumn[0].filterType ==
                      SantoSelectionFilterType.dateRange ||
                  thirdColumn[0].filterType ==
                      SantoSelectionFilterType.dateRangeCalendar) {
                title = _getDateAndRangeTitle(thirdColumn, secondColumn[0]);
              } else {
                title = thirdColumn[0].title;
              }
            }
          }
        }
      }
    }
    String joinTitle =
        _getJoinTitle(entity, firstColumn, secondColumn, thirdColumn);
    title = SantoTools.isEmpty(joinTitle) ? title : joinTitle;
    return title;
  }

  String? _getDateAndRangeTitle(
      List<SantoSelectionEntity> list, SantoSelectionEntity entity) {
    String? title = '';
    if (!SantoTools.isEmpty(list[0].customMap)) {
      if (list[0].filterType == SantoSelectionFilterType.range) {
        title =
            '${list[0].customMap!['min']}-${list[0].customMap!['max']}(${list[0].extMap['unit']?.toString()})';
      } else if (list[0].filterType == SantoSelectionFilterType.dateRange ||
          list[0].filterType == SantoSelectionFilterType.dateRangeCalendar) {
        title = _getDateRangeTitle(list);
      }
    } else {
      if (list[0].filterType == SantoSelectionFilterType.date) {
        title = _getDateTimeTitle(list);
      } else {
        title = entity.title;
      }
    }
    return title;
  }

  String _getDateRangeTitle(List<SantoSelectionEntity> list) {
    String minDateTime = '';
    String maxDateTime = '';

    if (list[0].customMap != null &&
        list[0].customMap!['min'] != null &&
        int.tryParse(list[0].customMap!['min'] ?? '') != null) {
      DateTime? minDate = DateTimeFormatter.convertIntValueToDateTime(
          list[0].customMap!['min']);
      if (minDate != null) {
        minDateTime = DateTimeFormatter.formatDate(
            minDate, SantoIntl.of(context).localizedResource.dateFormatYYYYMMDD);
      }
    }
    if (list[0].customMap != null &&
        list[0].customMap!['max'] != null &&
        int.tryParse(list[0].customMap!['max'] ?? '') != null) {
      DateTime? maxDate = DateTimeFormatter.convertIntValueToDateTime(
          list[0].customMap!['max']);
      if (maxDate != null) {
        maxDateTime = DateTimeFormatter.formatDate(
            maxDate, SantoIntl.of(context).localizedResource.dateFormatYYYYMMDD);
      }
    }
    return '$minDateTime-$maxDateTime';
  }

  String? _getDateTimeTitle(List<SantoSelectionEntity> list) {
    String? title = "";
    int? msDateTime = int.tryParse(list[0].value ?? '');
    title = msDateTime != null
        ? DateTimeFormatter.formatDate(
            DateTime.fromMillisecondsSinceEpoch(msDateTime),
            SantoIntl.of(context).localizedResource.dateFormatYYYYMMDD)
        : list[0].title;
    return title;
  }

  String _getJoinTitle(
      SantoSelectionEntity entity,
      List<SantoSelectionEntity> firstColumn,
      List<SantoSelectionEntity> secondColumn,
      List<SantoSelectionEntity> thirdColumn) {
    String title = "";
    if (entity.canJoinTitle) {
      if (firstColumn.length == 1) {
        title = firstColumn[0].title;
      }
      if (secondColumn.length == 1) {
        title += secondColumn[0].title;
      }
      if (thirdColumn.length == 1) {
        title += thirdColumn[0].title;
      }
    }
    return title;
  }

  void _refreshSelectionMenuTitle(int index, SantoSelectionEntity entity) {
    if (entity.filterType == SantoSelectionFilterType.more) {
      if (entity.allSelectedList().isNotEmpty) {
        menuItemHighlightState[index] = true;
      } else {
        menuItemHighlightState[index] = false;
      }
      return;
    }
    String? title = _getSelectedResultTitle(entity);
    if (title != null) {
      titles[index] = title;
    }
    if (entity.selectedListWithoutUnlimit().isNotEmpty) {
      menuItemHighlightState[index] = true;
    } else if (!SantoTools.isEmpty(entity.customTitle)) {
      menuItemHighlightState[index] = entity.isCustomTitleHighLight;
    } else {
      menuItemHighlightState[index] = false;
    }
  }
}
