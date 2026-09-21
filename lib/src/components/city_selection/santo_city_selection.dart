import 'dart:convert';

import 'package:santo_ui/src/components/empty/santo_empty.dart';
import 'package:santo_ui/src/components/navbar/santo_appbar.dart';
import 'package:santo_ui/src/components/selectcity/santo_az_common.dart';
import 'package:santo_ui/src/components/selectcity/santo_az_listview.dart';
import 'package:santo_ui/src/components/selectcity/santo_select_city_model.dart';
import 'package:santo_ui/src/components/sugsearch/santo_search_text.dart';
import 'package:santo_ui/src/constants/santo_strings_constants.dart';
import 'package:santo_ui/src/l10n/santo_intl.dart';
import 'package:santo_ui/src/constants/santo_fonts_constants.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lpinyin/lpinyin.dart';

/// 简述：[SantoCitySelection]是用于城市选择的单选页面，
/// 功能：多可以自定制导航栏文案，搜索文案信息，定位信息，右侧可快速滑动查看城市
class SantoCitySelection extends StatefulWidget {
  /// 页面标题，默认空
  final String? appBarTitle;

  /// 热门推荐标题，默认空
  final String? hotCityTitle;

  /// 是否展示searchBar，默认 true
  final bool showSearchBar;

  /// 当前城市定位文案展示
  final String locationText;

  /// 城市列表
  final List<SantoSelectCityModel>? cityList;

  /// 热门推荐城市列表
  final List<SantoSelectCityModel> hotCityList;

  /// 单选项 点击的回调
  final ValueChanged<SantoSelectCityModel>? onChanged;

  /// 空页面中间展位图展示
  final Image? emptyImage;

  SantoCitySelection({
    this.appBarTitle = '',
    this.hotCityTitle = '',
    required this.hotCityList,
    this.cityList,
    this.showSearchBar = true,
    this.locationText = '',
    this.onChanged,
    this.emptyImage,
  });

  @override
  State<StatefulWidget> createState() {
    return _SantoCitySelectionState();
  }
}

class _SantoCitySelectionState extends State<SantoCitySelection> {
  List<SantoSelectCityModel> _cityList = [];

  ///搜索框的高度
  int _suspensionHeight = 40;

  /// 热门的按钮高度
  int _itemHeight = 50;

  ///当前展示的文案信息
  String _suspensionTag = "";

  ///是否展示城市的stack
  bool _showCityStack = true;

  ///搜索的文案
  String _searchText = "";

  /// search的TextController
  late SantoSearchTextController _santoSearchTextController;

  @override
  void initState() {
    super.initState();
    _santoSearchTextController = SantoSearchTextController();
    _loadData();
  }

  void _loadData() async {
    if (widget.cityList == null || widget.cityList!.isEmpty) {
      //加载城市列表
      rootBundle
          .loadString(
              'packages/${SantoStrings.flutterPackageName}/assets/json/china.json')
          .then((value) {
        Map countyMap = json.decode(value);
        List list = countyMap['china'];
        list.forEach((value) {
          _cityList.add(SantoSelectCityModel(name: value['name']));
        });
        _handleList(_cityList);
        setState(() {});
      });
    } else {
      _cityList = widget.cityList!;
      _handleList(_cityList);
      setState(() {});
    }
  }

