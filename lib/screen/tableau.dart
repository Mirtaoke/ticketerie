import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tick/models/admin.dart';
import 'package:tick/models/adminSession.dart';
import 'package:tick/models/dataHelper.dart';

class TableauScreen extends StatefulWidget {
  const TableauScreen({super.key});

  @override
  State<TableauScreen> createState() => _TableauScreenState();
}

class _TableauScreenState extends State<TableauScreen> {
  int eventCount = 0;
  int totalParticipants = 0;
  List<Map<String, dynamic>> events = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final adminSession = Provider.of<AdminSession>(context, listen: false);
    final adminId = adminSession.admin?.id ?? 0;

    final eventCountRes = await DataHelper.instance.getEventCountByAdmin(adminId);
    final participantsRes = await DataHelper.instance.getTotalParticipantsByAdmin(adminId);
    final eventList = await DataHelper.instance.getEventsByAdmin(adminId);

    setState(() {
      eventCount = eventCountRes;
      totalParticipants = participantsRes;
      events = eventList;
    });
  }

  void _showParticipantsDialog(String eventId) async {
    final participants = await DataHelper.instance.getParticipantsByEvent(eventId);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Participants à l'événement"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Nombre total : ${participants.length}"),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: participants.length,
                  itemBuilder: (context, index) {
                    final user = participants[index];
                    return ListTile(
                      title: Text("${user['nom']} ${user['prenom']}"),
                      subtitle: Text(user['email']),
                    );
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Fermer")),
          ],
        );
      },
    );
  }

  void _deleteEvent(String eventId) async {
    await DataHelper.instance.deleteEvent(eventId);
    _loadData(); 
  }

  void _editEvent(String eventId) {
    Navigator.pushNamed(context, '/edit_event', arguments: eventId);
  }

  @override
  Widget build(BuildContext context) {
    final adminSession = Provider.of<AdminSession>(context);
    final admin = adminSession.admin;
    

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Statistiques ", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.article, color: Colors.white), tooltip: "fil d'actualité", onPressed: () {
            Navigator.pushNamed(context, '/actu');
          }),
          IconButton(icon: const Icon(Icons.logout, color: Colors.white), tooltip: "Se déconnecter", onPressed: () {
            Provider.of<AdminSession>(context, listen: false).logout();
            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
          }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildProfile(admin),
            SizedBox(height: 20),
            _buildStats(),
            SizedBox(height: 20),
            _buildEventList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile(Admin? admin) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: Colors.teal, radius: 30, child: Icon(Icons.person, color: Colors.white)),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hello ${admin?.name ?? 'Administrateur'}!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text(admin?.email ?? 'email inconnu', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _statCard("Événements créés", eventCount.toString(), Icons.event),
        _statCard("Total Participants", totalParticipants.toString(), Icons.people),
      ],
    );
  }

  Widget _buildEventList() {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Mes événements", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text(event['titre']), Text(event['description'])],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text("Date : Du ${event['dateDebut']} au ${event['dateFin']}"), Text("Max: ${event['participantsMax'] ?? "Indéfini"} personnes")],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
  icon: Icon(Icons.edit, color: Colors.teal),
  tooltip: "Modifier l'événement",
  onPressed: () {
    Navigator.pushNamed(
      context,
      '/event_details',
      arguments: event, 
    );
  },
),IconButton(
  icon: Icon(Icons.delete, color: Colors.red),
  tooltip: "Supprimer",
  onPressed: () async {
    await DataHelper.instance.deleteEvent(event['id']);
    
    setState(() {
      events.removeWhere((e) => e['id'] == event['id']); 
    });

  
    setState(() {});
  },
),

                        ],
                      ),
                      onTap: () => _showParticipantsDialog(event['id']),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
      child: Column(
        children: [Icon(icon, size: 40, color: Colors.teal), SizedBox(height: 8), Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), Text(value, style: TextStyle(fontSize: 20, color: Colors.teal, fontWeight: FontWeight.bold))],
      ),
    );
  }
}
