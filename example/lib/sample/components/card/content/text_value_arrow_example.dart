

import 'package:santo_ui/santo_ui.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SantoAppBar(
        title: 'value带有操作箭头',
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '规则',
              style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            SantoBubbleText(
              maxLines: 4,
              text: 'value带有操作箭头，箭头在最右侧，value单行展示',
            ),
            Text(
              '正常案例',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
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
            ),
            Text(
              '正常案例',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
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
            ),
            Text(
              '异常案例正常案例 key过长',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
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
            ),
            Text(
              '异常案例正常案例 key过长',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
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
            ),
            Text(
              '异常案例正常案例 内容过长',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
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
            ),
            Text(
              '异常案例正常案例 内容过长',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
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
            ),
          ],
        ),
      ),
    );
  }
}
