import 'package:app/data/database.dart';
import 'package:app/util/dialog_box.dart';
import 'package:app/util/todo_tile.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  final _db = ToDoDatabase();
  final _box = Hive.box("TODOBOX");

  @override
  void initState() {
    if (_box.get("TODOLIST") == null) {
      _db.createInitialData();
      super.initState();
      return;
    }

    _db.loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "TO DO",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: _db.toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: _db.toDoList[index][0],
            taskCompleted: _db.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      _db.toDoList[index][1] = value;
    });
    _db.updateDatabase();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void saveNewTask() {
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          content: Text(
            "Note can not be emtpy!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      );
      return;
    }

    if (_controller.text.length > 50) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          content: Text(
            "Note is too long!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    setState(() {
      _db.toDoList.add([_controller.text, false]);
    });
    _controller.clear();
    _db.updateDatabase();
    Navigator.of(context).pop();
  }

  void deleteTask(int index) {
    setState(() {
      _db.toDoList.removeAt(index);
    });
    _db.updateDatabase();
  }
}
