import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

///标签选择view
class DeleteTagExamplePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TagViewExamplePageState();
}

class TagViewExamplePageState extends State<DeleteTagExamplePage> {
  List<String> tagList = [
    '这是一条很长很长很长很长很长很长很长很长很长很长的标签',
    '标签信息',
    '标签信息标签信息',
    '标签信息',
    '标签信息标签信息标签信息标签信息'
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(
        title: 'SantoDeleteTag',
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[_buildDeleteWidget()],
        ),
      ),
    );
  }

  Widget _buildDeleteWidget() {
    SantoDeleteTagController controller = SantoDeleteTagController(initTags: [
      '这是一条很长很长很长很长很长很长很长很长很长很长的标签',
      '标签信息',
      '标签信息标签信息',
      '标签信息',
      '标签信息标签信息标签信息标签信息'
    ]);

    return Container(
      margin: EdgeInsets.only(top: 20),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          SantoDeleteTag(
            controller: controller,
            onTagDelete: (tags, tag, index) {
              SantoToast.show(
                  '剩余的标签为：${tags.toString()},删除了的标签为：$tag  ,删除的标签index为$index',
                  context);
            },
          ),
          SantoDeleteTag(
            controller: controller,
            tagTextStyle: TextStyle(color: Colors.blue, fontSize: 20),
            deleteIconSize: Size(16, 16),
            onTagDelete: (tags, tag, index) {
              SantoToast.show(
                  '剩余的标签为：${tags.toString()},删除了的标签为：$tag  ,删除的标签index为$index',
                  context);
            },
          ),
          SantoDeleteTag(
            controller: controller,
            tagTextStyle: TextStyle(color: Colors.yellow),
            backgroundColor: Colors.blue,
            deleteIconColor: Colors.red,
            softWrap: false,
            onTagDelete: (tags, tag, index) {
              SantoToast.show(
                  '剩余的标签为：${tags.toString()},删除了的标签为：$tag  ,删除的标签index为$index',
                  context);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SantoIconButton(
                name: '',
                iconWidget: Icon(Icons.add),
                widgetWidth: 48,
                widgetHeight: 48,
                onTap: () => controller.addTag('增加的tag'),
              ),
              SantoIconButton(
                name: '',
                iconWidget: Icon(Icons.delete_forever),
                widgetWidth: 48,
                widgetHeight: 48,
                onTap: () => controller.deleteForIndex(0),
              )
            ],
          )
        ],
      ),
    );
  }
}
