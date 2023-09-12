import 'package:flutter/material.dart';

class TabMenuItem {
  const TabMenuItem(this.iconData, this.text ,this.child);
  final IconData iconData;
  final String text;
  final Widget child;
}