import 'package:evoke_nexus_app/app/models/question.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/screens/answers/answers_screen.dart';
import 'package:evoke_nexus_app/app/screens/create_post_feed/create_post_feed_screen.dart';
import 'package:evoke_nexus_app/app/screens/feeds/feeds_screen.dart';
import 'package:evoke_nexus_app/app/screens/forum/forum_screen.dart';
import 'package:evoke_nexus_app/app/screens/forum/widgets/post_forum_fab.dart';
import 'package:evoke_nexus_app/app/screens/home/home_screen.dart';
import 'package:evoke_nexus_app/app/screens/login/login_screen.dart';
import 'package:evoke_nexus_app/app/screens/not_found/not_found_screen.dart';
import 'package:evoke_nexus_app/app/screens/org_updates/org_updates_screen.dart';
import 'package:evoke_nexus_app/app/screens/profile/profile_screen.dart';
import 'package:evoke_nexus_app/app/screens/root_screen/root_screen.dart';
import 'package:evoke_nexus_app/app/screens/root_screen/root_screen_mobile.dart';
import 'package:evoke_nexus_app/app/screens/tab_bar/profile_tab_menu.dart';
import 'package:evoke_nexus_app/app/screens/tab_bar/tab_bar_screen.dart';
import 'package:evoke_nexus_app/app/screens/test/test_screen.dart';
import 'package:evoke_nexus_app/app/screens/timeline/timeline_screen.dart';
import 'package:evoke_nexus_app/app/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

final router = GoRouter(
  initialLocation: '/${AppRoute.login.name}',
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      name: AppRoute.login.name,
      path: '/',
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: const LoginScreen(),
      ),
      routes: [
        GoRoute(
          name: AppRoute.feeds.name,
          path: "feeds",
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child:  FeedsScreen(),
          ),
        ),
        GoRoute(
          name: AppRoute.orgUpdates.name,
          path: "orgUpdates",
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const OrgUpdatesScreen(),
          ),
        ),
        // GoRoute(
        //   name: AppRoute.profile.name,
        //   path: "profile",
        //   pageBuilder: (context, state) => MaterialPage<void>(
        //     key: state.pageKey,
        //     child: ProfileScreen(),
        //   ),
        // ),
        GoRoute(
          name: AppRoute.forum.name,
          path: "forum",
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: ForumScreen(),
          ),
        ),
        GoRoute(
          name: AppRoute.rootScreen.name,
          path: 'home',
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const RootScreen(),
          ),
        ),
        GoRoute(
            name: AppRoute.postforum.name,
            path: AppRoute.postforum.name,
            pageBuilder: (context, state) {
              var user = state.extra as User;
              return MaterialPage<void>(
                key: state.pageKey,
                child: PostForumFAB(user: user),
              );
            }),
        GoRoute(
          name: AppRoute.test.name,
          path: 'test',
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const TestScreen(),
          ),
        ),
        GoRoute(
          name: AppRoute.timeline.name,
          path: 'timeline',
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const TimelineScreen(),
          ),
        ),
      ],
    )
  ],
  errorBuilder: (context, state) => const NotFoundScreen(),
);

final mobileappRouter = GoRouter(
    initialLocation: '/${AppRoute.login.name}',
    redirectLimit: 2,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        name: AppRoute.login.name,
        path: '/${AppRoute.login.name}',
        redirect: (context, state) async {
          final prefs = await SharedPreferences.getInstance();
          final authToken = prefs.getString('authToken');
          if (authToken == null) {
            return null;
          } else {
            return '/${AppRoute.rootNavigation.name}';
          }
        },
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
        routes: [
           GoRoute(
            name: AppRoute.home.name,
            path: "home",
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child:  const HomeScreen(),
            ),
          ),
          GoRoute(
            name: AppRoute.feeds.name,
            path: "feeds",
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child:  FeedsScreen(),
            ),
          ),
          GoRoute(
            name: AppRoute.createPost.name,
            path: "createPost",
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: CreatePostFeedScreen(), //const
            ),
          ),
          GoRoute(
            name: AppRoute.orgUpdates.name,
            path: "orgUpdates",
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: const OrgUpdatesScreen(),
            ),
          ),
          GoRoute(
            name: AppRoute.profile.name,
            path: "profile",
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: ProfileScreen(),
            ),
          ),
          GoRoute(
            name: AppRoute.forum.name,
            path: "forum",
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: ForumScreen(),
            ),
          ),
          GoRoute(
            name: AppRoute.test.name,
            path: 'test',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: const TestScreen(),
            ),
          ),
          GoRoute(
            name: AppRoute.timeline.name,
            path: 'timeline',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: const TimelineScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
          name: AppRoute.rootNavigation.name,
          path: '/${AppRoute.rootNavigation.name}',
          pageBuilder: (context, state) => MaterialPage<void>(
                key: state.pageKey,
                // child: const RootScreenMobile(),
                child: RootScreenMobile(),
              ),
          routes: [
            GoRoute(
              name: AppRoute.tabbarscreen.name,
              path: '${AppRoute.tabbarscreen.name}',
              pageBuilder: (context, state) => MaterialPage<void>(
                key: state.pageKey,
                child: TabbarScreen(
                  logoutAction: () {},
                ),
              ),
            ),
          ]),
    ],
    errorBuilder: (context, state) {
      return const NotFoundScreen();
    });


