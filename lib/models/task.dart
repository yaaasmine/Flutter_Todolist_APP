import 'package:uuid/uuid.dart';



const uuid = Uuid();

enum Category { personal, work, shopping, others }

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime? date;
  final Category category;
  bool completed;

  Task({
    required this.title,
    required this.description,
    this.date,
    required this.category,
    this.completed = false,
  }) : id = uuid.v4();

  
}