import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/task_model.dart';
import '../helper/task_helper.dart';
import 'add_edit_taskscreen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Task> tasks = [];
  TaskHelper taskHelper = TaskHelper();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    List<Task> loadedTasks = await taskHelper.getTasks();
    setState(() {
      tasks = loadedTasks;
    });
  }

  Future<void> _addTask(Task newTask) async {
    tasks.add(newTask);
    await taskHelper.saveTasks(tasks);
    setState(() {});
  }

  Future<void> _editTask(int index, Task updatedTask) async {
    tasks[index] = updatedTask;
    await taskHelper.saveTasks(tasks);
    setState(() {});
  }

  Future<void> _deleteTask(int index) async {
    tasks.removeAt(index);
    await taskHelper.saveTasks(tasks);
    setState(() {});
  }

  Future<void> _navigateToAddEditTaskScreen({Task? task}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditTaskScreen(task: task),
      ),
    );

    if (result != null) {
      if (task == null) {
        _addTask(result);
      } else {
        int index = tasks.indexOf(task);
        _editTask(index, result);
      }
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn'); // Clear login status
    Navigator.pushReplacementNamed(context, '/login'); // Navigate to LoginScreen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _logout(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0), // Increase padding
                title: Text(
                  task.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18), // Increase title font size
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.green), // Pencil icon
                      onPressed: () => _navigateToAddEditTaskScreen(task: task), // Navigate to edit screen
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red), // Delete icon
                      onPressed: () => _deleteTask(index),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditTaskScreen(),
        backgroundColor: Colors.green, // Green background
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white, // White inside
          ),
          child: const Icon(
            Icons.add,
            color: Colors.green, // Green icon color
          ),
        ),
      ),
    );
  }
}
