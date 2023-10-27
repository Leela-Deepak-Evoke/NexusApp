class Categories {
  
  late final List<String> orgUpdates;
  late final List<String> feeds;
  late final List<String> questions;

  Categories.fromJson(Map<String, dynamic> json){
    orgUpdates = json['org_updates'];
    feeds = json['feeds'];
    questions = json['questions'];
  }
}




