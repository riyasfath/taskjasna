import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/task_model.dart';

class TaskHelper {
  static const String _taskKey = 'tasks';

  Future<List<Task>> getTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? tasksJson = prefs.getStringList(_taskKey);
    if (tasksJson == null) return [];
    return tasksJson.map((taskJson) => Task.fromJson(jsonDecode(taskJson))).toList();
  }

  Future<void> saveTasks(List<Task> tasks) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasksJson = tasks.map((task) => jsonEncode(task.toJson())).toList();
    prefs.setStringList(_taskKey, tasksJson);
  }
}
//