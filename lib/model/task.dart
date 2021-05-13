import 'dart:io';

class Task{
  final int taskId;
  final int userId;
  final String taskTitle;
  final String taskContent;
 final File imageFile;
  Task({this.taskId, this.userId, this.taskTitle, this.taskContent,this.imageFile, });
  Map<String,dynamic> toMap(){
    return {
      'taskId':this.taskId,
      'userId':this.userId, 
      'taskTitle':this.taskTitle,
      'taskContent':this.taskContent,
      'imageFile':this.imageFile.path
    };
  }
 @override
  String toString() {
    
    return 'taskId : $taskId, userId : $userId, taskTitle : $taskTitle, taskContent : $taskContent, imageFilePath : ${this.imageFile.path}';
  }
   

}