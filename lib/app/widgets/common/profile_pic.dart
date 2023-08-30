import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/provider/profile_service_provider.dart';

class ProfilePic extends ConsumerWidget {
  final User user;
  final String size;
  const ProfilePic({super.key, required this.user, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarText = getAvatarText(user.name);

    final profileThumbnailAsyncValue =
        ref.watch(profileThumbnailProvider(user.profilePicture!));

    if (user.profilePicture == null || user.profilePicture!.isEmpty) {
      return CircleAvatar(
          radius: size == "LARGE" ? 50.0 : 30.0, child: Text(avatarText));
    } else {
      return profileThumbnailAsyncValue.when(
        data: (data) {
          if (data != null) {
            return CircleAvatar(
              backgroundImage: NetworkImage(data),
              radius: size == "LARGE" ? 50.0 : 30.0,
            );
          } else {
            // Render a placeholder or an error image
            return CircleAvatar(
                radius: size == "LARGE" ? 50.0 : 30.0, child: Text(avatarText));
          }
        },
        loading: () => Center(
          child: SizedBox(
            height: size == "LARGE" ? 50.0 : 30.0,
            width: size == "LARGE" ? 50.0 : 30.0,
            child: const CircularProgressIndicator(),
          ),
        ),
        error: (error, stack) {
          return Text('An error occurred: $error');
        },
      );
    }
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
