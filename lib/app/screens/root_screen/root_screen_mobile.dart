import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
import 'package:evoke_nexus_app/app/screens/tab_bar/tab_bar_handler.dart';
import 'package:evoke_nexus_app/app/utils/constants.dart';
import 'package:evoke_nexus_app/app/widgets/common/error_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../utils/app_routes.dart';

class RootScreenMobile extends ConsumerWidget {
  const RootScreenMobile({super.key});
  // static const String errorMessage = "An error occurred. Please try again.";

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
      return TabBarHandler(
          logoutAction: logOutAction,
          rootScreenMobileContext: context,
          user: checkUserAsyncValue.value);
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
      GoRouter.of(context).goNamed('/${AppRoute.login.name}');

      return ErrorScreen(
          showErrorMessage: true, onRetryPressed: onRetryPressed);

      // return Container(
      //   color: Colors.white, // Set your desired background color
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Text('An error occurred. Please try again. ${checkUserAsyncValue.error.hashCode}',
      //           style: TextStyle(
      //             color: Colors.black87,
      //             fontSize: 16.0,
      //             fontWeight: FontWeight.bold,
      //             fontFamily: GoogleFonts.poppins().fontFamily,
      //           )),
      //       const SizedBox(height: 20.0), // Adjust spacing as needed
      //       ElevatedButton(
      //         onPressed: onRetryPressed,
      //         style: ElevatedButton.styleFrom(
      //           backgroundColor: Colors.red[700],
      //         ),
      //         child: Text(
      //           "Try Again",
      //           style: TextStyle(
      //             color: Colors.white,
      //             fontSize: 16.0,
      //             fontFamily: GoogleFonts.poppins().fontFamily,
      //             fontWeight: FontWeight.normal,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // );
    }

    // This should ideally never be reached, but it's here as a fallback.
    context.replaceNamed(AppRoute.login.name);
    return Text('An error occurred: ${checkUserAsyncValue.error}');
    // return ErrorScreen(showErrorMessage: true, onRetryPressed: onRetryPressed);
  }
}
