import 'package:flutter/widgets.dart';

extension HeightWidthExtension on num {
  double h(BuildContext context) =>
      MediaQuery.of(context).size.height * (this / 100);

  double w(BuildContext context) =>
      MediaQuery.of(context).size.width * (this / 100);
}
