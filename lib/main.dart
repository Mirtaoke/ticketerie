import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:tick/models/adminSession.dart';


import 'package:tick/screen/actualit%C3%A9.dart';
import 'package:tick/screen/connexion_admin.dart';
import 'package:tick/screen/creation.dart';
import 'package:tick/screen/detail.dart';
import 'package:tick/screen/inscription_admin.dart';
import 'package:provider/provider.dart';
import 'package:tick/screen/tableau.dart';

import 'screen/accueil.dart' show AdminHomePage;

void initDatabase() {
  databaseFactory = databaseFactoryFfiWeb; 
}

void main() {
  initDatabase();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(create: (context) => AdminSession(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      //home:  RegisterAdminScreen(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginAdminScreen(),
        '/homeAdmin': (context) => AdminHomePage(),
        '/register_admin': (context) => RegisterAdminScreen(),
        '/create_event': (context) => EventCreationScreen(),
        '/statistics': (context) => TableauScreen(),
        '/actu': (context) => EventFeedScreen(),
        '/event_details': (context) => EventDetailsScreen(),
      },
    );
  }
}
