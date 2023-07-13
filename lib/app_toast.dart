import 'package:fluttertoast/fluttertoast.dart';

class AppToast{
  static void showAppToast(String msg){
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}