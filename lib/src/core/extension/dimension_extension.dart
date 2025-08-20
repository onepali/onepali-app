import 'package:flutter/widgets.dart';

extension PaddingExtension on num {
  EdgeInsets get p => EdgeInsets.all(toDouble());
  EdgeInsets get ph => EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get pv => EdgeInsets.symmetric(vertical: toDouble());
}

extension RadiusExtension on num {
  BorderRadius get r => BorderRadius.circular(toDouble());
  Radius get radius => Radius.circular(toDouble());
}

extension FontSizeExtension on num {
  double get f => toDouble();
}
