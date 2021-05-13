
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offline_sqlite/controller/task_controller.dart';
import 'package:offline_sqlite/model/task.dart';

class CreateEditScreen extends StatelessWidget {
  static const routeName ='./create-edite-screen';
  final int id;
  final bool editeMode ;
  const CreateEditScreen({Key key, this.id, this.editeMode}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
       File savedImage;
      File _image;
      
      final picker = ImagePicker();
       final TaskController taskController = Get.find<TaskController>() ;
        Future pickimage( ImageSource takeImage)async{
         Get.back();
          final pickedFile = await picker.getImage(source: takeImage);
            
         
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          //
          final appDir = await syspaths.getApplicationDocumentsDirectory();
          final fileName = path.basename(_image.path);
          savedImage = await _image.copy('${appDir.path}/$fileName');
          taskController.updateImage(savedImage);
          print(savedImage.path);
        } else {
          print('No image selected.');
        }
      }
      Future getImage() async {
        Get.defaultDialog(
          title :"chose to pick image",
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  iconSize: 35,
                  
                   onPressed: (){
                      
                     pickimage(ImageSource.camera);
                    
                   }),
                   SizedBox(width: 20,),
                 IconButton(
                   icon: Icon(Icons.folder), 
                   iconSize: 35,
                   onPressed: (){
                     
                      pickimage(ImageSource.gallery);
                       
                   }),
          ],),
          
        );
        
      
      }
     
     final _formKey = GlobalKey<FormState>();
     TextEditingController taskTitle= new TextEditingController();
     TextEditingController taskContent= new TextEditingController();
      Task taskdetails;
      int userId ,taskId;
     if(editeMode){
        taskdetails = taskController.getTaskById(this.id);
        taskTitle.text = taskdetails.taskTitle;
        taskContent.text = taskdetails.taskContent;
        userId = taskdetails.userId;
        taskId = taskdetails.taskId;
        savedImage = taskdetails.imageFile;
     }
    
     Future<void> saveDate()async{
        final formState = _formKey.currentState;
        if(formState.validate()){
          if(savedImage ==null){
                Get.snackbar(
                  'invalid input',
                  'Please pick image',
                  margin: EdgeInsets.all(5),
                  borderRadius: 5,
                  backgroundColor: Colors.red,
                  colorText: Colors.white
                  );
                 return ;
          }
          print(taskTitle.text);
          print(taskContent.text);
          if(this.editeMode!=true ){
             taskController.insertNewTask(Task(taskTitle:taskTitle.text,taskContent: taskContent.text,userId: 1 ,imageFile: savedImage));

          }else{
            
            taskController.updateTask(Task(taskId: taskId,taskTitle:taskTitle.text,taskContent: taskContent.text,userId: userId,imageFile: savedImage));
          }
          Get.back();
        }
     }
    return Container(
     
      child: GetBuilder<TaskController>(
          
        builder: (_)=>
          Scaffold(
            appBar: AppBar(
              title: Text(editeMode ==true?'Edit Task':'Create New Task'),
            ),
            body: Container(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                      TextFormField(
                        controller: taskTitle,
                          decoration: const InputDecoration(
                          
                            labelText: 'Task Title',
                          ),
                          onSaved: (String value) {
                            // This optional block of code can be used to run
                            // code when the user saves the form.
                          },
                          validator: (String value) {
                            return (value != null && value.trim().length<3) ? 'Must at least 3 characters' : null;
                          },
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          controller: taskContent,
                          decoration: const InputDecoration(                       
                            labelText: 'Task Content',
                          ),
                          onSaved: (String value) {
                            // This optional block of code can be used to run
                            // code when the user saves the form.
                          },
                          validator: (String value) {
                            return (value != null && value.trim().length<5) ? 'Must at least 5 characters' : null;
                          },
                        ),
                        SizedBox(height: 30,),
                        ElevatedButton(onPressed: (){
                          saveDate();
                        }, child: Text('save')),
                        SizedBox(height: 30,),
                        ElevatedButton(onPressed: (){
                            getImage();
                        }, child: Text('pick image')),
                      if(savedImage!= null)
                        Container(
                          height: 250,
                          width: 400,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            
                          ),
                          
                          child: Image.file(savedImage)
                              
                          ),
                         
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}