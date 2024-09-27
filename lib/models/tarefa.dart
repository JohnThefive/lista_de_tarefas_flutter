class Tarefa1 {
  Tarefa1({required this.title, required this.dateTime});

  Tarefa1.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        dateTime = DateTime.parse(json['datetime']);

  String title;
  DateTime dateTime;

  toJson() {
    return {
      'title': title,
      'datetime': dateTime.toIso8601String(),
    };
  }
}

void FGD() {}
