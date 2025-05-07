import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:tick/models/dataHelper.dart';
class EventFeedScreen extends StatefulWidget {
  const EventFeedScreen({super.key});

  @override
  State<EventFeedScreen> createState() => _EventFeedScreenState();
}

class _EventFeedScreenState extends State<EventFeedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> allEvents = [];
  List<Map<String, dynamic>> activeEvents = [];
  List<Map<String, dynamic>> expiredEvents = [];

  

  Future<void> _loadEvents() async {
    final events = await DataHelper.instance.getAllEvents();

    setState(() {
      allEvents = events;
      activeEvents = events.where((e) => e['statutEvenement'] == 0).toList();
      expiredEvents = events.where((e) => e['statutEvenement'] == 1).toList();
    });
  }

  List<Map<String, dynamic>> events = [];
  Map<String, bool> userParticipation = {}; // Stocke la participation de l’utilisateur

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadEvents();
  }void _showRegistrationForm(String eventId) {
  print("Ouverture du formulaire pour l'événement : $eventId"); // Vérification

  final nameController = TextEditingController();
  final prenomController = TextEditingController();
  final emailController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Participant"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Nom")),
            TextField(controller: prenomController, decoration: InputDecoration(labelText: "Prénom")),
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Annuler")),
          ElevatedButton(
            onPressed: () async {
              print("Validation de l'inscription...");

              await DataHelper.instance.registerUser(eventId, nameController.text.trim(), prenomController.text.trim(), emailController.text.trim());

              setState(() {
                userParticipation[eventId] = true;
              });

              print("Inscription réussie pour l'événement : $eventId"); 
              Navigator.pop(context);
            },
            child: Text("Valider"),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          "Fil d'actualité ",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Center(
        // Permet de centrer la page
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 700,
          ), // Limite l’étalement
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Boutons de filtre
                  ButtonsTabBar(
                    controller: _tabController,
                    backgroundColor: Colors.teal,
                    unselectedBackgroundColor: Colors.white,
                    labelStyle: const TextStyle(color: Colors.white),
                    unselectedLabelStyle: const TextStyle(color: Colors.black),
                    radius: 12,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    tabs: [
                      const Tab(text: "Tout"),
                      const Tab(text: "Actifs"),
                      const Tab(text: "Expirés"),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ), // Ajoute de l’espace sous les boutons
                  // Liste des événements
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildEventList(allEvents),
                        _buildEventList(activeEvents),
                        _buildEventList(expiredEvents),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventList(List<Map<String, dynamic>> events) {
    return events.isEmpty
        ? Center(child: Text("Aucun événement disponible"))
        : ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              final isParticipating = userParticipation[event['id']] ?? false;

              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(event['titre'], style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text(event['description']),
                      ],
                    ),
                    subtitle: Text("Date : ${event['dateDebut']} - ${event['dateFin']}"),
                    trailing: isParticipating
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.teal),
                                onPressed: () => _showRegistrationForm(event['id']),
                              ),
                              IconButton(
                                icon: Icon(Icons.cancel, color: Colors.red),
                                onPressed: () async {
                                  await DataHelper.instance.deleteUserParticipation("USER_EMAIL", event['id']);
                                  setState(() {
                                    userParticipation[event['id']] = false;
                                  });
                                },
                              ),
                            ],
                          )
                        : ElevatedButton(
  onPressed: () {
    if (event['id'] != null) {
      _showRegistrationForm(event['id'].toString());
      print("Erreur : ID de l'événement est null");
    }
  },
  child: Text("Participer"),
),


                  ),
                ),
              );
            },
          );
  }
}
