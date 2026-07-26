class EventAttendeeModel {
  final int id;
  final String name;

  EventAttendeeModel({
    required this.id,
    required this.name,
  });

  factory EventAttendeeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return EventAttendeeModel(
      id: json["id"],
      name: json["name"],
    );
  }
}