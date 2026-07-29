import 'package:flutter/material.dart';

import 'package:campus_connect_v2/shared/widgets/glass_card.dart';

import '../../data/models/event_model.dart';
import '../../data/repositories/event_repository.dart';
import 'create_event_screen.dart';
import 'event_details_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final EventRepository repository = EventRepository();

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
    setState(loadEvents);
    await eventsFuture;
  }

  Future<void> openEvent(EventModel event) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventDetailsScreen(event: event),
      ),
    );

    if (updated == true) {
      setState(loadEvents);
    }
  }

  Future<void> createEvent() async {
    final created = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateEventScreen(),
      ),
    );

    if (created == true) {
      setState(loadEvents);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xff6366F1),
        foregroundColor: Colors.white,
        onPressed: createEvent,
        icon: const Icon(Icons.add),
        label: const Text("Create Event"),
      ),

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refreshEvents,
          child: FutureBuilder<List<EventModel>>(
            future: eventsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    snapshot.error.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              }

              final events = snapshot.data ?? [];

              if (events.isEmpty) {
                return const Center(
                  child: Text(
                    "No Events Yet",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  GlassCard(
                    child: const Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Campus Events",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Discover workshops, hackathons and campus activities.",
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  ...events.map(
                    (event) => Padding(
                      padding:
                          const EdgeInsets.only(
                        bottom: 16,
                      ),
                      child: _EventCard(
                        event: event,
                        onTap: () => openEvent(event),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
class _EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;

  const _EventCard({
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xffF59E0B),
                        Color(0xffF97316),
                      ],
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                  ),
                  child: const Icon(
                    Icons.event,
                    color: Colors.white,
                    size: 30,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Text(
                    event.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white54,
                  size: 18,
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.orange,
                  size: 18,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    event.venue,
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(
                  Icons.calendar_month,
                  color: Colors.lightBlueAccent,
                  size: 18,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    event.dateTime
                        .toLocal()
                        .toString()
                        .substring(0, 16),
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.08),
                borderRadius:
                    BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withOpacity(.12),
                ),
              ),
              child: Text(
                "${event.currentAttendees}/${event.maxAttendees} Registered",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onTap,
                child: const Text("View Event"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}