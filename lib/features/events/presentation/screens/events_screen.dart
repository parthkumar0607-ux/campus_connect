import 'package:flutter/material.dart';

import '../../data/models/event_model.dart';
import '../../data/repositories/event_repository.dart';
import 'create_event_screen.dart';
import 'event_details_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() =>
      _EventsScreenState();
}

class _EventsScreenState
    extends State<EventsScreen> {
  final EventRepository repository =
      EventRepository();

  late Future<List<EventModel>> eventsFuture;

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  void loadEvents() {
    eventsFuture = repository.getEvents();
  }

  Future<void> refreshEvents() async {
    setState(() {
      loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Events"),
      ),
      floatingActionButton:
          FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final created =
              await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const CreateEventScreen(),
            ),
          );

          if (created == true) {
            refreshEvents();
          }
        },
      ),
      body: RefreshIndicator(
        onRefresh: refreshEvents,
        child: FutureBuilder<
            List<EventModel>>(
          future: eventsFuture,
          builder: (
            context,
            snapshot,
          ) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child:
                    CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                ),
              );
            }

            final events =
                snapshot.data ?? [];

            if (events.isEmpty) {
              return const Center(
                child: Text(
                  "No Events Yet",
                ),
              );
            }

            return ListView.builder(
              padding:
                  const EdgeInsets.all(16),
              itemCount: events.length,
              itemBuilder:
                  (context, index) {
                final event =
                    events[index];

                return Card(
                  margin:
                      const EdgeInsets.only(
                    bottom: 16,
                  ),
                  child: ListTile(
                    title:
                        Text(event.title),
                    subtitle: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(event.venue),
                        const SizedBox(
                            height: 4),
                        Text(
                          event.dateTime
                              .toLocal()
                              .toString(),
                        ),
                        const SizedBox(
                            height: 4),
                        Text(
                          "${event.currentAttendees}/${event.maxAttendees} Attendees",
                        ),
                      ],
                    ),
                    trailing: const Icon(
                      Icons
                          .arrow_forward_ios,
                    ),
                    onTap: () async {
                      final updated =
                          await Navigator
                              .push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              EventDetailsScreen(
                            event: event,
                          ),
                        ),
                      );

                      if (updated == true) {
                        refreshEvents();
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}