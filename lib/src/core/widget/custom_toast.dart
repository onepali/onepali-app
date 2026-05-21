import 'package:fluttertoast/fluttertoast.dart';
import 'package:onepali/src/src.dart';

void showCustomToaster(
  String message, {
  bool isError = false,
  bool isNormal = false,
}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: isNormal
        ? AppColors.kBlack
        : isError
        ? AppColors.errorColor
        : AppColors.kButtonGreen,
    textColor: AppColors.kWhite,
    fontSize: 14.0,
  );
}
