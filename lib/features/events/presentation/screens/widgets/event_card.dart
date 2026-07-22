import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String location;
  final String date;

  const EventCard({
    super.key,
    required this.title,
    required this.location,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(Icons.location_on,size:18),
                const SizedBox(width:5),
                Text(location),
              ],
            ),

            const SizedBox(height:8),

            Row(
              children: [
                const Icon(Icons.calendar_month,size:18),
                const SizedBox(width:5),
                Text(date),
              ],
            ),

            const SizedBox(height:15),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {},
                child: const Text("Register"),
              ),
            )
          ],
        ),
      ),
    );
  }
}