final homeRouter = GoRouter(
    initialLocation: '/${AppRoute.home.name}',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
          name: AppRoute.home.name,
          path: '/${AppRoute.home.name}',
          pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: const HomeScreen(),
              ),
          routes: [
            GoRoute(
              name: AppRoute.feeds.name,
              path: AppRoute.feeds.name,
              pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: FeedsScreen(),
              ),
            )
          ])
    ]);

final feedsRouter = GoRouter(
    initialLocation: '/${AppRoute.feeds.name}',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
          name: AppRoute.feeds.name,
          path: '/${AppRoute.feeds.name}',
          pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child:  FeedsScreen(),
              ),
          routes: [
            GoRoute(
              name: AppRoute.forum.name,
              path: AppRoute.forum.name,
              pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: ProfileScreen(),
              ),
            )
          ])
    ]);

final forumsRouter = GoRouter(
    initialLocation: '/${AppRoute.forum.name}',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
          name: AppRoute.forum.name,
          path: '/${AppRoute.forum.name}',
          pageBuilder: (context, state) => MaterialPage<void>(
                key: state.pageKey,
                child: ForumScreen(),
              ),
          routes: [
            GoRoute(
              name: AppRoute.profile.name,
              path: AppRoute.profile.name,
              pageBuilder: (context, state) => MaterialPage<void>(
                key: state.pageKey,
                child: ProfileScreen(),
              ),
            ),
            GoRoute(
                name: AppRoute.postforum.name,
                path: AppRoute.postforum.name,
                pageBuilder: (context, state) {
                  var user = state.extra as User;
                  return MaterialPage<void>(
                    key: state.pageKey,
                    child: PostForumFAB(user: user),
                  );
                }),
            GoRoute(
                name: AppRoute.answersforum.name,
                path: AppRoute.answersforum.name,
                pageBuilder: (context, state) {
                  Question? question = state.extra as Question;
                  return MaterialPage<void>(
                    key: state.pageKey,
                    child: AnswersScreen(question: question),
                  );
                }),
          ])
    ]);

final orgupdatesRouter = GoRouter(
    initialLocation: '/${AppRoute.orgUpdates.name}',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        name: AppRoute.orgUpdates.name,
        path: '/${AppRoute.orgUpdates.name}',
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const OrgUpdatesScreen(),
        ),
      )
    ]);

final profileRouter = GoRouter(
    initialLocation: '/${AppRoute.profile.name}',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
          name: AppRoute.profile.name,
          path: '/${AppRoute.profile.name}',
          pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                // child: ProfileScreen(rootScreenMobileContext: context),
                 child: ProfileScreen(),
              ),
          routes: [
            GoRoute(
              name: AppRoute.timeline.name,
              path: AppRoute.timeline.name,
              pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: TimelineScreen(),
              ),
            )
          ])
    ]);

// final profileRouter = GoRouter(
//     initialLocation: '/${AppRoute.profile.name}',
//     debugLogDiagnostics: false,
//     routes: [
//       GoRoute(
//           name: AppRoute.profile.name,
//           path: '/${AppRoute.profile.name}',
//           pageBuilder: (context, state) {
            
//             final BuildContext? rootScreenMobileContext =
//                 state.extra as BuildContext;

//             if (rootScreenMobileContext != null) {
//               return NoTransitionPage<void>(
//                 key: state.pageKey,
//                 child: ProfileTabMenu(
//                   logoutAction: () {},
//                   rootScreenMobileContext: rootScreenMobileContext,
//                   router: router,
//                 ),
//               );
//             } else {
//               return NoTransitionPage<void>(
//                 key: state.pageKey,
//                 child: ProfileScreen(),
//               );
//             }

//           },
//           routes: [
//             GoRoute(
//               name: AppRoute.timeline.name,
//               path: AppRoute.timeline.name,
//               pageBuilder: (context, state) => NoTransitionPage<void>(
//                 key: state.pageKey,
//                 child: TimelineScreen(),
//               ),
//             )
//           ])
//     ]);
