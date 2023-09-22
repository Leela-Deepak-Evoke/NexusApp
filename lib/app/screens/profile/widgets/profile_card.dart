import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/provider/profile_service_provider.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileCard extends ConsumerWidget {
  const ProfileCard({super.key});

  // Initialize the service

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider.notifier).state;
    print("user: $user");

    return SizedBox(
      height: 350,
      width: 500,
      child:
       Card(
        margin: const EdgeInsets.all(8),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0), // Add padding to the card
          child: Column(
            children: <Widget>[
              _profilePicWidget(user!, ref),
              TextButton(
                onPressed: () =>
                    ref.read(uploadProfileImageProvider(user.userId)),
                child: const Text('Change Profile Picture',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              const SizedBox(height: 5),
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                user.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const Divider(
                color: Colors.indigo,
                height: 5,
                thickness: 1,
                indent: 5,
                endIndent: 5,
              ),
              Column(
                children: [
                  ListTile(
                    onTap: () {
                      GoRouter.of(context).go('/profile');
                    },
                    leading: const Icon(Icons.person,
                        size: 20, color: Colors.lightBlue),
                    title: const Text('Profile'),
                  ),
                  ListTile(
                    onTap: () {
                      GoRouter.of(context).go('/settings');
                    },
                    leading: const Icon(Icons.settings,
                        size: 20, color: Colors.lightBlue),
                    title: const Text('Preferences'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _profilePicWidget(User user, WidgetRef ref) {
    final avatarText = getAvatarText(user.name);

    final profileThumbnailAsyncValue =
        ref.watch(profileThumbnailProvider(user.profilePicture!));

    return profileThumbnailAsyncValue.when(
      data: (data) {
        if (data != null) {
          return CircleAvatar(
            backgroundImage: NetworkImage(data),
            radius: 100.0,
          );
        } else {
          // Render a placeholder or an error image
          return CircleAvatar(radius: 100.0, child: Text(avatarText));
        }
      },
      loading: () => const Center(
        child: SizedBox(
          height: 100.0,
          width: 100.0,
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) {
        // Handle the error case if needed
        return CircleAvatar(radius: 100.0, child: Text(avatarText));
      },
    );
  }

  String getAvatarText(String name) {
    final nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return nameParts[0][0].toUpperCase() + nameParts[1][0].toUpperCase();
    } else if (nameParts.isNotEmpty) {
      return nameParts[0][0].toUpperCase();
    }
    return '';
  }
}
