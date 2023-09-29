
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
import 'package:evoke_nexus_app/app/screens/tab_bar/tab_bar_screen.dart';
import 'package:evoke_nexus_app/app/utils/constants.dart';
import 'package:evoke_nexus_app/app/widgets/common/error_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../utils/app_routes.dart';

class RootScreenMobile extends ConsumerWidget {
  const RootScreenMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkUserAsyncValue = ref.watch(checkUserProvider);

    void logOutAction()
    {

    }
    if (checkUserAsyncValue is AsyncData) {
      
      return TabbarScreen(logoutAction: logOutAction);
        // GoRouter.of(context).goNamed('${AppRoute.tabbarscreen.name}}');
      // return const SizedBox.shrink();
    }

    if (checkUserAsyncValue is AsyncLoading) {
      return 
      Container(
       decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
               Color(ColorConstants.topbarbg),
               Color(ColorConstants.tabbg),
              ],
            )
          ),
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
       return ErrorScreen(onRetryPressed: onRetryPressed);
    }

    // This should ideally never be reached, but it's here as a fallback.
    //  context.replaceNamed(AppRoute.login.name);
      return ErrorScreen(onRetryPressed: onRetryPressed);
    // return Container(color: Colors.green,);
  }

  void onRetryPressed(){

  }
}

// import 'package:evoke_nexus_app/app/screens/login/login_screen.dart';
// import 'package:evoke_nexus_app/app/screens/tab_bar/tab_bar_handler.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'app/provider/user_service_provider.dart';



// class RootNavigation extends ConsumerStatefulWidget {
//   const RootNavigation({super.key});
//   @override
//   ConsumerState<RootNavigation> createState() => _RootNavigationState();
// }

// class _RootNavigationState extends ConsumerState<RootNavigation> {
//   @override
//   Widget build(BuildContext context) {
//      return 
//    TabBarHandler();
    
// }
// }


// ThemeData _buildShrineTheme() {
//   final ThemeData base = ThemeData.light();
//   return base.copyWith(
//     colorScheme: _shrineColorScheme,
//     textTheme: _buildShrineTextTheme(base.textTheme),
//   );
// }

// TextTheme _buildShrineTextTheme(TextTheme base) {
//   return base
//       .copyWith(
       
//       )
//       .apply(
//         fontFamily: 'Rubik',
//         displayColor: shrineBrown900,
//         bodyColor: shrineBrown900,
//       );
// }

// const ColorScheme _shrineColorScheme = ColorScheme(
//   primary: shrinePink100,
//   primaryVariant: shrineBrown900,
//   secondary: shrinePink50,
//   secondaryVariant: shrineBrown900,
//   surface: shrineSurfaceWhite,
//   background: shrineBackgroundWhite,
//   error: shrineErrorRed,
//   onPrimary: shrineBrown900,
//   onSecondary: shrineBrown900,
//   onSurface: shrineBrown900,
//   onBackground: shrineBrown900,
//   onError: shrineSurfaceWhite,
//   brightness: Brightness.light,
// );


// const Color shrinePink50 = Color(0xFFFEEAE6);
// const Color shrinePink100 = Color(0xFFFEDBD0);
// const Color shrinePink300 = Color(0xFFFBB8AC);
// const Color shrinePink400 = Color(0xFFEAA4A4);

// const Color shrineBrown900 = Color(0xFF442B2D);
// const Color shrineBrown600 = Color(0xFF7D4F52);

// const Color shrineErrorRed = Color(0xFFC5032B);

// const Color shrineSurfaceWhite = Color(0xFFFFFBFA);
// const Color shrineBackgroundWhite = Colors.white;

// const defaultLetterSpacing = 0.03;