import 'package:flutter/material.dart';
import 'package:todolist_app/models/task.dart';

class NewTask extends StatefulWidget {
  
  const NewTask({Key? key, required this.onAddTask});
  final void Function(Task task) onAddTask;

  @override
  State<NewTask> createState() {
    return _NewTaskState();
  }
}

class _NewTaskState extends State<NewTask> {
  Category _selectedCategory = Category.personal;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate; 

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023), 
      lastDate: DateTime(2101), 
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitTaskData() {
    final String title = _titleController.text;
    if (title.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please enter a title for the task to add to the list'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }
     if (_selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please select a date for the task'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),),
            ],
        ),
        );
      return;
     }


    widget.onAddTask(
      Task(
        title: _titleController.text,
        description: _descriptionController.text,
        date: _selectedDate,
        category: _selectedCategory,
      ),
    );

 
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: const InputDecoration(
              labelText: 'Task title',
            ),
          ),
          TextField(
            controller: _descriptionController,
            maxLength: 200,
            decoration: const InputDecoration(
              labelText: 'Description de la tâche',
            ),
          ),
          InkWell(
            onTap: () {
              _selectDate(context);
            },
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Select Date',
              ),
              child: Text(
                _selectedDate != null
                    ? _selectedDate!.toString().split(' ')[0]
                    : 'Choose a Date',
              ),
            ),
          ),
          Row(
            children: [
             DropdownButton<Category>(
  value: _selectedCategory,
  items: Category.values.map((category) => DropdownMenuItem<Category>(
    value: category,
    child: Text(
      category.name.toUpperCase(),
    ),
  )).toList(),
  onChanged: (value) {
    if (value == null) {
      return;
    }
    setState(() {
      _selectedCategory = value;
    });
  },
),
ElevatedButton(
                onPressed: _submitTaskData,
                child: const Text('Enregistrer'),
              ),
            ],
          )
        ],
      ),
    );
  }
}