import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TodoController extends GetxController {
  var tasks = [].obs;
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    List? storedTasks = storage.read<List>('tasks');
    if (storedTasks != null) {
      tasks.assignAll(storedTasks);
    }
  }

  void addTask(String title, String description) {
    var task = {
      'title': title,
      'description': description,
      'isCompleted': false
    };
    tasks.add(task);
    _saveTasks();
  }

  void deleteTask(int index) {
    tasks.removeAt(index);
    _saveTasks();
  }

  void editTask(int index, String title, String description) {
    var updatedTask = {
      'title': title,
      'description': description,
      'isCompleted': tasks[index]['isCompleted']
    };
    tasks[index] = updatedTask;
    _saveTasks();
  }

  void toggleTaskCompletion(int index) {
    var updatedTask = {
      'title': tasks[index]['title'],
      'description': tasks[index]['description'],
      'isCompleted': !(tasks[index]['isCompleted'] ?? false)
    };
    tasks[index] = updatedTask;
    _saveTasks();
  }

  void _saveTasks() {
    storage.write('tasks', tasks.toList());
  }
}
