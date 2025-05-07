import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tick/models/adminSession.dart';
import 'package:tick/models/dataHelper.dart';

class EventCreationScreen extends StatefulWidget {
  const EventCreationScreen({super.key});

  @override
  State<EventCreationScreen> createState() => _EventCreationScreenState();
}

class _EventCreationScreenState extends State<EventCreationScreen> {
  DateTime? dateDebut;
  DateTime? dateFin;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final participantsController = TextEditingController();
  bool statutEvenement = false; // Faux tant que la date de fin n’est pas dépassée

  Future<void> _selectDate(bool isStartDate) async {
    DateTime now = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        if (isStartDate) {
          dateDebut = selectedDate;
        } else {
          dateFin = selectedDate;
        }
      });
    }
  }

  Future<void> _createEvent() async {
    if (dateDebut == null || dateFin == null ||
        titleController.text.isEmpty || descriptionController.text.isEmpty || participantsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tous les champs sont obligatoires")),
      );
      return;
    }

    if (dateFin!.isBefore(dateDebut!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("La date de fin doit être supérieure à la date de début")),
      );
      return;
    }

    final int? participantsMax = int.tryParse(participantsController.text.trim());
    if (participantsMax == null || participantsMax <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nombre de participants invalide")),
      );
      return;
    }

    final adminId = Provider.of<AdminSession>(context, listen: false).admin?.id;
    
    final statutParticipants = participantsMax > 0 ? "Non complet" : "Complet";

    final event = {
      "titre": titleController.text.trim(),
      "description": descriptionController.text.trim(),
      "dateDebut": dateDebut!.toIso8601String().split('T')[0], 
      "dateFin": dateFin!.toIso8601String().split('T')[0], 
      "statutEvenement": statutEvenement ? 1 : 0, 
      "statutParticipants": statutParticipants, 
      "createdBy": adminId,
      "participantsMax": participantsMax,
    };

    await DataHelper.instance.insertEvent(event); 
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Événement créé avec succès")),
    );

    Navigator.pop(context); 
  }

  String formatDate(DateTime? dt) {
    if (dt == null) return '';
    return "${dt.day}/${dt.month}/${dt.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
     appBar: AppBar(
        title: const Text(
          "Créer un évènement ",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
        actions: [
          
          IconButton(
            icon: const Icon(Icons.article, color: Colors.white),
            tooltip: "fil d'actualité",
            onPressed: () {
              Navigator.pushNamed(context, '/actu');
            },
          ),
          
          
        IconButton(
  icon: const Icon(Icons.logout, color: Colors.white),
  tooltip: "Se déconnecter",
  onPressed: () {
    Provider.of<AdminSession>(context, listen: false).logout();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  },
),

        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text("Formulaire de création", 
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                   
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _selectDate(true),
                          icon: const Icon(Icons.calendar_today),
                          label: Text(dateDebut == null
                              ? "Sélectionner date de début"
                              : "Début : ${formatDate(dateDebut)}"),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _selectDate(false),
                          icon: const Icon(Icons.calendar_today),
                          label: Text(dateFin == null
                              ? "Sélectionner date de fin"
                              : "Fin : ${formatDate(dateFin)}"),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Titre
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: "Titre de l'évènement",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    
                    TextField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                   
                    TextField(
                      controller: participantsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Nombre maximum de participants",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      icon: const Icon(Icons.send, color: Colors.white),
                      label: const Text("Créer l'évènement", style: TextStyle(color: Colors.white)),
                      onPressed: _createEvent,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
