import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'todo_controller.dart';

class HomePage extends StatelessWidget {
  final TodoController controller = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('To-Do List'),
          centerTitle: true,
        ),
        body: Obx(() => ListView.builder(
              itemCount: controller.tasks.length,
              itemBuilder: (context, index) {
                var task = controller.tasks[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(task['title']),
                      subtitle: Text(task['description']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit,
                                color: Color.fromARGB(255, 65, 33, 243)),
                            onPressed: () {
                              _showEditTaskDialog(context, index);
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              controller.deleteTask(index);
                            },
                          ),
                          Checkbox(
                            value: task['isCompleted'],
                            onChanged: (value) {
                              controller.toggleTaskCompletion(index);
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(), // Add a divider after each ListTile
                  ],
                );
              },
            )),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            _showAddTaskDialog(context);
          },
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TodoController controller = Get.find<TodoController>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                // Add the task to the list
                String title = titleController.text.trim();
                String description = descriptionController.text.trim();

                if (title.isNotEmpty && description.isNotEmpty) {
                  controller.addTask(title, description);
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditTaskDialog(BuildContext context, int index) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TodoController controller = Get.find<TodoController>();

    // Pre-fill the text fields with the current values
    var task = controller.tasks[index];
    titleController.text = task['title'];
    descriptionController.text = task['description'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                // Update the task in the list
                String title = titleController.text.trim();
                String description = descriptionController.text.trim();

                if (title.isNotEmpty && description.isNotEmpty) {
                  controller.editTask(index, title, description);
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
            ),
          ],
        );
      },
    );
  }
}
