import 'package:comment_tree/data/comment.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:evoke_nexus_app/app/models/get_comments_parms.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/models/user_comment.dart';
import 'package:evoke_nexus_app/app/provider/comment_service_provider.dart';
import 'package:evoke_nexus_app/app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class CommentsListMobileView extends ConsumerStatefulWidget {
  final User user;
  final String posttype;
  final String postId;
  final GetCommentsParams params;
  const CommentsListMobileView({super.key, required this.user,required this.posttype,required this.postId ,required this.params});

  @override
  ConsumerState<CommentsListMobileView> createState() =>
      _CommentsListMobileViewState();
}

class _CommentsListMobileViewState
    extends ConsumerState<CommentsListMobileView> {

String getAvatarText(String name) {
    final nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return nameParts[0][0].toUpperCase() + nameParts[1][0].toUpperCase();
    } else if (nameParts.isNotEmpty) {
      return nameParts[0][0].toUpperCase();
    }
    return '';
  }
      Widget _profilePicWidget(UserComment item, WidgetRef ref) {
    final avatarText = getAvatarText(item.userName!);
    if (item.authorThumbnail == null) {
      return CircleAvatar(radius: 12.0, child: Text(avatarText));
    } else {
      // Note: We're using `watch` directly on the provider.
      final profilePicAsyncValue =
          ref.watch(authorThumbnailProvider(item.authorThumbnail!));
      //print(profilePicAsyncValue);
      return profilePicAsyncValue.when(
        data: (imageUrl) {
          if (imageUrl != null && imageUrl.isNotEmpty) {
            return CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
              radius: 12.0,
              child: Text(
                avatarText,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
              ),
            );
          } else {
            // Render a placeholder or an error image
            return CircleAvatar(radius: 12.0, child: Text(avatarText));
          }
        },
        loading: () => const Center(
          child: SizedBox(
            height: 30.0,
            width: 30.0,
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stackTrace) => CircleAvatar(
            radius: 30.0,
            child: Text(avatarText)), // Handle error state appropriately
      );
    }
  }

  @override
  Widget build(BuildContext context) {

   final commentsAsyncValue = ref.watch(commentsProvider(widget.params
                         ));

    if (commentsAsyncValue is AsyncData) {
      final items = commentsAsyncValue.value!;
    final Size size = MediaQuery.of(context).size;
    return
    SliverList.builder(
        
          itemCount: items.length,
          itemBuilder: (context, index) {
            var item = items[index];
            return 
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0,0,8.0,0),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: CommentTreeWidget<Comment, Comment>(
                  Comment(
                      avatar: item.authorThumbnail,
                      userName: item.userName,
                      content: item.comment),
                  [],
                  treeThemeData: const TreeThemeData(
                      lineColor: Colors.transparent, lineWidth: 0),
                  avatarRoot: (context, data) => PreferredSize(
                    child: _profilePicWidget(item, ref),
                    preferredSize: Size.fromRadius(18),
                  ),
                 
                  //Child tree list
                  avatarChild: (context, data) =>  PreferredSize(
                    preferredSize: Size.fromRadius(12),
                    child: _profilePicWidget(item, ref),
                   
                  ),
                 
                  contentChild: (context, data) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                 '${data.userName}',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                '${data.content}',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    ?.copyWith(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  contentRoot: (context, data) {
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${data.userName}',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                              ),
                              Text(
                                '${Global.calculateTimeDifferenceBetween(Global.getDateTimeFromStringForPosts(item.commentedAt.toString()))}',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 9,
                                        color: Colors.grey),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                '${data.content}',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          });
    }
    if (commentsAsyncValue is AsyncLoading) {
      return 
      SliverList.builder(
        itemCount: 1,
        itemBuilder:(context, index) {

          return    const Center(
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: CircularProgressIndicator(),
        ),
      );
        
      },);
      
   
    }

    if (commentsAsyncValue is AsyncError) {
      return
      SliverList.builder(
        itemCount: 1,
        itemBuilder:(context, index) {

          return   Text('');
      
        
      },);
      
    }

    // This should ideally never be reached, but it's here as a fallback.
    return SliverList.builder(
        itemCount: 1,
        itemBuilder:(context, index) {

          return   Container(color: Colors.amber);
      
        
      },);
  }
}
