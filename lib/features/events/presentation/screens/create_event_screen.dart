import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../data/repositories/event_repository.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({
    super.key,
  });

  @override
  State<CreateEventScreen> createState() =>
      _CreateEventScreenState();
}

class _CreateEventScreenState
    extends State<CreateEventScreen> {
  final EventRepository repository =
      EventRepository();

  final titleController =
      TextEditingController();

  final descriptionController =
      TextEditingController();

  final venueController =
      TextEditingController();

  final maxAttendeesController =
      TextEditingController();

  DateTime? selectedDateTime;

  bool isLoading = false;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    venueController.dispose();
    maxAttendeesController.dispose();
    super.dispose();
  }

  Future<void> pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
      initialDate: DateTime.now(),
    );

    if (date == null) return;

    if (!mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    setState(() {
      selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> createEvent() async {
    if (titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty ||
        venueController.text.trim().isEmpty ||
        maxAttendeesController.text
            .trim()
            .isEmpty ||
        selectedDateTime == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text("Please fill all fields."),
        ),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      await repository.createEvent(
        title: titleController.text.trim(),
        description:
            descriptionController.text
                .trim(),
        venue: venueController.text.trim(),
        dateTime: selectedDateTime!,
        maxAttendees: int.parse(
          maxAttendeesController.text
              .trim(),
        ),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Event created successfully 🎉",
          ),
        ),
      );

      Navigator.pop(context, true);
    } on DioException catch (e) {
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
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  InputDecoration decoration(
    String label,
  ) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Create Event"),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration:
                  decoration("Title"),
            ),

            const SizedBox(height: 20),

            TextField(
              controller:
                  descriptionController,
              maxLines: 4,
              decoration:
                  decoration("Description"),
            ),

            const SizedBox(height: 20),

            TextField(
              controller:
                  venueController,
              decoration:
                  decoration("Venue"),
            ),

            const SizedBox(height: 20),

            TextField(
              controller:
                  maxAttendeesController,
              keyboardType:
                  TextInputType.number,
              decoration: decoration(
                "Max Attendees",
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed:
                    pickDateTime,
                child: Text(
                  selectedDateTime ==
                          null
                      ? "Select Date & Time"
                      : selectedDateTime
                          .toString(),
                ),
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : createEvent,
                child: isLoading
                    ? const CircularProgressIndicator(
                        color:
                            Colors.white,
                      )
                    : const Text(
                        "Create Event",
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}