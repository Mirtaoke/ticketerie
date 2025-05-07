import 'package:flutter/material.dart';

class EventDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final event = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(title: Text(event['titre'])),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Description: ${event['description']}", style: TextStyle(fontSize: 18)),
            Text("Date: ${event['dateDebut']} - ${event['dateFin']}"),
            Text("Max: ${event['participantsMax']} personnes"),
          ],
        ),
      ),
    );
  }
}
