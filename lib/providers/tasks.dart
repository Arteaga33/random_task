//I will directly use firebase.
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:random_task/models/http_exception.dart';
import 'dart:math';

import './task.dart';

class Tasks with ChangeNotifier {
  List<Task> _taskItems = [];

  List<Task> get allTask {
    return [..._taskItems];
  }

  Task findById(String id) {
    return _taskItems.firstWhere((task) => task.id == id);
  }

  Duration _parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    return Duration(hours: hours, minutes: minutes);
  }

  Future<void> fetchAndSetTasks() async {
    //This should be fix in case tasks empty. tho show something else.
    final url = Uri.parse(
        'https://random-task-selector-default-rtdb.firebaseio.com/tasks.json');
    try {
      final response = await http.get(url);
      // print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String,
          dynamic>; //transform the data response. dynamic because the map in a map.
      if (extractedData == null) {
        return;
      }
      final List<Task> loadedTask = [];
      extractedData.forEach((taskId, taskData) {
        loadedTask.add(
          Task(
            id: taskId,
            title: taskData['title'],
            description: taskData['description'],
            duration: _parseDuration(taskData['duration']),
            dueDate: DateTime.parse(taskData['duedate']),
          ),
        );
      });
      _taskItems = loadedTask;
      notifyListeners();
    } catch (error) {
      rethrow; // i chaged it if it fails use trow (error);
    }
  }

  Future<void> removeTaskById(String Id) async {
    //Working properly =D
    final url = Uri.parse(
        'https://random-task-selector-default-rtdb.firebaseio.com/tasks/$Id.json');
    final existingTaskIndex = _taskItems.indexWhere((task) => task.id == Id);
    Task? existingTask = _taskItems[existingTaskIndex];

    _taskItems.removeAt(existingTaskIndex);
    notifyListeners();

    final response = await http.delete(url);

    print(response.statusCode);

    if (response.statusCode >= 400) {
      _taskItems.insert(existingTaskIndex, existingTask);
      notifyListeners();
      throw HttpException('Could not delete!');
    }
    allTask.removeWhere((task) => task.id == Id);
    notifyListeners();

    existingTask = null;
  }

  Future<void> addNewTask(Task newTask) async {
    //Woriking properly =D
    final url = Uri.parse(
        'https://random-task-selector-default-rtdb.firebaseio.com/tasks.json');
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': newTask.title,
            'description': newTask.description,
            'duedate': newTask.dueDate.toString(),
            'duration': newTask.duration.toString(),
          }));

      final addTaskApp = Task(
          id: json.decode(response.body)['name'],
          title: newTask.title,
          description: newTask.description,
          duration: newTask.duration,
          dueDate: newTask.dueDate);

      _taskItems.add(addTaskApp);

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
    allTask.insert(0, newTask);
  }

  Future<void> updateTask(String id, Task updatedTask) async {
    //Got edited to update in db too.
    //This updates products locally and patch in database
    final taskIndex = _taskItems.indexWhere((prod) => prod.id == id);
    if (taskIndex >= 0) {
      final url = Uri.parse(
          'https://random-task-selector-default-rtdb.firebaseio.com/tasks/$id.json');
      await http.patch(url,
          body: json.encode({
            //This can be inproved with a try catch.
            'title': updatedTask.title,
            'description': updatedTask.description,
            'duedate': updatedTask.dueDate.toString(),
            'duration': updatedTask.duration.toString(),
          })); //This updates the data.
      _taskItems[taskIndex] = updatedTask;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Task randomTaskChooser() {
    // make sure you have greater than 0 improve code.
    Random randomObject = Random();
    Task radomTask = _taskItems[randomObject.nextInt(_taskItems.length)];
    return radomTask;
  }

  
}
