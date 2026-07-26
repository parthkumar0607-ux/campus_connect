import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../data/models/event_attendee_model.dart';
import '../../data/models/event_model.dart';
import '../../data/models/event_status_model.dart';
import '../../data/repositories/event_repository.dart';
import 'edit_event_screen.dart';

class EventDetailsScreen extends StatefulWidget {
  final EventModel event;

  const EventDetailsScreen({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailsScreen> createState() =>
      _EventDetailsScreenState();
}

class _EventDetailsScreenState
    extends State<EventDetailsScreen> {
  final EventRepository repository =
      EventRepository();

  late Future<List<EventAttendeeModel>>
      attendeesFuture;

  late Future<EventStatusModel>
      statusFuture;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    attendeesFuture =
        repository.getEventAttendees(
      widget.event.id,
    );

    statusFuture =
        repository.getEventStatus(
      widget.event.id,
    );
  }

  void showError(
    DioException e,
  ) {
    if (!mounted) return;

    String message =
        "Something went wrong";

    if (e.response?.data is Map &&
        e.response!.data["detail"] !=
            null) {
      message =
          e.response!.data["detail"];
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Event Details",
        ),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style:
                  const TextStyle(
                fontSize: 28,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
                height: 20),

            const Text(
              "Description",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
                height: 8),

            Text(
              event.description,
              style:
                  const TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(
                height: 24),

            const Text(
              "Venue",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
                height: 8),

            Row(
              children: [
                const Icon(
                  Icons.location_on,
                ),
                const SizedBox(
                    width: 8),
                Expanded(
                  child: Text(
                    event.venue,
                  ),
                ),
              ],
            ),

            const SizedBox(
                height: 24),

            const Text(
              "Date & Time",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
                height: 8),

            Row(
              children: [
                const Icon(
                  Icons
                      .calendar_month,
                ),
                const SizedBox(
                    width: 8),
                Expanded(
                  child: Text(
                    event.dateTime
                        .toLocal()
                        .toString(),
                  ),
                ),
              ],
            ),

            const SizedBox(
                height: 24),

            Row(
              children: [
                const Icon(
                    Icons.groups),
                const SizedBox(
                    width: 8),
                Text(
                  "${event.currentAttendees}/${event.maxAttendees} Attendees",
                  style:
                      const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(
                height: 30),

            const Text(
              "Attendees",
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
                height: 12),

            FutureBuilder<
                List<
                    EventAttendeeModel>>(
              future:
                  attendeesFuture,
              builder: (
                context,
                snapshot,
              ) {
                if (snapshot
                        .connectionState ==
                    ConnectionState
                        .waiting) {
                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );
                }

                if (snapshot
                    .hasError) {
                  return Text(
                    snapshot.error
                        .toString(),
                  );
                }

                final attendees =
                    snapshot.data ??
                        [];

                return Column(
                  children: attendees
                      .map(
                    (
                      attendee,
                    ) {
                      return ListTile(
                        leading:
                            const CircleAvatar(
                          child: Icon(
                            Icons.person,
                          ),
                        ),
                        title: Text(
                          attendee
                              .name,
                        ),
                      );
                    },
                  ).toList(),
                );
              },
            ),

            const SizedBox(
                height: 30),
                            FutureBuilder<EventStatusModel>(
              future: statusFuture,
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
                  return Text(
                    snapshot.error.toString(),
                  );
                }

                final status =
                    snapshot.data!;

                return Column(
                  children: [
                    if (!status.isCreator &&
                        !status.registered)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  try {
                                    setState(() {
                                      isLoading =
                                          true;
                                    });

                                    await repository
                                        .registerEvent(
                                      event.id,
                                    );

                                    if (!mounted) {
                                      return;
                                    }

                                    Navigator.pop(
                                      context,
                                      true,
                                    );
                                  } on DioException catch (e) {
                                    showError(e);
                                  } finally {
                                    if (mounted) {
                                      setState(() {
                                        isLoading =
                                            false;
                                      });
                                    }
                                  }
                                },
                          child: const Text(
                            "Register",
                          ),
                        ),
                      ),

                    if (!status.isCreator &&
                        status.registered)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.orange,
                          ),
                          onPressed: isLoading
                              ? null
                              : () async {
                                  try {
                                    setState(() {
                                      isLoading =
                                          true;
                                    });

                                    await repository
                                        .leaveEvent(
                                      event.id,
                                    );

                                    if (!mounted) {
                                      return;
                                    }

                                    Navigator.pop(
                                      context,
                                      true,
                                    );
                                  } on DioException catch (e) {
                                    showError(e);
                                  } finally {
                                    if (mounted) {
                                      setState(() {
                                        isLoading =
                                            false;
                                      });
                                    }
                                  }
                                },
                          child: const Text(
                            "Leave Event",
                          ),
                        ),
                      ),

                    if (status.isCreator)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final updated =
                                await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    EditEventScreen(
                                  event: event,
                                ),
                              ),
                            );

                            if (updated == true &&
                                mounted) {
                              Navigator.pop(
                                context,
                                true,
                              );
                            }
                          },
                          child: const Text(
                            "Edit Event",
                          ),
                        ),
                      ),

                    if (status.isCreator)
                      const SizedBox(
                        height: 12,
                      ),

                    if (status.isCreator)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.red,
                          ),
                          onPressed: isLoading
                              ? null
                              : () async {
                                  final confirm =
                                      await showDialog<
                                          bool>(
                                    context:
                                        context,
                                    builder:
                                        (context) {
                                      return AlertDialog(
                                        title:
                                            const Text(
                                          "Delete Event",
                                        ),
                                        content:
                                            const Text(
                                          "Are you sure?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () {
                                              Navigator.pop(
                                                context,
                                                false,
                                              );
                                            },
                                            child:
                                                const Text(
                                              "Cancel",
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed:
                                                () {
                                              Navigator.pop(
                                                context,
                                                true,
                                              );
                                            },
                                            child:
                                                const Text(
                                              "Delete",
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirm !=
                                      true) {
                                    return;
                                  }

                                  try {
                                    setState(() {
                                      isLoading =
                                          true;
                                    });

                                    await repository
                                        .deleteEvent(
                                      event.id,
                                    );

                                    if (!mounted) {
                                      return;
                                    }

                                    Navigator.pop(
                                      context,
                                      true,
                                    );
                                  } on DioException catch (e) {
                                    showError(e);
                                  } finally {
                                    if (mounted) {
                                      setState(() {
                                        isLoading =
                                            false;
                                      });
                                    }
                                  }
                                },
                          child: const Text(
                            "Delete Event",
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}