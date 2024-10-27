import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todolist_app/models/task.dart';

class FirestoreService {
  final CollectionReference tasks =
      FirebaseFirestore.instance.collection('tasks');

    Future<void> addTask(Task task) {
    return FirebaseFirestore.instance.collection('tasks').add(
      {
        'taskTitle': task.title.toString(),
        'taskDesc': task.description.toString(),
          'taskCategory': task.category.toString().split('.').last, 
        'taskDate': task.date != null
          ? Timestamp.fromDate(DateTime(
              task.date!.year, task.date!.month, task.date!.day))
          : null,
      },
    );  
  }
  Stream<QuerySnapshot> getTasks() {
    final taskStream = tasks.snapshots();
    return taskStream;
  }

 Future<void> deleteTask(Task task) {
  return tasks
      .where('taskTitle', isEqualTo: task.title)
      .get()
      .then((querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      doc.reference.delete();
    });
  });
}
 Future<void> TaskDone(String taskTitle, bool done) async {
  try {
    final querySnapshot = await tasks.where('taskTitle', isEqualTo: taskTitle).get();

    if (querySnapshot.docs.isNotEmpty) {
      final taskDoc = querySnapshot.docs.first.reference;
      await taskDoc.update({'completed': done});
    } else {
      print('No document: $taskTitle');
    }
  } catch (e) {
    print('Error updating document: $e');
  }
}
}