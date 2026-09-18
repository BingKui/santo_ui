

import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

class TextValueArrowContentExample extends StatefulWidget {
  @override
  _TextValueArrowContentExampleState createState() =>
      _TextValueArrowContentExampleState();
}

class _TextValueArrowContentExampleState
    extends State<TextValueArrowContentExample> {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(      title: 'value带有操作箭头',
      children: <Widget>[
ExampleIntro('card'),
SantoSection(
        title: '正常案例',
        description: '紧随布局下 isArrow 展示右侧箭头，问号与超链接均可点',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        SantoPairInfoTable(
          isValueAlign: false,
          children: <SantoInfoModal>[
            SantoInfoModal(
                keyPart: "名称：",
                valuePart: "内容内容内容内容",
                isArrow: true,
                valueClickCallback: () {
                  SantoToast.show('内容内容内容内容', context);
                }),
            SantoInfoModal(
                keyPart: "名称名：",
                valuePart: "内容内容内容内容内容",
                isArrow: true,
                valueClickCallback: () {
                  SantoToast.show('内容内容内容内容', context);
                }),
            SantoInfoModal.keyOrValueLastQuestionInfo(context,"名称名称名称", "内容内容内容内容内容",
                keyShow: true,
                valueShow: true,
                keyCallback: () {
                  SantoToast.show('key question', context);
                },
                valueCallback: () {
                  SantoToast.show('value question', context);
                },
                isArrow: true,
                valueClickCallback: () {
                  SantoToast.show('内容内容内容内容', context);
                }),
            SantoInfoModal.valueLastClickInfo(context,"名称名称名称", "内容内容内容内容内容", "超链接",
                clickCallback: (value) {
                  SantoToast.show(value!, context);
                },
                isArrow: true,
                valueClickCallback: () {
                  SantoToast.show('内容内容内容内容', context);
                }),
          ],
        )],
        ),
      ),
SantoSection(
        title: '正常案例',
        description: '对齐布局下 isArrow 展示右侧箭头，value 对齐展示',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        SantoPairInfoTable(
          isValueAlign: true,
          children: <SantoInfoModal>[
            SantoInfoModal(
                keyPart: "名称：",
                valuePart: "内容内容内容内容",
                isArrow: true,
                valueClickCallback: () {
                  SantoToast.show('内容内容内容内容', context);
                }),
            SantoInfoModal(
                keyPart: "名称名：",
                valuePart: "内容内容内容内容内容",
                isArrow: true,
                valueClickCallback: () {
                  SantoToast.show('内容内容内容内容', context);
                }),
            SantoInfoModal.keyOrValueLastQuestionInfo(context,"名称名称名称", "内容内容内容内容内容",
                keyShow: true,
                valueShow: true,
                keyCallback: () {
                  SantoToast.show('key question', context);
                },
                valueCallback: () {
                  SantoToast.show('value question', context);
                },
                isArrow: true,
                valueClickCallback: () {
                  SantoToast.show('内容内容内容内容', context);
                }),
            SantoInfoModal.valueLastClickInfo(context,"名称名称名称", "内容内容内容内容内容", "超链接",
                clickCallback: (value) {
                  SantoToast.show(value!, context);
                },
                isArrow: true,
                valueClickCallback: () {
                  SantoToast.show('内容内容内容内容', context);
                })
          ],
        )],
        ),
      ),
SantoSection(
        title: '异常案例正常案例 key过长',
        description: '紧随布局下 key 超长省略，箭头与问号仍可见',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        SantoPairInfoTable(
          isValueAlign: false,
          children: <SantoInfoModal>[
            SantoInfoModal(
                keyPart: "名称：",
                valuePart: "内容内容内容内容",
                isArrow: true,
                valueClickCallback: () {
                  SantoToast.show('内容内容内容内容', context);
                }),
            SantoInfoModal(
                keyPart: "名称名：",
                valuePart: "内容内容内容内容内容",
                isArrow: true,
                valueClickCallback: () {
                  SantoToast.show('内容内容内容内容', context);
                }),
            SantoInfoModal.keyOrValueLastQuestionInfo(context,
                "名称名称名称名称名称名名称名称名称名称", "内容内容内容内容内容",
                keyShow: true,
                valueShow: true,
                keyCallback: () {
                  SantoToast.show('key question', context);
                },
                valueCallback: () {
                  SantoToast.show('value question', context);
                },
                isArrow: true,
                valueClickCallback: () {
                  SantoToast.show('内容内容内容内容', context);
                }),
          ],
        )],
        ),
      ),
