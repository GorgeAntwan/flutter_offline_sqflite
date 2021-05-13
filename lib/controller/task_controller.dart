import 'dart:io';

import 'package:get/get.dart';
import 'package:offline_sqlite/model/task.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaskController extends GetxController{

  Future<Database> database ;
  List<Task> taskList =[];
   // UPGRADE DATABASE TABLES
  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    if (oldVersion < newVersion) {
       db.execute("ALTER TABLE tasks ADD COLUMN imageFile TEXT;");
    }
  }
  Future<void> intializeDatabase ()async{
    
    // Open the database and store the reference.
        database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'task_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
         //   db.execute("ALTER TABLE tasks ADD COLUMN imageFile TEXT;");
        return db.execute(
          "CREATE TABLE tasks(taskId INTEGER PRIMARY KEY AUTOINCREMENT, userId INTEGER, taskTitle TEXT, taskContent TEXT, imageFile TEXT)",
        );
      
      },
      
      onUpgrade:_onUpgrade ,
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 2,
      );
     
      update();

  }
   
Future<void> getAllTasks() async {
      
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The tasks.
    final List<Map<String, dynamic>> maps = await db.query('tasks');

    // Convert the List<Map<String, dynamic> into a List<Task>.
    taskList =  List.generate(maps.length, (i) {
     
      return Task(
        taskId: maps[i]['taskId'],
        userId: maps[i]['userId'],
        taskTitle: maps[i]['taskTitle'],
        taskContent: maps[i]['taskContent'],
        imageFile: File(maps[i]['imageFile'],)
      );
    });
    taskList.forEach((element) { print(element.toString());});
    update();
  }
  Future<void> insertNewTask(Task task) async {
    
    // Get a reference to the database.
    final Database db = await database;

    // Insert the task into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same task is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
     getAllTasks();
  }
  
  Future<void> getTaskDetails(int id)async{
      try {
          final Database db = await database;
          final List<Map<String, dynamic>> maps = await db.query(
            'tasks',
            where: 'taskId=?',
            whereArgs: [id]
          );

          Task taskdetails =  List.generate(maps.length, (i) {
          
            return Task(
              taskId: maps[i]['taskId'],
              userId: maps[i]['userId'],
              taskTitle: maps[i]['taskTitle'],
              taskContent: maps[i]['taskContent'],
              imageFile: File(maps[i]['imageFile'],)
            );
          }).first;
          print(taskdetails.toString());
      } catch (e) {
        print(e.message);
        throw e;
      }
      
  }

  Task getTaskById(int id){
    return taskList.firstWhere((element) => element.taskId ==id);
  }
  Future<void> deleteTaskById(int id) async {
  // Get a reference to the database.
  final db = await database;

  // Remove the Task from the Database.
  await db.delete(
    'tasks',
    // Use a `where` clause to delete a specific task.
    where: "taskId = ?",
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [id],
  );
  getAllTasks();
}
  Future<void> updateTask(Task task) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Task.
    await db.update(
      'tasks',
      task.toMap(),
      // Ensure that the Dog has a matching id.
      where: "taskId = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [task.taskId],
    );
    getAllTasks();
  }
  File _image;
  File get getImage{
    return _image;
  }
  void updateImage(File newImage){
           _image = newImage;
           update();
  }
  
}