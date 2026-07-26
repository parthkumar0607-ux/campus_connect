class EventStatusModel {
  final bool registered;
  final bool isCreator;

  EventStatusModel({
    required this.registered,
    required this.isCreator,
  });

  factory EventStatusModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return EventStatusModel(
      registered: json["registered"],
      isCreator: json["is_creator"],
    );
  }
}