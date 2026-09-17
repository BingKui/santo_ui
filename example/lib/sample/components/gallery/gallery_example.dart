

import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/components/gallery/gallery_detail_page_theme_example.dart';
import 'package:example/sample/home/list_item.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GalleryExample extends StatelessWidget {
  List<SantoPhotoGroupConfig> allConfig = [
    SantoPhotoGroupConfig.url(title: '第一项', urls: <String>[
      'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
      'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
      'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
      'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
      'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
      'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
    ]),
    SantoPhotoGroupConfig(title: "信息", configList: [
      SantoPhotoItemConfig(
          url: 'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
          showBottom: true,
          bottomCardModel: PhotoBottomCardState.cantFold,
          name: "一只猫",
          des:
              "图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述"),
      SantoPhotoItemConfig(
          url: 'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
          showBottom: true,
          bottomCardModel: PhotoBottomCardState.fold,
          name: "两只猫",
          des: "图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述"),
      SantoPhotoItemConfig(
          url: 'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
          showBottom: true,
          bottomCardModel: PhotoBottomCardState.unFold,
          name: "三只猫",
          des:
              "图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述"),
      SantoPhotoItemConfig(
          url: 'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
          showBottom: false,
          name: "一张图片",
          des:
              "图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述")
    ]),
    SantoPhotoGroupConfig.url(title: '第二项', urls: <String>[
      'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
      'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
    ]),
    SantoPhotoGroupConfig.url(title: '第三项', urls: <String>[
      'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
      'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
    ]),
    SantoPhotoGroupConfig.url(title: '第四项', urls: <String>[
      'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
      'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
    ]),
    SantoPhotoGroupConfig(title: "带展示信息的模块", configList: [
      SantoPhotoItemConfig(
          url: 'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
          showBottom: true,
          bottomCardModel: PhotoBottomCardState.fold,
          name: "一张图片",
          des: "图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述")
    ]),
    SantoPhotoGroupConfig(title: "带展示信息的模块", configList: [
      SantoPhotoItemConfig(
          url: 'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
          showBottom: true,
          bottomCardModel: PhotoBottomCardState.fold,
          name: "一张图片",
          des:
              "图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述")
    ]),
    SantoPhotoGroupConfig(title: "带展示信息的模块", configList: [
      SantoPhotoItemConfig(
          url: 'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
          showBottom: true,
          bottomCardModel: PhotoBottomCardState.fold,
          name: "一张图片",
          des:
              "图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述图片描述")
    ])
  ];

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: "Gallery 图片",
        children: <Widget>[
          SantoSection(
            title: '缩略图列表',
            description: '进入 SantoGallerySummaryPage，按分组查看多张图片',
            child: ListItem(
              title: "图片选择控件",
              isShowLine: false,
              describe: "查看图片列表页",
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return SantoGallerySummaryPage(allConfig: allConfig);
                  },
                ));
              },
            ),
          ),
          SantoSection(
            title: '大图详情',
            description: '进入详情入口页，可选 light 或 dark 主题查看大图',
            child: ListItem(
              title: "图片详情查看",
              describe: '跳转第一项的第五张图',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return GalleryDetailPageThemeExample();
                  },
                ));
              },
            ),
          ),
        ],
    );
  }
}
