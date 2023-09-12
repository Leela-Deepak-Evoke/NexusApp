
import 'package:flutter/material.dart';

Future<void> navigate(BuildContext context, String route,
        {bool isDialog = false,
        bool isRootNavigator = true,
        Map<String, dynamic>? arguments}) =>
    Navigator.of(context, rootNavigator: isRootNavigator)
        .pushNamed(route, arguments: arguments);

final homeKey = GlobalKey<NavigatorState>();
final feedkey = GlobalKey<NavigatorState>();
final fourmskey = GlobalKey<NavigatorState>();
final orgupdateskey = GlobalKey<NavigatorState>();
final profileKey = GlobalKey<NavigatorState>();

List<Color> colors = [mediumPurple, Colors.orange, Colors.teal];
const Color mediumPurple = Color.fromRGBO(79, 0, 241, 1.0);