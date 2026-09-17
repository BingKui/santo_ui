import 'dart:math';

import 'package:santo_ui/src/components/dialog/santo_dialog.dart';
import 'package:santo_ui/src/components/line/santo_line.dart';
import 'package:santo_ui/src/constants/santo_asset_constants.dart';
import 'package:santo_ui/src/l10n/santo_intl.dart';
import 'package:santo_ui/src/utils/santo_tools.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 获取对应 index 行内容的回调。类型必须为 String 或者自定义的 widget.自定义 widget 时，左边的 icon 会自动隐藏，自定义widget填充整行。
typedef SantoItemTitleBuilder<T> = dynamic Function(int index, T entity);

/// 每一行删除按钮的点击回调。返回值：是否要删除该 entity，如果该 handler 没有实现或者返回 true，则删除
typedef SantoItemDeleteCallback<T> = bool Function(int deleteIdx, T deleteEntity);

/// 视图隐藏时的回调，会把是否是清空按钮触发的销毁视图回传
typedef SantoListDismissCallback = void Function(bool isClosedByClearButton);


/// 监听数据刷新和列表关闭操作
class SantoSelectedListActionSheetController extends ChangeNotifier {
  /// 是否刷新数据
  bool isShouldReloadData = false;

  /// 是否关闭列表
  bool isSelectedListDismissed = false;

  /// 视图是否隐藏
  bool _isHidden = true;

  /// 刷新整个列表数据
  void reloadData() {
    isShouldReloadData = true;
    isSelectedListDismissed = false;
    notifyListeners();
  }

  /// 关闭列表
  void dismiss() {
    isSelectedListDismissed = true;
    isShouldReloadData = false;
    _isHidden = true;
    notifyListeners();
  }

  /// 视图是否隐藏
  bool get isHidden {
    return _isHidden;
  }
}

/// 描述: 已选菜单列表
///
/// 1. 初始化完成之后，调用 [show] 展示弹窗，调用 [dismiss] 关闭弹窗。
///    <20210618更>:也可以使用 [showWithTargetKey] 方法展示弹窗，传入已选列表底部组件绑定的 globalKey，已选列表会
///    自动与 globalKey 绑定的组件左右对齐，并从其顶部弹出。clear
/// 2. 外界需要自己监听 Android 上的系统返回事件，并且调用组件的 [dismiss] 方法！否则，组件不能正常关闭。
class SantoSelectedListActionSheet<T> {

  /// 用来获取 Overlay
  final BuildContext context;

  /// 数据源列表
  final List<T> items;

  /// 获取对应 index 行内容的回调。类型必须为 String 或者自定义的 widget.自定义 widget 时，左边的 icon 会自动隐藏，自定义widget填充整行。
  final SantoItemTitleBuilder<T> itemTitleBuilder;

  /// 控制视图隐藏/刷新列表等方法
  final SantoSelectedListActionSheetController? controller;

  /// 视图的最大高度。默认值 290，列表的内容的高度=maxHeight-65
  final double maxHeight;

  /// 列表结束显示时底部的 y。0 会和屏幕的底部重合。默认值 82。不能为负值！
  final double bottomOffset;

  /// 标题名称。默认不限制行数
  /// 默认[TextStyle]样式：
  ///
  /// ``` dart
  /// TextStyle(
  ///   fontSize: fontSizeHead,
  ///   color: Color(0xff17233D),
  ///   fontWeight: FontWeight.w500,
  ///   decoration: TextDecoration.none)
  /// ```
  final String? title;

  /// 自定义标题视图。默认外层有 `EdgeInsets.fromLTRB(hSpacingLg, vSpacingLg, hSpacingLg, vSpacingMd)` 的 padding，且优先级比 [title] 高
  final Widget? titleWidget;

  /// 清空按钮是否显示，默认为 false
  final bool isClearButtonHidden;

  /// 每一行删除按钮是否展示。默认为 false。如果不显示，自定义每一行 widget 时内容可以填充整行
  final bool isDeleteButtonHidden;

  /// 每一行前边的 icon，可不传。如果该 image 没有设置，并且 itemTitleBuilder 返回的是自定义 widget，则该 widget 自动填充整行区域
  final Image? itemIconImage;

  /// 点击清空按钮后的回调，如果没有实现该回调，则会显示默认弹窗。如果要关闭已选列表，请调用 dismiss()。
  final VoidCallback? onClear;

