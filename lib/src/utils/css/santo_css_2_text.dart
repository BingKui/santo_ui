import 'package:santo_ui/src/utils/css/santo_core_funtion.dart';
import 'package:flutter/material.dart';

/// 将CSS格式的标签转为文本
class SantoCSS2Text {
  const SantoCSS2Text._();

  static TextSpan toTextSpan(
    String htmlContent, {
    SantoHyperLinkCallback? linksCallback,
    TextStyle? defaultStyle,
  }) {
    return TextSpan(
      children: SantoConvert(
        htmlContent,
        linkCallBack: linksCallback,
        defaultStyle: defaultStyle,
      ).convert(),
    );
  }

  static Text toTextView(
    String htmlContent, {
    SantoHyperLinkCallback? linksCallback,
    TextStyle? defaultStyle,
    int? maxLines,
    TextAlign? textAlign,
    TextOverflow? textOverflow,
  }) {
    return Text.rich(
      toTextSpan(
        htmlContent,
        linksCallback: linksCallback,
        defaultStyle: defaultStyle,
      ),
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: textOverflow ?? TextOverflow.clip,
    );
  }
}
