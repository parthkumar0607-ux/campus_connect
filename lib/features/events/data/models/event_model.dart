class EventModel {
  final int id;
  final String title;
  final String description;
  final String venue;
  final DateTime dateTime;
  final int maxAttendees;
  final int currentAttendees;
  final int createdBy;
  final DateTime createdAt;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.venue,
    required this.dateTime,
    required this.maxAttendees,
    required this.currentAttendees,
    required this.createdBy,
    required this.createdAt,
  });

  factory EventModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return EventModel(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      venue: json["venue"],
      dateTime: DateTime.parse(
        json["date_time"],
      ),
      maxAttendees: json["max_attendees"],
      currentAttendees:
          json["current_attendees"],
      createdBy: json["created_by"],
      createdAt: DateTime.parse(
        json["created_at"],
      ),
    );
  }
}