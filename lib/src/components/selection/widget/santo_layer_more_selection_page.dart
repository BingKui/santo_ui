import 'package:bindings_compatible/bindings_compatible.dart';
import 'package:santo_ui/src/components/line/santo_line.dart';
import 'package:santo_ui/src/components/selection/bean/santo_selection_common_entity.dart';
import 'package:santo_ui/src/components/selection/santo_more_selection.dart';
import 'package:santo_ui/src/components/selection/santo_selection_util.dart';
import 'package:santo_ui/src/components/toast/santo_toast.dart';
import 'package:santo_ui/src/l10n/santo_intl.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/theme/configs/santo_selection_config.dart';
import 'package:santo_ui/src/components/icon/santo_icon.dart';
import 'package:santo_ui/src/components/icon/santo_icons.dart';
import 'package:santo_ui/src/components/icon/santo_solid_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 用于展示浮层的筛选项 如商圈
/// 左侧是：二级筛选项 右侧是三级筛选项
/// 默认将第一个元素选中
class SantoLayerMoreSelectionPage extends StatefulWidget {
  final SantoSelectionEntity entityData;
  final SantoSelectionConfig themeData;

  SantoLayerMoreSelectionPage({
    Key? key,
    required this.entityData,
    required this.themeData,
  }) : super(key: key);

  @override
  _SantoLayerMoreSelectionPageState createState() =>
      _SantoLayerMoreSelectionPageState();
}

