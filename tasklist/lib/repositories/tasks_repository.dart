import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasklist/models/task.dart';

const tasksListKey = "taskList";

class TasksRepository {
  late SharedPreferences sharedPreferences;

  Future<List<Task>> getTasksList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(tasksListKey) ?? '[]';

    final List jsonDecoded = json.decode(jsonString) as List;

    return jsonDecoded.map((e) => Task.fromJson(e)).toList();
  }

  void saveTasksList(List<Task> tasks) {
    final String jsonString = json.encode(tasks);
    sharedPreferences.setString(tasksListKey, jsonString);
  }
}
