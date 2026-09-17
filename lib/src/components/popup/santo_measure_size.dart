import 'package:bindings_compatible/bindings_compatible.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef OnWidgetSizeChange = void Function(Size size);

/// 监听 Widget 宽高的工具类。
class MeasureSizeRenderObject extends RenderProxyBox {
  Size? oldSize;
  final OnWidgetSizeChange onChanged;

  MeasureSizeRenderObject(this.onChanged);

  @override
  void performLayout() {
    super.performLayout();

    Size newSize = Size.zero;
    if (child != null) {
      newSize = child!.size;
    }
    if (oldSize == newSize) return;

    oldSize = newSize;

    useWidgetsBinding().addPostFrameCallback((item) {
      onChanged(newSize);
    });
  }
}

/// 监听 Widget 宽高变化的工具类
class MeasureSize extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChange onChanged;

  const MeasureSize({
    Key? key,
    required this.onChanged,
    required Widget child,
  }) : super(key: key, child: child);
  @override
  RenderObject createRenderObject(BuildContext context) {
    return MeasureSizeRenderObject(onChanged);
  }
}
