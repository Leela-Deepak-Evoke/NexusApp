class Categories {
  
  late final List<String> org_updates;
  late final List<String> feeds;
  late final List<String> questions;
  
  Categories.fromJson(Map<String, dynamic> json){
    org_updates = json['org_updates'];
    feeds = json['feeds'];
    questions = json['questions'];
  }
}