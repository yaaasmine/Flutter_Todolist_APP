import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todolist_app/models/task.dart';
import 'package:todolist_app/sevices/firestore.dart';
import 'package:todolist_app/widgets/task_item.dart';

class TasksList extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();
  final void Function(Task) onDelete;
  final Category? selectedCategory;
  
  final void Function(Category?) onCategoryChanged; 

  TasksList({Key? key, required this.onDelete, this.selectedCategory, required this.onCategoryChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(alignment: Alignment.centerRight,
        child:
      
        DropdownButton<Category>(
          value: selectedCategory,
          onChanged: (Category? newCategory) {
            onCategoryChanged(newCategory);
          },
          items: [
            DropdownMenuItem<Category>(
              value: null,
              child: Text('All Categories'),
            ),
            for (Category category in Category.values)
              DropdownMenuItem<Category>(
                value: category,
                child: Text(category.name),
              ),
          ],
        ),),
        Expanded(
          child: StreamBuilder<QuerySnapshot?>(
            stream: firestoreService.getTasks(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return CircularProgressIndicator();
              }

              final taskLists = snapshot.data!.docs;

              final filteredTasks = taskLists.where((document) {
                final data = document.data() as Map<String, dynamic>;
                final categoryString = data['taskCategory'];
              

                Category category;
                if (categoryString != null) {
                  category = Category.values.firstWhere(
                    (cat) => cat.toString() == 'Category.$categoryString',
                    orElse: () => Category.others,
                  );
                } else {
                  category = Category.others;
                }

                return (selectedCategory == null || category == selectedCategory) ;
              });
          

              return ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (ctx, index) {
                  DocumentSnapshot document = filteredTasks.elementAt(index);
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                  String title = data['taskTitle'];
                  String description = data['taskDesc'];
                  String categoryString = data['taskCategory'];
                  Timestamp dateTimestamp = data['taskDate'];

                  DateTime? date = dateTimestamp != null
                      ? (dateTimestamp as Timestamp).toDate()
                      : null;

                  Category category;
                  if (categoryString != null) {
                    category = Category.values.firstWhere(
                      (cat) => cat.toString() == 'Category.$categoryString',
                      orElse: () => Category.others,
                    );
                  } else {
                    category = Category.others;
                  }

                  Task task = Task(
                    title: title,
                    description: description,
                    category: category,
                    date: date,
                  );

                  return TaskItem(task, onDelete: onDelete);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}