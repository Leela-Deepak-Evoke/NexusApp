import 'package:evoke_nexus_app/app/models/get_comments_parms.dart';
import 'package:evoke_nexus_app/app/models/post_comment_params.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/provider/comment_service_provider.dart';
import 'package:evoke_nexus_app/app/screens/comments/widgets/commets_list_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class CommentsMobileView extends ConsumerStatefulWidget {
  final User user;
  final Widget? headerCard;
  final String posttype;
  final String postId;

  const CommentsMobileView(
      {super.key,
      required this.user,
       this.headerCard,
      required this.posttype,
      required this.postId});

  @override
  ConsumerState<CommentsMobileView> createState() => _CommentsMobileViewState();
}

class _CommentsMobileViewState extends ConsumerState<CommentsMobileView> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode();
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();

    _textFieldFocus.addListener(() {
      setState(() {
        _isKeyboardVisible = _textFieldFocus.hasFocus;
      });
    });
  }
  void _handleSubmit(PostCommentsParams params, WidgetRef ref) async {
    await ref.read(postCommentProvider(params).future);
    
  }
  @override
  void dispose() {
    _textFieldFocus.dispose();
    super.dispose();
  }

  void _sendComment() {
    if(_commentController.text == null || _commentController.text == "")
    {
      return;
    }
    final commentId = const Uuid().v4();

    var params = PostCommentsParams(
                userId: widget.user.userId, 
                content: _commentController.text, 
                commentId: commentId, 
                postIdPropValue: widget.postId,
                 postlabel: widget.posttype);
    _textFieldFocus.unfocus();
    _commentController.text = "";
    _handleSubmit(params, ref);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    var params = GetCommentsParams(
        userId: widget.user.userId,
        postId: widget.postId,
        postType: widget.posttype);

    return Column(children: [
      Expanded(
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: [
            SliverList.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return widget.headerCard;
              },
            ),
            CommentsListMobileView(
              user: widget.user,
              postId: widget.postId,
              posttype: widget.posttype,
              params: params,
            )
          ],
        ),
      ),
      Container(
        child: Row(children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _commentController,
                focusNode: _textFieldFocus,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  labelText: "Add a comment...",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _sendComment,
            child: Text("Send"),
          ),
        ]),
      ),
      SizedBox(
          height: _isKeyboardVisible ? 0 : 100,
          child: Container(
            color: Colors.white,
          ))
    ]);

    // return SingleChildScrollView(
    //   scrollDirection: Axis.vertical,
    //   child:
    //   Column (
    //     children :
    //     [
    //      widget.headerCard,
    //     //  ListView.builder(
    //     //   itemCount: 3,
    //     //   itemBuilder:(context, index) {
    //     //     return Container(color:  Colors.red,);

    //     //  },),
    //  //   Expanded(child: CommentsListMobileView(user: widget.user)),
    //     Container(child:
    //     Row(
    //       children: [
    //          Expanded(
    //            child: Container(
    //                    padding: const EdgeInsets.all(16.0),
    //                    child: TextField(
    //                      controller: _commentController,
    //                      focusNode: _textFieldFocus,
    //                      maxLines: null ,
    //                     keyboardType: TextInputType.multiline,
    //                      decoration: const InputDecoration(
    //             labelText: "Add a comment...",
    //             border: OutlineInputBorder(),
    //                      ),
    //                    ),
    //                  ),
    //          ),
    //       ElevatedButton(
    //       onPressed: _sendComment,
    //       child: Text("Send"),
    //     ),

    //       ]),
    //     ),
    //     SizedBox(
    //         height: _isKeyboardVisible ? 0 : 100,
    //         child: Container(
    //           color: Colors.white,
    //         )),
    //   ],
    // )
    // );
  }
}
