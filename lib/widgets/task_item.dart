import 'package:flutter/material.dart';
import 'package:todolist_app/models/task.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist_app/sevices/firestore.dart';

class TaskItem extends StatefulWidget {
  final FirestoreService firestoreService = FirestoreService();
  TaskItem(this.task, {Key? key, required this.onDelete}) : super(key: key);
  final Task task;
  final void Function(Task) onDelete;

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool done = false;

  @override
  void initState() {
    super.initState();
    doneState();
  }

  void doneState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      done = prefs.getBool(widget.task.title) ?? false;
    });
  }

  void saveState(bool completed) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(widget.task.title, completed);
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = widget.task.date != null
        ? DateFormat.yMMMd().format(widget.task.date!)
        : 'No date';
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: done,
                  onChanged: (bool? value) {
                    setState(() {
                      done = value ?? false;
                      saveState(done);
                      widget.firestoreService.TaskDone(
                        widget.task.title,
                        done,
                      );
                    });
                  },
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.task.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: done ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        widget.task.description,
                        style: TextStyle(
                          color: Colors.grey,
                          decoration: done ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Text(
              'Category: ${widget.task.category.name}',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.indigo,
              ),
            ),
            if (widget.task.date != null)
              Text(
                'Date: $formattedDate',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    widget.onDelete(widget.task);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
