import 'package:evoke_nexus_app/app/screens/tab_bar/tab_bar_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabbarScreen extends ConsumerWidget {
  final BuildContext context; // Add this line
  
   TabbarScreen({super.key, required this.context, required this.logoutAction});
  Function() logoutAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  
        //  return TabBarHandler(logoutAction: logoutAction);
        return TabBarHandler(logoutAction: logoutAction, context: this.context);
  }
}