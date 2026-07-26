import 'package:flutter/material.dart';

import '../../data/models/event_model.dart';

class EventDetailsScreen
    extends StatelessWidget {
  final EventModel event;

  const EventDetailsScreen({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
      ),
      body: Center(
        child: Text(
          event.description,
        ),
      ),
    );
  }
}