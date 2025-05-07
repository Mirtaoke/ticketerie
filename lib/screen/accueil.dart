import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tick/models/adminSession.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
     appBar: AppBar(
        title: const Text(
          "Accueil ",
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
        child: Container(
          padding: const EdgeInsets.all(32),
          width: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/create_event');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text(
                  'Créer un Événement',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/statistics');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text(
                  'Statistiques',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
