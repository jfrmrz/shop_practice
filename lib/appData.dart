import 'package:flutter/material.dart';

class AppData {
  static String serverUrl = "http://192.168.1.105/flutter_app/";
  //static String serverUrl = "http://192.168.0.100/flutter_app/";
  //static String serverUrl = "http://192.168.0.141/flutter_app/";
  //static String serverUrl = "https://samandevelopment.000webhostapp.com/flutter_app/";

  static goNewScreen(BuildContext context, Widget screen, double x, double y) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return screen;
        },
        transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation, Widget child) {
          return SlideTransition(
            position: new Tween<Offset>(begin: Offset(x, y), end: Offset.zero)
                .animate(animation),
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 300),
      ),
    );
  }

  static bool checkMobileNumber(String number) {
    bool res = false;

    dynamic mobile = int.tryParse(number);
    if (mobile != null) {
      if (mobile.toString().length == 10) {
        if (mobile.toString().substring(0, 1) == "9") {
          res = true;
        }
      }
    }

    return res;
  }

}
