import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:contacts_buddy/model/contact.dart';

class DatabaseHandler {
  //create table contacts
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'example.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE contacts(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, phoneNum INTEGER NOT NULL, email TEXT)",);
      },
      version: 1,);
  }

  //insert
  Future<int> insertContact(List<Contact> contacts) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var contact in contacts) {
      result = await db.insert('contacts', contact.toMap());
    }
    return
      result;
  }

  //Read
  Future<List<Contact>> retrieveContact() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('contacts');
    return queryResult.map((e) => Contact.fromMap(e)).toList();
  }


  //Delete
  Future<void> deleteContact(int id) async {
    final db = await initializeDB();
    await db.delete(
      'contacts',
      where: "id = ?", whereArgs: [id],
    );
  }

  //Update
  Future<void> updateContact(Contact contact) async {
    final db = await initializeDB();
    await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

}
