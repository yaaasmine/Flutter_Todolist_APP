import 'package:flutter/material.dart';
import 'package:todolist_app/models/task.dart';
import 'package:todolist_app/sevices/firestore.dart';
import 'package:todolist_app/widgets/new_task.dart';
import 'package:todolist_app/widgets/tasks_list.dart';
import 'package:todolist_app/widgets/userprofilpage.dart';

class Tasks extends StatefulWidget {
  const Tasks({Key? key});

  @override
  State<StatefulWidget> createState() {
    return _TasksState();
  }
}

class _TasksState extends State<Tasks> {
  final FirestoreService firestoreService = FirestoreService();

  void deleteTask(Task task) async {
    try {
      await firestoreService.deleteTask(task);
      setState(() {});
    } catch (e) {
      print("Error deleting task: $e");
    }
  }

  Category? selectedCategory;
  void handleCategoryChanged(Category? newCategory) {
    setState(() {
      selectedCategory = newCategory;
    });
  }

  void _addTask(Task task) async {
    setState(() {
      firestoreService.addTask(task);
      Navigator.pop(context);
    });
  }

  void _openAddTaskOverlay() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => NewTask(onAddTask: _addTask),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('ToDoList App'),
        ),
        actions: [
          IconButton(
            onPressed: _openAddTaskOverlay,
            icon: Ink(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 200, 137, 255),
              ),
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => UserProfilePage()));
          },
          icon: Icon(Icons.account_circle),
        ),
      ),
      body: Center(
        child: Column(children: [
          Expanded(
              child: TasksList(
            onDelete: deleteTask,
            selectedCategory: selectedCategory,
            onCategoryChanged: handleCategoryChanged,
          ))
        ]),
      ),
    );
  }
}