  /// 清空按钮点击显示默认确认弹窗之后，`确定` 按钮的点击回调
  final VoidCallback? onClearConfirmed;

  /// 清空按钮点击显示默认确认弹窗之后，`取消` 按钮的点击回调
  final VoidCallback? onClearCanceled;

  /// 每一行删除按钮的点击回调。返回值：是否要删除该 entity，如果该 handler 没有实现或者返回 true，则删除
  final SantoItemDeleteCallback<T>? onItemDelete;

  /// 视图显示时的回调
  final VoidCallback? onListShowed;

  /// 视图隐藏时的回调，会把是否是清空按钮触发的销毁视图回传
  final SantoListDismissCallback? onListDismissed;

  OverlayEntry? _overlayEntry;
  double? _leftOffset;
  double _bottomKeyOffset = 0;
  double? _maxWidth;

  /// create SantoSelectedListActionSheet
  SantoSelectedListActionSheet(
      {required this.context,
      this.maxHeight = 290,
      this.bottomOffset = 82,
      this.title,
      this.titleWidget,
      this.isClearButtonHidden = false,
      this.isDeleteButtonHidden = false,
      this.itemIconImage,
      required this.items,
      required this.itemTitleBuilder,
      this.onClear,
      this.onClearConfirmed,
      this.onClearCanceled,
      this.onItemDelete,
      this.onListShowed,
      this.onListDismissed,
      this.controller});

  void _dismissHandler(bool isClear) {
    if (onListDismissed != null) {
      onListDismissed!(isClear);
    }
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  /// bottomWidgetKey: 已选列表下边操作区域绑定的 GlobalKey,已选列表会自动与操作区域左右对齐，且从操作区域的顶部滑出
  void showWithTargetKey({required GlobalKey bottomWidgetKey}) {
    RenderBox? renderBox;
    RenderObject? renderObject =
        bottomWidgetKey.currentContext?.findRenderObject();
    if (renderObject != null && renderObject is RenderBox) {
      renderBox = renderObject;
    }
    var offset = renderBox?.localToGlobal(Offset.zero);
    _leftOffset = offset?.dx ?? 0;
    _maxWidth = renderBox?.size.width ?? MediaQuery.of(context).size.width;
    _bottomKeyOffset = MediaQuery.of(context).size.height - (offset?.dy ?? 0);
    this._innerShow(true);
  }
  /// 展示弹层
  void show() {
    this._innerShow(false);
  }

  void _innerShow(bool showByKey) {
    if (_overlayEntry != null) {
      return;
    }
    SantoSelectedListActionSheetController? tempController = controller;
    if (tempController == null) {
      tempController = SantoSelectedListActionSheetController();
      tempController._isHidden = false;
    }
    _SantoActionSheetSelectedItemListContentWidget content =
        _SantoActionSheetSelectedItemListContentWidget<T>(
      itemWidget: this,
      onDismiss: (isClear) {
        this._dismissHandler(isClear);
      },
      itemTitleBuilder: this.itemTitleBuilder,
      onItemDelete: this.onItemDelete,
      controller: tempController,
    );
    content._overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      if (_maxWidth == null) {
        _maxWidth = MediaQuery.of(context).size.width;
      }
      if (_leftOffset == null) {
        _leftOffset = 0;
      }
      return Positioned(
          top: MediaQuery.of(context).viewInsets.top,
          left: _leftOffset,
          bottom: (showByKey)
              ? _bottomKeyOffset
              : (bottomOffset +
                  MediaQuery.of(context).padding.bottom +
                  MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            width: _maxWidth,
            child: content,
          ));
    });
    content._overlayState!.insert(overlayEntry);
    _overlayEntry = overlayEntry;

    if (onListShowed != null) {
      onListShowed!();
    }
  }
}

// ignore: must_be_immutable
class _SantoActionSheetSelectedItemListContentWidget<T> extends StatefulWidget {
  final SantoSelectedListActionSheet itemWidget;
  final void Function(bool isClear)? onDismiss;
  final SantoItemTitleBuilder<T> itemTitleBuilder;
  final SantoItemDeleteCallback<T>? onItemDelete;
  final SantoSelectedListActionSheetController? controller;

  OverlayState? _overlayState;

  // 位置动画
  late Animation<double> _yAnimation;

