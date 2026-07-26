import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../data/models/event_model.dart';
import '../../data/repositories/event_repository.dart';

class EditEventScreen extends StatefulWidget {
  final EventModel event;

  const EditEventScreen({
    super.key,
    required this.event,
  });

  @override
  State<EditEventScreen> createState() =>
      _EditEventScreenState();
}

class _EditEventScreenState
    extends State<EditEventScreen> {
  final EventRepository repository =
      EventRepository();

  late final TextEditingController
      titleController;

  late final TextEditingController
      descriptionController;

  late final TextEditingController
      venueController;

  late final TextEditingController
      maxAttendeesController;

  late DateTime selectedDateTime;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    titleController =
        TextEditingController(
      text: widget.event.title,
    );

    descriptionController =
        TextEditingController(
      text: widget.event.description,
    );

    venueController =
        TextEditingController(
      text: widget.event.venue,
    );

    maxAttendeesController =
        TextEditingController(
      text: widget.event.maxAttendees
          .toString(),
    );

    selectedDateTime =
        widget.event.dateTime;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    venueController.dispose();
    maxAttendeesController.dispose();
    super.dispose();
  }

  Future<void> pickDateTime() async {
    final date =
        await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
      initialDate:
          selectedDateTime,
    );

    if (date == null) return;

    if (!mounted) return;

    final time =
        await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: selectedDateTime.hour,
        minute:
            selectedDateTime.minute,
      ),
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

  Future<void> saveChanges() async {
    if (titleController.text
            .trim()
            .isEmpty ||
        descriptionController.text
            .trim()
            .isEmpty ||
        venueController.text
            .trim()
            .isEmpty ||
        maxAttendeesController.text
            .trim()
            .isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Please fill all fields.",
          ),
        ),
      );

      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      await repository.updateEvent(
        eventId: widget.event.id,
        title: titleController.text
            .trim(),
        description:
            descriptionController.text
                .trim(),
        venue: venueController.text
            .trim(),
        dateTime:
            selectedDateTime,
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
            "Event updated successfully 🎉",
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
      border:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          12,
        ),
      ),
    );
  }

  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Event",
        ),
      ),
      body:
          SingleChildScrollView(
        padding:
            const EdgeInsets.all(
                20),
        child: Column(
          children: [
                        TextField(
              controller: titleController,
              decoration: decoration("Title"),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: decoration("Description"),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: venueController,
              decoration: decoration("Venue"),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: maxAttendeesController,
              keyboardType: TextInputType.number,
              decoration: decoration(
                "Max Attendees",
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: pickDateTime,
                child: Text(
                  selectedDateTime
                      .toLocal()
                      .toString(),
                ),
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed:
                    isLoading
                        ? null
                        : saveChanges,
                child:
                    isLoading
                        ? const CircularProgressIndicator(
                            color:
                                Colors.white,
                          )
                        : const Text(
                            "Save Changes",
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}