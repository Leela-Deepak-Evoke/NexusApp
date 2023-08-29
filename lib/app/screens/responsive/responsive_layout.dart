import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget smallScreenLayout;
  final Widget mediumScreenLayout;
  final Widget largeScreenLayout;

  const ResponsiveLayout({
    super.key,
    required this.smallScreenLayout,
    required this.mediumScreenLayout,
    required this.largeScreenLayout,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: ((context, constraints) {
      if (constraints.maxWidth < 1100) {
        return smallScreenLayout;
      }  else {
        return largeScreenLayout;
      }
    }));
  }
}
