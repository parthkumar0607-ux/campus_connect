import 'package:campus_connect_v2/core/network/api_client.dart';

import '../models/event_attendee_model.dart';
import '../models/event_model.dart';
import '../models/event_status_model.dart';

class EventRemoteDataSource {
  Future<List<EventModel>> getEvents() async {
    final response = await ApiClient.dio.get(
      "/events",
    );

    return (response.data as List)
        .map(
          (event) =>
              EventModel.fromJson(event),
        )
        .toList();
  }

  Future<EventModel> createEvent({
    required String title,
    required String description,
    required String venue,
    required DateTime dateTime,
    required int maxAttendees,
  }) async {
    final response = await ApiClient.dio.post(
      "/events",
      data: {
        "title": title,
        "description": description,
        "venue": venue,
        "date_time":
            dateTime.toIso8601String(),
        "max_attendees":
            maxAttendees,
      },
    );

    return EventModel.fromJson(
      response.data,
    );
  }

  Future<EventModel> updateEvent({
    required int eventId,
    required String title,
    required String description,
    required String venue,
    required DateTime dateTime,
    required int maxAttendees,
  }) async {
    final response = await ApiClient.dio.put(
      "/events/$eventId",
      data: {
        "title": title,
        "description": description,
        "venue": venue,
        "date_time":
            dateTime.toIso8601String(),
        "max_attendees":
            maxAttendees,
      },
    );

    return EventModel.fromJson(
      response.data,
    );
  }

  Future<void> registerEvent(
    int eventId,
  ) async {
    await ApiClient.dio.post(
      "/events/$eventId/register",
    );
  }

  Future<void> leaveEvent(
    int eventId,
  ) async {
    await ApiClient.dio.delete(
      "/events/$eventId/leave",
    );
  }

  Future<void> deleteEvent(
    int eventId,
  ) async {
    await ApiClient.dio.delete(
      "/events/$eventId",
    );
  }

  Future<List<EventAttendeeModel>>
      getEventAttendees(
    int eventId,
  ) async {
    final response =
        await ApiClient.dio.get(
      "/events/$eventId/attendees",
    );

    return (response.data as List)
        .map(
          (member) =>
              EventAttendeeModel.fromJson(
            member,
          ),
        )
        .toList();
  }

  Future<EventStatusModel>
      getEventStatus(
    int eventId,
  ) async {
    final response =
        await ApiClient.dio.get(
      "/events/$eventId/status",
    );

    return EventStatusModel.fromJson(
      response.data,
    );
  }
}