  // 背景透明度动画
  late Animation<double> _alphaAnimation;
  late AnimationController _yAnimationController;
  late AnimationController _alphaAnimationController;

  _SantoActionSheetSelectedItemListContentWidget(
      {required this.itemWidget,
      this.onDismiss,
      required this.itemTitleBuilder,
      this.onItemDelete,
      this.controller});

  void dismissWithAnimation() {
    if (_yAnimationController.isCompleted) {
      _yAnimationController.reverse();
    }
    if (_alphaAnimationController.isCompleted) {
      _alphaAnimationController.reverse();
    }
  }

  @override
  State<StatefulWidget> createState() =>
      _SantoActionSheetSelectedItemListState<T>();
}

class _SantoActionSheetSelectedItemListState<T>
    extends State<_SantoActionSheetSelectedItemListContentWidget<T?>>
    with TickerProviderStateMixin {
  bool _isClosedByClear = false;
  SantoSelectedListActionSheetController? _controller;

  @override
  initState() {
    super.initState();

    _controller = widget.controller;
    _controller?.addListener(_onListenHandler);

    this._initStartAnimation();
  }

  @override
  dispose() {
    //路由销毁时需要释放动画资源
    widget._yAnimationController.dispose();
    widget._alphaAnimationController.dispose();
    _controller?.removeListener(_onListenHandler);
    _controller = null;
    super.dispose();
  }

  void _onListenHandler() {
    if (_controller!.isShouldReloadData) {
      if (mounted) {
        setState(() {});
      }
      _controller!.isShouldReloadData = false;
    } else if (_controller!.isSelectedListDismissed) {
      widget.dismissWithAnimation();
      _controller!.isSelectedListDismissed = false;
    }
  }

  void _initStartAnimation() {
    AnimationController yAnimationController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    widget._yAnimationController = yAnimationController;
    AnimationController alphaAnimationController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    widget._alphaAnimationController = alphaAnimationController;
    Animation<double> yAnimation =
        Tween(begin: 65.0, end: this._getContentHeight())
            .animate(yAnimationController)
          ..addListener(() {
            setState(() => {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.dismissed) {
              widget.onDismiss!(_isClosedByClear);
            }
          });
    widget._yAnimation = yAnimation;
    Animation<double> alphaAnimation = Tween(begin: 0.0, end: 0.7)
        .animate(alphaAnimationController)
      ..addListener(() {});
    widget._alphaAnimation = alphaAnimation;
    yAnimationController.forward();
    alphaAnimationController.forward();
  }

  /// 关闭弹窗
  void dismissContent(bool isClear) {
    _isClosedByClear = isClear;
    widget.dismissWithAnimation();
  }

  double _getContentHeight() {
    return widget.itemWidget.maxHeight;
  }

  void _onClearAction() {
    if (widget.itemWidget.onClear == null) {
      // 如果没有实现 onClear，执行默认弹窗并删除的逻辑
      this.dismissContent(true);
      SantoDialogManager.showConfirmDialog(context,
          title: SantoIntl.of(context).localizedResource.confirmClearSelectedList, cancel: SantoIntl.of(context).localizedResource.cancel, confirm: SantoIntl.of(context).localizedResource.ok, onConfirm: () {
        if (widget.itemWidget.onClearConfirmed != null) {
          widget.itemWidget.onClearConfirmed!();
        }
        widget.itemWidget.items.removeRange(0, widget.itemWidget.items.length);
      }, onCancel: () {
        if (widget.itemWidget.onClearCanceled != null) {
          widget.itemWidget.onClearCanceled!();
        }
      });
    } else {
      widget.itemWidget.onClear!();
    }
  }

  void _onDeleteItemAction(int idx) {
    if (idx >= widget.itemWidget.items.length) {
      debugPrint(
          'idx:$idx out of range of selectedModelList:${widget.itemWidget.items.length}!!!');
      return;
    }

    bool shouldDelete = true;
    if (widget.onItemDelete != null) {
      shouldDelete = widget.onItemDelete!(idx, widget.itemWidget.items[idx]);
    }
    if (shouldDelete) {
      setState(() {
        widget.itemWidget.items.remove(widget.itemWidget.items[idx]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    // 顶部标题处理
    String title =
        (widget.itemWidget.title != null && widget.itemWidget.title!.isNotEmpty)
            ? widget.itemWidget.title!
            : SantoIntl.of(context).localizedResource.selectedList;
    TextStyle titleStyle = TextStyle(
        fontSize: commonConfig.fontSizeHead,
        color: Color(0xff17233D),
        fontWeight: FontWeight.w500,
        decoration: TextDecoration.none);
    Widget topTitle = Expanded(
        child: Padding(
      padding: EdgeInsets.fromLTRB(commonConfig.hSpacingLg,
          commonConfig.vSpacingLg, commonConfig.hSpacingLg,
          commonConfig.vSpacingMd),
      child: widget.itemWidget.titleWidget ??
          Text(
            title,
            style: titleStyle,
          ),
    ));
    List<Widget> topWidgetList = [];
    topWidgetList.add(topTitle);
    if (!widget.itemWidget.isClearButtonHidden) {
      Widget clearWidget = GestureDetector(
        onTap: () {
          this._onClearAction();
        },
        child: Padding(
            padding: EdgeInsets.fromLTRB(0, commonConfig.vSpacingLg,
                commonConfig.hSpacingLg, commonConfig.vSpacingMd),
            child: Text(SantoIntl.of(context).localizedResource.clear,
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: commonConfig.fontSizeSubHead,
                    color: Color(0xff808695),
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none))),
      );
      topWidgetList.add(clearWidget);
    }

    // 每一行 item 前的 icon
    Widget itemIcon;
    if (widget.itemWidget.itemIconImage != null) {
      itemIcon = Container(
          color: Colors.white,
          height: 50,
          width: 45,
          padding: EdgeInsets.only(
              left: commonConfig.hSpacingLg, right: 8),
          child: widget.itemWidget.itemIconImage);
    } else {
      itemIcon = Container(color: Colors.white, width: 20);
    }

    // 视图的高度
    double contentHeight = this._getContentHeight();

    return GestureDetector(
      onTap: () {
        this.dismissContent(false);
      },
      child: Container(
          color: Color.fromRGBO(0, 0, 0, widget._alphaAnimation.value),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                onTap: () {},
                child: Container(
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft:
                              Radius.circular(commonConfig.radiusXs),
                          topRight:
                              Radius.circular(commonConfig.radiusXs),
                        ),
                      ),
                    ),
                    height: min(widget._yAnimation.value, contentHeight),
                    child: Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: topWidgetList),
                      Divider(
                        height: 0.5,
                        indent: 0,
                        color: Color(0xFFE8EAEC),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: widget.itemWidget.items.length,
                          itemBuilder: (BuildContext context, int index) {
                            // 是否展示左侧的图标
                            bool shouldHideIcon = false;
                            // 获取标题
                            Widget content = Container(color: Colors.white);
                            if (index < widget.itemWidget.items.length) {
                              var item = widget.itemTitleBuilder(
                                  index, widget.itemWidget.items[index]);
                              if (item is String) {
                                content = Text(
                                  item,
                                  style: TextStyle(
                                      fontSize: commonConfig.fontSizeSubHead,
                                      color: Color(0xff17233D),
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.none),
                                );
                              } else if (item is Widget) {
                                content = item;
                                // 自定义 widget 不显示前边的 icon
                                shouldHideIcon = true;
                              }
                            }
                            return Column(
                              children: <Widget>[
                                Container(
                                  constraints:
                                      const BoxConstraints(minHeight: 50.0),
                                  color: Colors.white,
                                  child: Row(
                                    children: <Widget>[
                                      Offstage(
                                        offstage: shouldHideIcon,
                                        child: itemIcon,
                                      ),
                                      Expanded(
                                        child: content,
                                      ),
                                      Offstage(
                                        offstage: widget
                                            .itemWidget.isDeleteButtonHidden,
                                        child: GestureDetector(
                                          onTap: () {
                                            this._onDeleteItemAction(index);
                                          },
                                          child: Container(
                                              color: Colors.white,
                                              width: 45,
                                              padding: EdgeInsets.only(
                                                  left: commonConfig.hSpacingXs,
                                                  right:
                                                      commonConfig.hSpacingLg),
                                              child: SantoTools.getAssetImage(
                                                  SantoAsset.iconTrashBin)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SantoLine(),
                              ],
                            );
                          },
                        ),
                      )
                    ])),
              )
            ],
          )),
    );
  }
}