SantoSection(
        title: '异常案例正常案例 key过长',
        description: '对齐布局下 key 超长，value 与箭头不被挤出',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        SantoPairInfoTable(
          isValueAlign: true,
          children: <SantoInfoModal>[
            SantoInfoModal(
                keyPart: "名称：",
                valuePart: "内容内容内容内容",
                isArrow: true,
                valueClickCallback: () {
                  SantoToast.show('内容内容内容内容', context);
                }),
            SantoInfoModal(
                keyPart: "名称名：",
                valuePart: "内容内容内容内容内容",
                isArrow: true,
                valueClickCallback: () {
                  SantoToast.show('内容内容内容内容', context);
                }),
            SantoInfoModal.keyOrValueLastQuestionInfo(context,
                "名称名称名称名称名称名名称名称名称名称", "内容内容内容内容内容",
                keyShow: true,
                valueShow: true,
                keyCallback: () {
                  SantoToast.show('key question', context);
                },
                valueCallback: () {
                  SantoToast.show('value question', context);
                },
                isArrow: true,
                valueClickCallback: () {
                  SantoToast.show('内容内容内容内容', context);
                }),
          ],
        )],
        ),
      ),
SantoSection(
        title: '异常案例正常案例 内容过长',
        description: '对齐布局下 value 过长省略，箭头固定在行尾',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        SantoPairInfoTable(
          isValueAlign: true,
          children: <SantoInfoModal>[
            SantoInfoModal(
                keyPart: "名称：",
                valuePart: "内容内容内容内容",
                isArrow: true,
                valueClickCallback: () {
                  SantoToast.show('内容内容内容内容', context);
                }),
            SantoInfoModal(
                keyPart: "名称名：",
                valuePart: "内容内容内容内容内容",
                isArrow: true,
                valueClickCallback: () {
                  SantoToast.show('内容内容内容内容', context);
                }),
            SantoInfoModal.keyOrValueLastQuestionInfo(context,
                "名称名称名", "内容内容内容内容内容内容内容内容内容内容",
                keyShow: true,
                valueShow: true,
                keyCallback: () {
                  SantoToast.show('key question', context);
                },
                valueCallback: () {
                  SantoToast.show('value question', context);
                },
                isArrow: true,
                valueClickCallback: () {
                  SantoToast.show('内容内容内容内容', context);
                }),
          ],
        )],
        ),
      ),
SantoSection(
        title: '异常案例正常案例 内容过长',
        description: '紧随布局下 value 过长省略，超链接与箭头仍可点击',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        SantoPairInfoTable(
          isValueAlign: false,
          children: <SantoInfoModal>[
            SantoInfoModal(
                keyPart: "名称：",
                valuePart: "内容内容内容内容",
                isArrow: true,
                valueClickCallback: () {
                  SantoToast.show('内容内容内容内容', context);
                }),
            SantoInfoModal(
                keyPart: "名称名：",
                valuePart: "内容内容内容内容内容",
                isArrow: true,
                valueClickCallback: () {
                  SantoToast.show('内容内容内容内容', context);
                }),
            SantoInfoModal.keyOrValueLastQuestionInfo(context,
                "名称名称名", "内容内容内容内容内容内容内容内容内容内容",
                keyShow: true,
                valueShow: true,
                keyCallback: () {
                  SantoToast.show('key question', context);
                },
                valueCallback: () {
                  SantoToast.show('value question', context);
                },
                isArrow: true,
                valueClickCallback: () {
                  SantoToast.show('内容内容内容内容', context);
                }),
          ],
        )],
        ),
      ),
      ],
    );
  }
}
