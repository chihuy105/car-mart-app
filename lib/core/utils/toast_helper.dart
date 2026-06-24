import 'dart:async';

import 'package:car_mart/app/exception/failures.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastHelper {
  ToastHelper._();

  static void show(String message) {
    unawaited(
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      ),
    );
  }
}

extension ToastX on BuildContext {
  void showToast(String message) => ToastHelper.show(message);

  void showFailure(Failure failure) => ToastHelper.show(failure.displayMessage);
}
