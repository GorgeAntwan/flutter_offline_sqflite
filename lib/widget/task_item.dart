import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_sqlite/controller/task_controller.dart';
import 'package:offline_sqlite/model/task.dart';
import 'package:offline_sqlite/screen/create_edit_screen.dart';
class TaskItem extends StatelessWidget {
  final int id;
  const TaskItem({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     final TaskController taskController = Get.find<TaskController>() ; 
     taskController.getTaskDetails(id);
     Task taskdetails = taskController.getTaskById(this.id);
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
            elevation: 4,
            child:  Column(
              children: [
                ListTile(
                  title: Text(taskdetails.taskTitle),
                  leading: Icon(Icons.list_alt_sharp),
                  subtitle: Text(taskdetails.taskContent),
                  trailing: Wrap(
                    children: [
                       IconButton(
                       icon: Icon(Icons.edit),
                       onPressed: (){
                            Get.to(()=>CreateEditScreen(id:this.id,editeMode: true,));
                       },
                 ),
                      IconButton(
                       icon: Icon(Icons.delete),
                       onPressed: (){
                          Get.defaultDialog(
                            title: 'Are You Sure you Want to delete Task ?',
                            content: Text(''),
                            
                            actions:[
                                ElevatedButton(onPressed: (){
                                    taskController.deleteTaskById(this.id);
                                    Get.back();
                                }, child: Text('OK'))
                             ] ,
                             cancel:ElevatedButton(onPressed: (){Get.back();}, child: Text('Cancel'),style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),),
                             titleStyle: TextStyle(color: Colors.red)
                            
                          );
                         
                       },
                 ),
                    ],
                  ), 
                ),
                 Container(
                    height: 150,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                          
                    child: Image.file(taskdetails.imageFile,fit:BoxFit.fill ,)
                              
                ),
              ],
            )
         ),
      )
    );
  }
}