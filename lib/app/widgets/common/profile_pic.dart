import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/provider/profile_service_provider.dart';
import 'package:evoke_nexus_app/app/models/user_like.dart';

class ProfilePic extends ConsumerWidget {
  final User user;
  final String size;
  final bool? isFromOtherUser;
  final UserLike? otherUser;

  const ProfilePic(
      {super.key,
      required this.user,
      this.isFromOtherUser,
      this.otherUser,
      required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarText = getAvatarText(user.name);

    final profileThumbnailAsyncValue = ref.watch(profileThumbnailProvider(
        isFromOtherUser == false
            ? user.profilePicture ?? ""
            : otherUser!.profilePicture ?? ""));

    if (user.profilePicture == null || user.profilePicture!.isEmpty) {
      return CircleAvatar(
          radius: size == "LARGE" ? 65.0 : 30.0, child: Text(avatarText));
    } else {
      return Center(
          child: Container(
              height: size == "LARGE" ? 120.0 : 60.0,
              width: size == "LARGE" ? 120.0 : 60.0,
              decoration:  BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    image: new AssetImage("assets/images/user_pic_s3_new.png"),
                    fit: BoxFit.fill,
                  )
                  ),
              child: profileThumbnailAsyncValue.when(
                data: (data) {
                  if (data != null) {
                    return Center(
                        child: CircleAvatar(
                      backgroundColor: Colors
                          .transparent, // Set background color to transparent

                      backgroundImage: NetworkImage(data),
                      radius: size == "LARGE" ? 65.0 : 30.0,
                    ));
                  } else {
                    // Render a placeholder or an error image
                    return CircleAvatar(
                        backgroundColor: Colors
                            .transparent, // Set background color to transparent
                        radius: size == "LARGE" ? 65.0 : 30.0,
                        child: Text(avatarText));
                  }
                },
                loading: () => Center(
                  child: SizedBox(
                    height: size == "LARGE" ? 65.0 : 30.0,
                    width: size == "LARGE" ? 65.0 : 30.0,
                    child: const CircularProgressIndicator(),
                  ),
                ),
                error: (error, stack) {
                  return CircleAvatar(
                      backgroundColor: Colors
                          .transparent, // Set background color to transparent
                      radius: 30.0,
                      child: Text(avatarText));
                },
              )));
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
