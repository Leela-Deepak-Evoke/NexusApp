import 'package:evoke_nexus_app/app/screens/forum/forum_screen.dart';
import 'package:evoke_nexus_app/app/screens/test/test_screen.dart';
import 'package:evoke_nexus_app/app/screens/timeline/timeline_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/utils/app_routes.dart';
import 'package:evoke_nexus_app/app/screens/root_screen/root_screen.dart';
import 'package:evoke_nexus_app/app/screens/login/login_screen.dart';
import 'package:evoke_nexus_app/app/screens/not_found/not_found_screen.dart';
import 'package:evoke_nexus_app/app/screens/feeds/feeds_screen.dart';
import 'package:evoke_nexus_app/app/screens/org_updates/org_updates_screen.dart';
import 'package:evoke_nexus_app/app/screens/profile/profile_screen.dart';

final router = GoRouter(
  initialLocation: '/',
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
            child: const FeedsScreen(),
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
            child: const ProfileScreen(),
          ),
        ),
        GoRoute(
          name: AppRoute.forum.name,
          path: "forum",
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const ForumScreen(),
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
