import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
import 'package:evoke_nexus_app/app/screens/tab_bar/tab_bar_handler.dart';
import 'package:evoke_nexus_app/app/screens/tab_bar/tab_bar_screen.dart';
import 'package:evoke_nexus_app/app/utils/constants.dart';
import 'package:evoke_nexus_app/app/widgets/common/error_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../utils/app_routes.dart';

class RootScreenMobile extends ConsumerWidget {
  final BuildContext context; // Add this line

  const RootScreenMobile({super.key, required this.context});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkUserAsyncValue = ref.watch(checkUserProvider);

    void onRetryPressed() {
      ref.read(refresUserProvider(""));
    }

    void logOutAction() {
      GoRouter.of(context).goNamed('/${AppRoute.login.name}');
    }

    if (checkUserAsyncValue is AsyncData) {
      return TabBarHandler(logoutAction: logOutAction, context: this.context);
      // return TabbarScreen(logoutAction: logOutAction);
      // GoRouter.of(context).goNamed('${AppRoute.tabbarscreen.name}}');
      // return const SizedBox.shrink();
    }

    if (checkUserAsyncValue is AsyncLoading) {
      return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(ColorConstants.topbarbg),
            Color(ColorConstants.tabbg),
          ],
        )),
        child: const Center(
          child: SizedBox(
            height: 50.0,
            width: 50.0,
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (checkUserAsyncValue is AsyncError) {
      context.replaceNamed(AppRoute.login.name);
      //context.goNamed('/${AppRoute.login.name}');

      return ErrorScreen(showErrorMessage: true, onRetryPressed: onRetryPressed);
    }

    // This should ideally never be reached, but it's here as a fallback.
    //  context.replaceNamed(AppRoute.login.name);
    context.replaceNamed(AppRoute.login.name);
    return ErrorScreen(showErrorMessage: true, onRetryPressed: onRetryPressed);
    // return Container(color: Colors.green,);
  }
}
