import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_sqlite/screen/home_screen.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'controller/task_controller.dart';

void main() async{
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  final TaskController taskController = Get.put(TaskController()) ; 
  await taskController.intializeDatabase();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.amber,
      ),
      home: HomeScreen(),
      routes: {

      },
    );
  }
}

 