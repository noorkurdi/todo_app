class TasksModels {
  String title;
  String? description;
  bool isDone = false;
  String date;
  String time;
  TasksModels(
      {required this.title,
      this.description,
      required this.isDone,
      required this.date,
      required this.time});
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "isDone": isDone,
      "date": date,
      "time": time
    };
  }

  factory TasksModels.fromJson(Map<String, dynamic> json) => TasksModels(
      title: json["title"] as String,
      date: json["date"] as String,
      time: json["time"] as String,
      isDone: json["isDone"] as bool,
      description:
          json["description"] != null ? json["description"] as String : null);
}
