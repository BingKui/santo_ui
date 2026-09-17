import 'package:flutter/material.dart';

import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// Default value of DatePicker's item [TextStyle].
final TextStyle datetimePickerItemTextStyle = TextStyle(
  color: Color(0xFF17233D),
  fontSize:
      SantoThemeConfigurator.instance.getConfig().commonConfig.fontSizeHead,
);

/// Default value of DatePicker's background color.
const pickerBackgroundColor = Colors.white;

/// Default value of whether show title widget or not.
const pickerShowTitleDefault = true;

/// Default value of DatePicker's height.
const double pickerHeight = 240.0;

/// Default value of DatePicker's title height.
const double pickerTitleHeight = 48.0;

/// Default value of DatePicker's column height.
const double pickerItemHeight = 48.0;

/// Default value of DatePicker's item [TextStyle].
final TextStyle pickerItemTextStyle = TextStyle(
  color: Color(0xFF17233D),
  fontSize:
      SantoThemeConfigurator.instance.getConfig().commonConfig.fontSizeHead,
);
