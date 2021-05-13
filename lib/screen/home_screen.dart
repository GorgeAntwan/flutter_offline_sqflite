import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_sqlite/controller/task_controller.dart';
import 'package:offline_sqlite/model/task.dart';
import 'package:offline_sqlite/screen/create_edit_screen.dart';
import 'package:offline_sqlite/widget/task_item.dart';

 class HomeScreen extends StatelessWidget {
   const HomeScreen({Key key}) : super(key: key);
 
   @override
   Widget build(BuildContext context) {
     final TaskController taskController = Get.find<TaskController>() ; 
     
     return Container(
       child: Scaffold(
         appBar: AppBar(
           title: Text('Tasks'),
         ),
         body: Container(
           child: GetBuilder<TaskController>(
             init: TaskController()  ,
             initState: (_)async=> await taskController.getAllTasks(),

             builder: (_)=>
             Padding(
               padding: const EdgeInsets.all(5.0),
               child: ListView.builder(
                 itemCount:taskController.taskList.length ,
                 itemBuilder: (cntx,i){
                 return TaskItem(id:taskController.taskList[i].taskId);
               }),
             ),
           ),
         ),
         floatingActionButton: 
            FloatingActionButton(
              onPressed: () { 
                Get.to(()=>CreateEditScreen(editeMode: false,));
                //taskController.insertNewTask(Task(taskId: 4,taskTitle: 'second task',taskContent: 'second task content',userId:1));
               
                //taskController.getAllTasks();
                //  taskController.getTaskDetails(5).catchError((error){
                //    print('onError ${error.message}');
                //    Get.rawSnackbar(title:"error eccuor",
                //      message: error.message,backgroundColor:Colors.red,borderRadius: 5,margin: EdgeInsets.all(15) );
                //     Get.snackbar(
                //       "error eccuor",
                //       error.message,
                //        backgroundColor:Colors.red,
                //        colorText: Colors.white
                //     ); 
                //    Get.defaultDialog(title: 'error ocurre',content:Text(error.message),actions:[
                //         ElevatedButton(onPressed: (){}, child: Text('OK'))
                //      ] ,
                //      cancel:ElevatedButton(onPressed: (){Get.back();}, child: Text('Cancel')),
                //      titleStyle: TextStyle(color: Colors.red)
                //     );
                //  });
                },
              child: Icon(Icons.add),
            ),
       ),
     );
   }
 }