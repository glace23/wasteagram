import 'package:flutter/material.dart';

Widget formWidgetPadding(
    {required Widget formWidget, required double padding}) {
  return Padding(
    padding: EdgeInsets.all(padding),
    child: formWidget,
  );
}

double getScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}