class _SantoLayerMoreSelectionPageState extends State<SantoLayerMoreSelectionPage>
    with SingleTickerProviderStateMixin {
  List<SantoSelectionEntity> _firstList = [];

  late List<SantoSelectionEntity> _originalSelectedItemsList;

  ///当前选中的 一级筛选条件
  SantoSelectionEntity? _currentFirstEntity;

  ///当前选中的 一级筛选条件的索引
  int _currentIndex = 0;

  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    useWidgetsBinding().addPostFrameCallback((item) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    });
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation =
        Tween(end: Offset.zero, begin: Offset(1.0, 0.0)).animate(_controller);
    _controller.forward();
    _originalSelectedItemsList = widget.entityData.selectedList();

    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        children: <Widget>[
          _buildLeftSlide(context),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return SlideTransition(
                position: _animation,
                child: child,
              );
            },
            child: _buildRightSlide(context),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  ///左侧是黑色浮层
  Widget _buildLeftSlide(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          SantoSelectionUtil.resetSelectionDatas(widget.entityData);
          _originalSelectedItemsList.forEach((data) {
            data.isSelected = true;
          });
          Navigator.maybePop(context);
        },
        child: Container(
          color: Colors.transparent,
        ),
      ),
    );
  }

  ///右侧是二级列表
  Widget _buildRightSlide(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return Container(
      width: 300,
      color: commonConfig.fillBase,
      child: Padding(
        padding: EdgeInsets.only(top: 0),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppBar(
                elevation: 0,
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: commonConfig.colorTextBase,
                  ),
                  onPressed: () {
                    SantoSelectionUtil.resetSelectionDatas(widget.entityData);
                    //将选中的筛选项返回
                    _originalSelectedItemsList.forEach((data) {
                      data.isSelected = true;
                    });
                    Navigator.pop(context, widget.entityData);
                  },
                ),
                systemOverlayStyle: SystemUiOverlayStyle.dark,
                backgroundColor: commonConfig.fillBase,
                title: Text(
                  SantoIntl.of(context).localizedResource.selectTitle(widget.entityData.title),
                  style: TextStyle(
                      color: commonConfig.colorTextBase,
                      fontSize: commonConfig.fontSizeSubHead,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SantoLine(),
              _buildSelectionListView(),
              SantoLine(),
              _buildBottomBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionListView() {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              color: commonConfig.fillBody,
              child: _buildLeftListView(),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: commonConfig.fillBase,
              child: ListView.builder(
                padding: EdgeInsets.only(top: 0),
                itemBuilder: (context, index) {
                  return _buildRightItem(index);
                },
                itemCount: _currentFirstEntity?.children.length ?? 0,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLeftListView() {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            //一级按钮的点击：1、处理点击 2、设置二级的默认选中
            //如果是单选：
            //      如果是选中的情况，则将已选中的兄弟节点清除
            //      如果是未选的情况，则直接选中

            if (index == _currentIndex) {
              return;
            }
            if (_firstList[index].filterType == SantoSelectionFilterType.radio) {
              setState(() {
                _currentIndex = index;
                _currentFirstEntity = _firstList[index];
                if (_currentFirstEntity != null) {
                  if (_currentFirstEntity!.isSelected) {
                    _currentFirstEntity!.clearSelectedEntity();
                  } else {
                    _currentFirstEntity!.parent?.clearSelectedEntity();
                    //设置不限
                    setInitialSecondShowingItem(_currentFirstEntity!);
                  }
                }
              });
            } else {
              _firstList[index].parent?.children.where((data) {
                return data.filterType != SantoSelectionFilterType.checkbox;
              }).forEach((data) {
                data.isSelected = false;
                data.clearChildSelection();
              });

              if (!this._firstList[index].isSelected) {
                if (!SantoSelectionUtil.checkMaxSelectionCount(
                    _firstList[index])) {
                  SantoToast.show(SantoIntl.of(context).localizedResource.filterConditionCountLimited, context);
                  setState(() {});
                  return;
                } else {
                  _currentIndex = index;
                  _currentFirstEntity = _firstList[index];
                  //一级选中的情况，初始化二级
                  setInitialSecondShowingItem(_currentFirstEntity!);
                  setState(() {});
                }
              } else {
                _currentIndex = index;
                _currentFirstEntity = _firstList[index];
                setState(() {});
              }
            }
          },
          child: _buildLeftItem(index),
        );
      },
      itemCount: _firstList.length,
    );
  }

  /// 清空
  Widget _buildBottomBtn() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        height: 80,
        child: MoreBottomSelectionWidget(
          //entity是商圈
          entity: widget.entityData,
          themeData: widget.themeData,
          clearCallback: () {
            setState(() {
              //商圈的重置
              widget.entityData.clearSelectedEntity();
            });
          },
          conformCallback: (data) {
            //带着商圈的数据返回
            data.children.forEach((value) {
              // 如果房山没有选中的子节点， 那么房山就是未选中
              if (value.selectedList().isEmpty) {
                value.isSelected = false;
              } else {
                value.isSelected = true;
              }
            });
            //如果商圈没有选中的 那么商圈就是未选中
            if (data.selectedList().isNotEmpty) {
              data.isSelected = true;
            } else {
              data.isSelected = false;
            }
            Navigator.maybePop(context, data);
          },
        ),
      ),
    );
  }

  Widget _buildLeftItem(int index) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    //如果房山 被选中了或者房山处于正在选择的状态 则加粗
    TextStyle textStyle =
        widget.themeData.flayerNormalTextStyle.generateTextStyle();
    if (index == _currentIndex) {
      textStyle = widget.themeData.flayerSelectedTextStyle.generateTextStyle();
    } else if ((_firstList[index].isSelected) &&
        _firstList[index].selectedList().isNotEmpty) {
      textStyle = widget.themeData.flayerBoldTextStyle.generateTextStyle();
    }

    List<SantoSelectionEntity> list = _firstList[index].selectedList();
    //如果选中了不限 则展示 房山全部
    //如果选中了某几个
    //        如果可以跨区域 则显示数量 否则只加粗
    String name = _firstList[index].title;

    if (list.isNotEmpty) {
      if (list.every((data) {
        return data.isUnLimit();
      })) {
        name += '(全部)';
      } else {
        bool containsCheck = _firstList[index].hasCheckBoxBrother();
        bool containsCheckChildren = false;

        if (_firstList[index].children.isNotEmpty) {
          containsCheckChildren =
              _firstList[index].children[0].hasCheckBoxBrother();
        }
        if (containsCheck && containsCheckChildren) {
          name += '(${list.length})';
        }
      }
    }
    return Container(
      alignment: Alignment.centerLeft,
      height: 48,
      color: index == _currentIndex
          ? commonConfig.fillBase
          : commonConfig.colorTextSecondary,
      child: Padding(
        padding: EdgeInsets.only(left: commonConfig.hSpacingLg),
        child: Text(
          name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textStyle,
        ),
      ),
    );
  }

  Widget _buildRightItem(int index) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    bool isSingle = (_currentFirstEntity?.children[index].filterType ==
            SantoSelectionFilterType.radio) ||
        (_currentFirstEntity?.children[index].filterType ==
            SantoSelectionFilterType.unLimit);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (_currentFirstEntity != null) {
            if (isSingle) {
              _currentFirstEntity!.clearSelectedEntity();
              _currentFirstEntity!.isSelected = true;
              _currentFirstEntity!.children[index].isSelected = true;
            } else {
              _currentFirstEntity!.children.where((data) {
                return data.filterType != SantoSelectionFilterType.checkbox;
              }).forEach((data) {
                data.isSelected = false;
              });
              if (!_currentFirstEntity!.children[index].isSelected) {
                if (!SantoSelectionUtil.checkMaxSelectionCount(
                    this._currentFirstEntity!.children[index])) {
                  SantoToast.show(SantoIntl.of(context).localizedResource.filterConditionCountLimited, context);
                  return;
                }
              }
              this._currentFirstEntity!.children[index].isSelected =
                  !this._currentFirstEntity!.children[index].isSelected;
            }

            //如果二级没有任何选中的，那么一级为不选中
            if (_currentFirstEntity!.selectedList().isEmpty) {
              _currentFirstEntity!.isSelected = false;
            } else {
              _currentFirstEntity!.isSelected = true;
            }
          }
        });
      },
      child: Container(
        alignment: isSingle ? Alignment.centerLeft : Alignment.centerLeft,
        height: 48,
        color: commonConfig.fillBase,
        child: Padding(
          padding: EdgeInsets.only(
              left: commonConfig.hSpacingLg,
              right: commonConfig.hSpacingLg),
          child: isSingle
              ? _buildRightSingleItem(_currentFirstEntity?.children[index])
              : _buildRightMultiItem(_currentFirstEntity?.children[index]),
        ),
      ),
    );
  }

  void _initData() {
    //填充一级筛选数据
    _firstList = widget.entityData.children;
    //找到一级需要显示 的索引
    for (int i = 0; i < _firstList.length; i++) {
      if (_firstList[i].selectedList().isNotEmpty) {
        _firstList[i].isSelected = true;
      }
    }
    _currentIndex = _firstList.indexWhere((data) {
      return data.isSelected;
    });

    if (_currentIndex >= _firstList.length || _currentIndex == -1) {
      _currentIndex = 0;
    }
    //当前选中的一级筛选条件
    _currentFirstEntity = _firstList[_currentIndex];
    _currentFirstEntity?.isSelected = true;

    //找到第二级需要默认选中的索引
    if (_currentFirstEntity != null) {
      setInitialSecondShowingItem(_currentFirstEntity!);
    }
  }

  Widget _buildRightMultiItem(SantoSelectionEntity? entity) {
    if (entity == null) {
      return const SizedBox.shrink();
    } else {
      final commonConfig =
          SantoThemeConfigurator.instance.getConfig().commonConfig;
      return Row(
        children: <Widget>[
          Expanded(
            child: Text(
              entity.title,
              style: entity.isSelected
                  ? widget.themeData.flayerSelectedTextStyle.generateTextStyle()
                  : widget.themeData.flayerNormalTextStyle.generateTextStyle(),
            ),
          ),
          Container(
            height: commonConfig.iconSizeMd,
            width: commonConfig.iconSizeMd,
            child: SantoIcon(
              entity.isSelected ? SantoSolidIcons.checkCircle : SantoIcons.circle,
              solid: entity.isSelected,
              size: commonConfig.iconSizeMd,
              color: entity.isSelected
                  ? commonConfig.brandPrimary
                  : commonConfig.colorTextDisabled,
            ),
          )
        ],
      );
    }
  }

  Widget _buildRightSingleItem(SantoSelectionEntity? entity) {
    if (entity == null) {
      return const SizedBox.shrink();
    } else {
      return Text(entity.title,
          textAlign: TextAlign.left,
          style: entity.isSelected
              ? widget.themeData.flayerSelectedTextStyle.generateTextStyle()
              : widget.themeData.flayerNormalTextStyle.generateTextStyle());
    }
  }

  /// 初始化二级的选中（小白楼）
  /// 规则：如果二级没有选中的，那么 选中二级的不限
  void setInitialSecondShowingItem(SantoSelectionEntity currentFirstEntity) {
    //设置初始化的二级筛选条件 -1没有
    int secondIndex = currentFirstEntity.getFirstSelectedChildIndex();

    // 配置选中不限 : 第一层级是checkbox 并且 没有默认选中的
    if (secondIndex == -1 && currentFirstEntity.children.isNotEmpty) {
      for (int i = 0, n = currentFirstEntity.children.length; i < n; i++) {
        if (currentFirstEntity.children[i].isUnLimit() &&
            currentFirstEntity.filterType == SantoSelectionFilterType.checkbox) {
          currentFirstEntity.children[i].isSelected = true;
          break;
        }
      }
    }

    //如果二级有选中的，一级配置为选中，否则为不选中
    int selectedIndex = currentFirstEntity.children.indexWhere((data) {
      return data.isSelected;
    });
    if (selectedIndex != -1 && currentFirstEntity.children.isNotEmpty) {
      currentFirstEntity.isSelected = true;
    } else {
      currentFirstEntity.isSelected = false;
    }
  }
}
