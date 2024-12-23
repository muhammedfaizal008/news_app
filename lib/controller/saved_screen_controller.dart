import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class SavedScreenController with ChangeNotifier {
  static late Database database;
  List<Map<String, dynamic>> savedArticles = [];


  static Future<void> initDb() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfi;
      databaseFactory = databaseFactoryFfiWeb;
    }
    database = await openDatabase(
      "saved.db",
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE Saved (id INTEGER PRIMARY KEY, title TEXT, description TEXT, urlToImage TEXT, url TEXT, content TEXT, author TEXT, source TEXT)');
      },
    );
  }

  Future<void> addToSaved({
    required String title,
    required String description,
    required String urlToImage,
    required String url,
    required String content,
    required String author,
    required String source,
  }) async {
    try {
      await database.rawInsert(
        'INSERT INTO Saved(title, description, urlToImage, url, content, author, source) VALUES(?, ?, ?, ?, ?, ?, ?)',
        [title, description, urlToImage, url, content, author, source],
      );
      await updateSavedArticles();
    } catch (e) {
      log("Error adding to saved: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getSaved() async {
    try {
      List<Map<String, dynamic>> list = await database.rawQuery('SELECT * FROM Saved');
      if (kDebugMode) {
        log(list.toString()); 
      }
      return list;
    } catch (e) {
      log("Error fetching saved articles: $e");
      return [];
    }
  }

  Future<void> deleteSaved(int id) async {
    try {
      await database.rawDelete('DELETE FROM Saved WHERE id = ?', [id]);
      await updateSavedArticles(); 
    } catch (e) {
      log("Error deleting article: $e");
    }
  }


  Future<void> updateSavedArticles() async {
    savedArticles = await getSaved();
    notifyListeners(); 
  }
}
