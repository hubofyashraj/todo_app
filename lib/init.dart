import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'data_structure.dart';

class Init{
  static Future initialize() async {
    // taskMap.clear();
    await _loadTasks();
  }

  static _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usr=prefs.getString('user');
    if(usr!=null){
      user=usr;
    }
    tasks = prefs.getStringList('tasks')!;
    if(tasks.isNotEmpty) {
      for (String task in tasks) {
        String? json = prefs.getString(task);
        if(json!=null) {
          Task t = Task.fromJson(jsonDecode(json));
          if(t.completed==true) completed++;
          taskMap[task] = t;
        }
      }
      inComplete=tasks.length-completed;
    }
  }
}