import 'package:evoke_nexus_app/app/models/org_updates.dart';
import 'package:evoke_nexus_app/app/provider/org_update_service_provider.dart';
import 'package:evoke_nexus_app/app/screens/org_updates/widgets/org_updates_media_view.dart';
import 'package:evoke_nexus_app/app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OrgUpdateHeaderCardView extends ConsumerStatefulWidget {
  final OrgUpdate item;

  const OrgUpdateHeaderCardView({super.key, required this.item});
  @override
  ConsumerState<OrgUpdateHeaderCardView> createState() =>
      _OrgUpdateHeaderCardViewState();
}

class _OrgUpdateHeaderCardViewState
    extends ConsumerState<OrgUpdateHeaderCardView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Card(
      margin: const EdgeInsets.all(5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              leading: _profilePicWidget(widget.item, ref),
              title: Text(widget.item.author!,
                  style: const TextStyle(fontSize: 16)),
              subtitle: Text(
                "${widget.item.authorTitle!} | ${Global.calculateTimeDifferenceBetween(Global.getDateTimeFromStringForPosts(widget.item.postedAt.toString()))}",
                style: TextStyle(
                  color: const Color(0xff676A79),
                  fontSize: 12.0,
                  fontFamily: GoogleFonts.notoSans().fontFamily,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4.0),
                Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: contentViewWidget(widget.item)),
                Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                    child: hasTagViewWidget(widget.item)),

                //const SizedBox(height: 4.0),
                widget.item.media
                    ?  OrgUpdateMediaView(item: widget.item)
                      
                    : const SizedBox(height: 2.0),
                const SizedBox(height: 4.0),
                // const Divider(
                //   thickness: 1.0,
                //   height: 1.0,
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget contentViewWidget(OrgUpdate item) {
    if (item.content != null) {
      return Text(item.content!, style: const TextStyle(fontSize: 14));
    } else if (item.mediaCaption != null) {
      return Text(item.mediaCaption!, style: const TextStyle(fontSize: 14));
    } else {
      return const SizedBox(height: 5.0);
    }
  }

  Widget hasTagViewWidget(OrgUpdate item) {
    if (item.hashTag != null) {
      return Text(item.hashTag!, style: const TextStyle(fontSize: 14));
    } else {
      return const SizedBox(height: 5.0);
    }
  }

  Widget _profilePicWidget(OrgUpdate item, WidgetRef ref) {
    final avatarText = getAvatarText(item.author!);
    if (item.authorThumbnail == null) {
      return CircleAvatar(radius: 20.0, child: Text(avatarText));
    } else {
      // Note: We're using `watch` directly on the provider.
      final profilePicAsyncValue =
          ref.watch(authorThumbnailProvider(item.authorThumbnail!));
      //print(profilePicAsyncValue);
      return Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                image: new AssetImage("assets/images/user_pic_s3_new.png"),
                fit: BoxFit.fill,
              )),
          child: profilePicAsyncValue.when(
            data: (imageUrl) {
              if (imageUrl != null && imageUrl.isNotEmpty) {
                if (_isProperImageUrl(imageUrl)) {
                  return CircleAvatar(
                    backgroundColor: Colors.transparent,
                   // backgroundImage: NetworkImage(imageUrl),
                   backgroundImage: CachedNetworkImageProvider(imageUrl),
                    radius: 20.0,
                  );
                } else {
                  return CircleAvatar(
                    radius: 20,
                    child: Text(
                      avatarText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  );
                }
              } else {
                // Render a placeholder or an error image
                return CircleAvatar(
                  radius: 20,
                  child: Text(
                    avatarText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                );
              }
            },
            loading: () => const Center(
              child: SizedBox(
                height: 20.0,
                width: 20.0,
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stackTrace) => CircleAvatar(
                radius: 20.0,
                child: Text(avatarText)), // Handle error state appropriately
          ));
    }
  }

  bool _isProperImageUrl(String imageUrl) {
    if (imageUrl.contains('%20')) {
      return false;
    }
    return true;
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
