import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/admin.dart';

class DataHelper {
  static final DataHelper instance = DataHelper._init();
  static Database? _database;

  DataHelper._init();

  

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tick.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<bool> emailExists(String email) async {
    final db = await instance.database;
    final result = await db.query(
      'admins',
      where: 'email = ?',
      whereArgs: [email],
    );

    return result.isNotEmpty;
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE admins (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT NOT NULL,
      password TEXT NOT NULL
    )
  ''');
  
  await db.execute('''
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nom TEXT NOT NULL,
      prenom TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      evenementsParticipes TEXT
    );
  ''');


    await db.execute('''
    CREATE TABLE events (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      titre TEXT NOT NULL,
      description TEXT NOT NULL,
      dateDebut TEXT NOT NULL,
      dateFin TEXT NOT NULL,
      statutEvenement INTEGER NOT NULL, -- 0 = Actif, 1 = Expiré
      statutParticipants TEXT NOT NULL, -- "Non complet" ou "Complet"
      createdBy INTEGER NOT NULL,
      participantsMax INTEGER NOT NULL
    )
  ''');
  }

  Future<int> insertAdmin(Admin admin) async {
    final db = await instance.database;
    return await db.insert('admins', admin.toMap());
  }

  Future<Admin?> getAdminByEmailAndPassword(
    String email,
    String password,
  ) async {
    final db = await instance.database;
    final result = await db.query(
      'admins',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return Admin(
        id: result.first['id'] as int,
        name: result.first['name'] as String,
        email: result.first['email'] as String,
        password: result.first['password'] as String,
      );
    } else {
      return null;
    }
  }

  Future<int> insertEvent(Map<String, dynamic> event) async {
    final db = await instance.database;
    return await db.insert('events', event);
  }

  Future<List<Map<String, dynamic>>> getAllEvents() async {
    final db = await instance.database;
    return await db.query('events');
  }

  Future<void> updateEventStatuses(
    String eventId,
    String statutEvenement,
    String statutParticipants,
  ) async {
    final db = await instance.database;
    await db.update(
      'events',
      {
        'statutEvenement': statutEvenement,
        'statutParticipants': statutParticipants,
      },
      where: 'id = ?',
      whereArgs: [eventId],
    );
  }

 
  Future<int> getEventCountByAdmin(int adminId) async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM events WHERE createdBy = ?',
      [adminId],
    );
    return result.isNotEmpty ? result.first['count'] as int : 0;
  }


  Future<int> getTotalParticipantsByAdmin(int adminId) async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT SUM(participantsMax) as total FROM events WHERE createdBy = ?',
      [adminId],
    );
    return result.isNotEmpty ? result.first['total'] as int : 0;
  }

 
  Future<List<Map<String, dynamic>>> getEventsByAdmin(int adminId) async {
    final db = await instance.database;
    return await db.query(
      'events',
      where: 'createdBy = ?',
      whereArgs: [adminId],
    );
  }

 Future<void> updateUser(String email, String nom, String prenom) async {
  final db = await instance.database;
  await db.update(
    'users',
    {'nom': nom, 'prenom': prenom},
    where: 'email = ?',
    whereArgs: [email],
  );
}


  Future<void> deleteUserParticipation(String email, String eventId) async {
  final db = await instance.database;
  await db.delete(
    'users',
    where: 'email = ? AND evenementsParticipes = ?',
    whereArgs: [email, eventId],
  );
}


  Future<Map<String, dynamic>?> getUserByEvent(String eventId) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'evenementsParticipes = ?',
      whereArgs: [eventId],
      limit: 1, 
    );

    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> getParticipantsByEvent(
    String eventId,
  ) async {
    final db = await instance.database;
    return await db.query(
      'users',
      where:
          'evenementsParticipes LIKE ?',
      whereArgs: ['%$eventId%'], 
    );
  }

  Future<void> deleteEvent(String eventId) async {
    final db = await instance.database;
    await db.delete('events', where: 'id = ?', whereArgs: [eventId]);

  
    await db.delete(
      'users',
      where: 'evenementsParticipes LIKE ?',
      whereArgs: ['%$eventId%'],
    );
  }
Future<void> updateEvent(String eventId, Map<String, dynamic> updatedEvent) async {
  final db = await instance.database;
  await db.update(
    'events',
    updatedEvent,
    where: 'id = ?',
    whereArgs: [eventId],
  );
}


Future<void> registerUser(String eventId, String nom, String prenom, String email) async {
  final db = await instance.database;
  await db.insert('users', {
    'nom': nom,
    'prenom': prenom,
    'email': email,
    'evenementsParticipes': eventId
  });

  print("Utilisateur inscrit avec succès !");
}


  
}
