import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
import 'package:go_router/go_router.dart';

class RootScreen extends ConsumerWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtain the screen size using MediaQuery
    Size screenSize = MediaQuery.of(context).size;
    final checkUserAsyncValue = ref.watch(checkUserProvider);

    if (checkUserAsyncValue is AsyncData) {
      final userName = checkUserAsyncValue.value?.name;
      final userStatus = checkUserAsyncValue.value?.status;
      // Check user status
      if (userStatus == 'ACTIVE') {
        final welcomeText = 'Welcome to Nexus ' '$userName!';
        return Scaffold(
          body: SizedBox(
            width: screenSize.width,
            height: screenSize.height,
            child: Card(
              margin: const EdgeInsets.all(20.0),
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Message
                    Text(
                      welcomeText,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    // Paragraph about the application
                    const Text(
                      'The Nexus application provides a wide range of features that are designed to enhance your experience. Navigate through and explore all the amazing functionalities!',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 10),

                    // Feeds
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.rss_feed, color: Colors.blue),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Feeds - You can post any kind of Text, Photo, Video, CarPool, Classifieds, Ideas, etc.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Organization Updates
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.update, color: Colors.blue),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Organization Updates - You can view the latest updates posted in the Organization.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Q&A Forum
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.question_answer, color: Colors.blue),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Q&A Forum - A dedicated forum for all kinds of questions and answers.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Complete your profile here',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                              onPressed: () =>
                                  {GoRouter.of(context).go('/profile')},
                              child: const Text('Complete Profile'))
                        ]),
                    const SizedBox(height: 10),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Contiue to browse Feeds',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                              onPressed: () =>
                                  {GoRouter.of(context).go('/feeds')},
                              child: const Text('Browse Feeds'))
                        ]),
                  ],
                ),
              ),
            ),
          ),
        );
      } else if (userStatus == 'NEW') {
        GoRouter.of(context).go('/feeds');
        return const SizedBox.shrink();
      }
    }

    if (checkUserAsyncValue is AsyncLoading) {
      return const Center(
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (checkUserAsyncValue is AsyncError) {
      return Text('An error occurred: ${checkUserAsyncValue.error}');
    }

    // This should ideally never be reached, but it's here as a fallback.
    return const SizedBox.shrink();
  }
}
