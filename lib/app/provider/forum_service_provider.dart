import 'package:evoke_nexus_app/app/models/answer.dart';
import 'package:evoke_nexus_app/app/models/fetch_answer_params.dart';
import 'package:evoke_nexus_app/app/models/post_answer_params.dart';
import 'package:evoke_nexus_app/app/models/post_question_params.dart';
import 'package:evoke_nexus_app/app/models/question.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/services/forum_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final forumServiceProvider = Provider<ForumService>((ref) => ForumService());

final questionsProvider =
    FutureProvider.autoDispose.family<List<Question>, User>((ref, user) async {
  final forumService = ref.read(forumServiceProvider);
  final forums = await forumService.fetchQuestions(user);

  return forums;
});

final refresForumProvider =
    FutureProvider.autoDispose.family<bool, String>((ref, user) async {
  ref.invalidate(questionsProvider);
return true;
});



final answerListProvider = FutureProvider.autoDispose.
 family<List<Answer>,FetchAnswerParams>((ref, params)  async
{
   final forumService = ref.read(forumServiceProvider);
  final forums = await forumService.fetchAnswers(params);
  return forums;
  
},);


final answersProvider = FutureProvider.autoDispose
    .family<List<Answer>, FetchAnswerParams>((ref, params) async {
  final forumService = ref.read(forumServiceProvider);
  final forums = await forumService.fetchAnswers(params);
  return forums;
});

final mediaUrlProvider =
    FutureProvider.autoDispose.family<String?, String>((ref, key) async {
  final forumService = ref.watch(forumServiceProvider);
  return await forumService.getMediaURL(key);
});

final authorThumbnailProvider =
    FutureProvider.autoDispose.family<String?, String>((ref, key) async {
  final forumService = ref.watch(forumServiceProvider);
  return await forumService.getAuthorThumbnail(key);
});

final postQuestionProvider = FutureProvider.autoDispose
    .family<void, PostQuestionParams>((ref, params) async {
  final forumService = ref.watch(forumServiceProvider);
  await forumService.postQuestion(params);
  ref.invalidate(questionsProvider);
});

final postAnswerProvider = FutureProvider.autoDispose
    .family<void, PostAnswerParams>((ref, params) async {
  final forumService = ref.watch(forumServiceProvider);
  await forumService.postAnswer(params);
  ref.invalidate(answerListProvider);
  ref.invalidate(answersProvider);
});
