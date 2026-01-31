import 'package:flutter/material.dart';

class AppRoutes {
  AppRoutes._();

  //to push and keep on stack
  static void push(context, page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  //to replace current page by new one
  static void pushReplacement(context, page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  //get current one
  static void pop(context) {
    Navigator.pop(context);
  }

  static void popToFirstRoute(context, routeName) {
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }

  static void pushAndRemoveUntil(context, page, routeName) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => page),
      ModalRoute.withName(routeName),
    );
  }
}