  void _handleList(List<SantoSelectCityModel>? list) {
    if (list == null || list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyinE(list[i].name);
      String tag = pinyin.substring(0, 1).toUpperCase();
      list[i].namePinyin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        list[i].tagIndex = tag;
        list[i].tag = tag;
      } else {
        list[i].tagIndex = "#";
        list[i].tag = "#";
      }
    }
    //根据A-Z排序
    SuspensionUtil.sortListBySuspensionTag(_cityList);
  }

  void _onSusTagChanged(String tag) {
    setState(() {
      _suspensionTag = tag;
    });
  }

  Widget _buildHeader() {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    List<SantoSelectCityModel> hotCityList = widget.hotCityList;
    double width = (MediaQuery.of(context).size.width - 70) / 3;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: commonConfig.hSpacingLg,
              right: commonConfig.hSpacingSm,
              top: commonConfig.vSpacingLg,
              bottom: 0),
          child: Text(
            widget.hotCityTitle ?? SantoIntl.of(context).localizedResource.recommandCity,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(
              left: commonConfig.hSpacingLg,
              right: commonConfig.hSpacingLg,
              top: commonConfig.vSpacingSm,
              bottom: 0),
          child: Wrap(
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            spacing: commonConfig.hSpacingSm,
            children: hotCityList.map((e) {
              return OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.all(0),
                  side: BorderSide(color: Color(0xFFF5F5F5), width: .5),
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(commonConfig.radiusXs),
                  ),
                ),
                child: Container(
                  alignment: Alignment.center,
                  height: 36.0,
                  width: width,
                  padding: EdgeInsets.all(0),
                  child: Text(
                    e.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF17233D),
                      fontSize: SantoFonts.f12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                onPressed: () {
                  debugPrint("OnItemClick: $e");
                  if (widget.onChanged != null) {
                    widget.onChanged!(e);
                  }
                  Navigator.pop(context, e);
                },
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  Widget _buildSusWidget(String? susTag) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return Container(
      height: _suspensionHeight.toDouble(),
      padding: EdgeInsets.only(left: commonConfig.hSpacingMd),
      color: Color(0xfff3f4f5),
      alignment: Alignment.centerLeft,
      child: Text(
        '$susTag',
        softWrap: false,
        style: TextStyle(
          fontSize: commonConfig.fontSizeBase,
          color: Color(0xff808695),
        ),
      ),
    );
  }

  Widget _buildListItem(SantoSelectCityModel model) {
    String susTag = model.getSuspensionTag();
    return Column(
      children: <Widget>[
        Offstage(
          offstage: model.isShowSuspension != true,
          child: _buildSusWidget(susTag),
        ),
        SizedBox(
          height: _itemHeight.toDouble(),
          child: ListTile(
            title: Text(model.name),
            onTap: () {
              debugPrint("OnItemClick: $model");
              if (widget.onChanged != null) {
                widget.onChanged!(model);
              }
              Navigator.pop(context, model);
            },
          ),
        )
      ],
    );
  }

  Widget _buildSearchBar() {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return SantoSearchText(
      // 四周统一取 hSpacingMd，避免左右 20 / 上下 10 不一致
      innerPadding: EdgeInsets.all(commonConfig.hSpacingMd),
      searchController: _santoSearchTextController,
      hintText: SantoIntl.of(context).localizedResource.inputSearchTip,
      onTextChange: (text) {
        _searchText = text;
        _showCityStack = text.isEmpty;
        setState(() {});
      },
      onTextCommit: (text) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      onActionTap: () {
        _showCityStack = true;
        _santoSearchTextController.isActionShow = false;
        _santoSearchTextController.isClearShow = false;
        setState(() {
          FocusScope.of(context).requestFocus(FocusNode());
        });
      },
    );
  }

  ///定位当前 城市
  Widget _buildLocationBar(String locationText) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return Container(
        padding: EdgeInsets.only(
            left: commonConfig.hSpacingLg,
            right: commonConfig.hSpacingSm,
            top: commonConfig.vSpacingSm,
            bottom: commonConfig.vSpacingSm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.place,
              size: 20.0,
            ),
            Text(locationText),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: SantoAppBar(title: widget.appBarTitle ?? SantoIntl.of(context).localizedResource.selectCity),
        // 用 Material 承载白色背景，保证列表 ListTile 的墨水涟漪画在最近的 Material 上，
        // 避免中间的 DecoratedBox 把水波纹盖住（ListTile debug 断言会报错）
        body: Material(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              widget.locationText.isEmpty
                  ? const SizedBox.shrink()
                  : _buildLocationBar(widget.locationText),
              widget.showSearchBar ? _buildSearchBar() : const SizedBox.shrink(),
              const Divider(
                height: 0.5,
                thickness: 0.5,
                color: Color(0xFFE8EAEC),
              ),
              _showCityStack
                  ? _buildCityList()
                  : _buildSearchResultList(_searchText),
            ],
          ),
        ));
  }

  ///展示城市列表
  Widget _buildCityList() {
    int num = widget.hotCityList.length ~/ 3;
    int rem = widget.hotCityList.length % 3;
    int addRem = (rem > 0) ? 1 : 0;
    int headerHeight = (num + addRem) * 38 + 20 + 42 + 10;
    if (num == 0 && rem == 0) {
      headerHeight = 0;
    }
    if (_suspensionTag.isEmpty || _suspensionTag == '') {
      if (_cityList.isNotEmpty) {
        _suspensionTag = _cityList.first.tag;
      }
    }
    return Expanded(
        flex: 1,
        child: AzListView(
          data: _cityList,
          itemBuilder: (context, model) =>
              _buildListItem(model as SantoSelectCityModel),
          suspensionWidget: _buildSusWidget(_suspensionTag),
          isUseRealIndex: true,
          itemHeight: _itemHeight,
          suspensionHeight: _suspensionHeight,
          onSusTagChanged: _onSusTagChanged,
          header: AzListViewHeader(
              tag: "#",
              height: headerHeight,
              builder: (context) {
                return _buildHeader();
              }),
          indexHintBuilder: (context, hint) {
            return Container(
              alignment: Alignment.center,
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                  color: Color(0x2217233D),
                  borderRadius: BorderRadius.circular(
                      SantoThemeConfigurator.instance
                          .getConfig()
                          .commonConfig
                          .radiusXs)),
              child: Text(hint,
                  style: TextStyle(color: Colors.white, fontSize: 20.0)),
            );
          },
        ));
  }

  ///城市搜索结果页
  Widget _buildSearchResultList(String searchText) {
    List<SantoSelectCityModel> cList = _searchCityList(searchText);
    return (cList.isEmpty)
        ? _noDataWidget()
        : Expanded(
            flex: 1,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return _buildListItem(cList[index]);
              },
              itemCount: cList.length,
            ),
          );
  }

  ///没有数据的占位图
  Widget _noDataWidget() {
    return Container(
      child: SantoEmpty(
        imageType: SantoEmptyImageType.listEmpty,
        title: SantoIntl.of(context).localizedResource.noSearchData,
      ),
    );
  }

  ///获取城市搜索结果
  List<SantoSelectCityModel> _searchCityList(String searchText) {
    List<SantoSelectCityModel> cList = [];
    for (int index = 0; index < _cityList.length; index++) {
      SantoSelectCityModel cInfo = _cityList[index];
      if (cInfo.name.contains(searchText) ||
          cInfo.tag.contains(searchText) ||
          cInfo.tag.contains(searchText.toUpperCase())) {
        cList.add(cInfo);
      }
    }
    return cList;
  }
}
