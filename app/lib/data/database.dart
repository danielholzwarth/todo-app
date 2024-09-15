import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  final _box = Hive.box("TODOBOX");

  List toDoList = [];

  void createInitialData() {
    toDoList = [
      ["Download notes app", true],
      ["Make someone laugh", false],
    ];
  }

  void loadData() {
    toDoList = _box.get("TODOLIST");
  }

  void updateDatabase() {
    _box.put("TODOLIST", toDoList);
  }
}
