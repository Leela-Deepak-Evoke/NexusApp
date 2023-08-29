class EventUpdates {
  EventUpdates({
    required this.id,
    required this.title,
    required this.description,
  });
  late final int id;
  late final String title;
  late final String description;
  late final String date;

  EventUpdates.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    description = json['description'];
  }


}