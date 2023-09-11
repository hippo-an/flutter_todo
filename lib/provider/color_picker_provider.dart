import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_todo/consts/enums.dart';
import 'package:todo_todo/models/color_picker_model.dart';

class ColorPickerProvider extends ChangeNotifier {
  List<ColorPickerModel> pickerColors = [];

  double currentPosition = 0;
  int duration = 0;
  late Color currentColor;
  int currentIndex = 0;
  List<ColorType> colorType = List.generate(
      ColorType.values.length, (index) => ColorType.values[index]);

  void _colorState(ColorType type) {
    pickerColors = List.generate(
        50,
            (index) => ColorPickerModel(
          index: (index - 49).abs(),
          color: Color.fromRGBO(
              (type.rgb[0] + index > 255) ? 255 : type.rgb[0] + index,
              (type.rgb[1] + index > 255) ? 255 : type.rgb[1] + index,
              (type.rgb[2] + index > 255) ? 255 : type.rgb[2] + index,
              1),
        ));
    pickerColors = pickerColors.reversed.toList();
    pickerColors.addAll([
      ...List.generate(
          50,
              (index) => ColorPickerModel(
            index: 50 + index,
            color: Color.fromRGBO(
              (type.rgb[0] - index < 0) ? 0 : type.rgb[0] - index,
              (type.rgb[1] - index < 0) ? 0 : type.rgb[1] - index,
              (type.rgb[2] - index < 0) ? 0 : type.rgb[2] - index,
              1,
            ),
          ))
    ]);
  }

  void colorChanged(ColorType type, int index) {
    _colorState(type);
    currentIndex = index;
    currentColor = pickerColors[49].color;
    currentPosition =
        ((MediaQueryData.fromView(window).size.width - 40) / 100) * 50;
    notifyListeners();
  }

  void pickerColorTap(ColorPickerModel data) {
    HapticFeedback.mediumImpact();
    duration = 200;
    double width = (MediaQueryData.fromWindow(window).size.width - 40);
    currentColor = data.color;
    currentPosition = (width / 100) * data.index;
    currentPosition = currentPosition < 20
        ? 10
        : currentPosition > (width - 20)
        ? (width - 20)
        : currentPosition;
    notifyListeners();
  }

  void dragUpdate(DragUpdateDetails? details) {
    HapticFeedback.lightImpact();
    double dx = details!.delta.dx;
    double itemWidth = (MediaQueryData.fromWindow(window).size.width) - 40;
    currentPosition = (currentPosition + dx < 10) ||
        (currentPosition + dx > itemWidth - 20)
        ? currentPosition
        : currentPosition + dx;
    currentColor = pickerColors[currentPosition ~/ (itemWidth / 100)].color;
    notifyListeners();
  }

  void dragStart(DragStartDetails? details) {
    HapticFeedback.mediumImpact();
    duration = 0;
    notifyListeners();
  }
}