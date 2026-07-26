import '../datasource/event_remote_datasource.dart';
import '../models/event_attendee_model.dart';
import '../models/event_model.dart';
import '../models/event_status_model.dart';

class EventRepository {
  final EventRemoteDataSource remoteDataSource =
      EventRemoteDataSource();

  Future<List<EventModel>> getEvents() async {
    return await remoteDataSource.getEvents();
  }

  Future<EventModel> createEvent({
    required String title,
    required String description,
    required String venue,
    required DateTime dateTime,
    required int maxAttendees,
  }) async {
    return await remoteDataSource.createEvent(
      title: title,
      description: description,
      venue: venue,
      dateTime: dateTime,
      maxAttendees: maxAttendees,
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
    return await remoteDataSource.updateEvent(
      eventId: eventId,
      title: title,
      description: description,
      venue: venue,
      dateTime: dateTime,
      maxAttendees: maxAttendees,
    );
  }

  Future<void> registerEvent(
    int eventId,
  ) async {
    await remoteDataSource.registerEvent(
      eventId,
    );
  }

  Future<void> leaveEvent(
    int eventId,
  ) async {
    await remoteDataSource.leaveEvent(
      eventId,
    );
  }

  Future<void> deleteEvent(
    int eventId,
  ) async {
    await remoteDataSource.deleteEvent(
      eventId,
    );
  }

  Future<List<EventAttendeeModel>>
      getEventAttendees(
    int eventId,
  ) async {
    return await remoteDataSource
        .getEventAttendees(
      eventId,
    );
  }

  Future<EventStatusModel>
      getEventStatus(
    int eventId,
  ) async {
    return await remoteDataSource
        .getEventStatus(
      eventId,
    );
  }
}