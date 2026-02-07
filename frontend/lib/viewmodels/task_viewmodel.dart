import 'package:flutter/material.dart';
import '../../models/task_model.dart';
import '../../models/user_model.dart';
import '../../services/task_service.dart';
import '../../services/auth_service.dart';

// Task ViewModel
class TaskViewModel extends ChangeNotifier {
  final TaskService _taskService = TaskService();
  final AuthService _authService = AuthService();
  
  List<Task> _tasks = [];
  List<User> _assignableUsers = [];
  List<String> _categories = [];
  List<String> _projects = [];
  bool _isLoading = false;
  String _error = '';

  List<Task> get tasks => _tasks;
  List<User> get assignableUsers => _assignableUsers;
  List<String> get categories => _categories;
  List<String> get projects => _projects;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Fetch Tasks
  Future<void> fetchTasks() async {
    _setLoading(true);
    _error = '';
    print('DEBUG: Starting fetchTasks...');
    
    try {
      _tasks = await _taskService.getTasks();
      print('DEBUG: Successfully fetched ${_tasks.length} tasks');
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      print('DEBUG: Error fetching tasks: $_error');
    } finally {
      _setLoading(false);
    }
  }

  // Fetch Categories & Projects
  Future<void> fetchCategories() async {
    try {
      final data = await _taskService.getCategories();
      
      // Separate categories and projects
      _categories = data
          .where((item) => item['type'] == 'category')
          .map<String>((item) => item['name'].toString())
          .toList();
          
      _projects = data
          .where((item) => item['type'] == 'project')
          .map<String>((item) => item['name'].toString())
          .toList();

      // Add default if empty
      if (_categories.isEmpty) _categories = ['Work', 'Personal', 'Shopping', 'Urgent'];
      if (_projects.isEmpty) _projects = ['Main Project'];
      
      notifyListeners();
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  // Fetch Users for Assignment (Admin Only)
  Future<void> fetchUsers() async {
    try {
      _assignableUsers = await _authService.getUsers();
      notifyListeners();
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  // Mark Task as Completed
  Future<bool> markAsCompleted(String id) async {
    _setLoading(true);
    try {
      final updatedTask = await _taskService.updateTask(id, {'status': 'completed'});
      final index = _tasks.indexWhere((t) => t.id == id);
      if (index != -1) {
        _tasks[index] = updatedTask;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Add Category
  Future<bool> addCategory(String name) async {
    return _addItem(name, 'category');
  }

  // Add Project
  Future<bool> addProject(String name) async {
    return _addItem(name, 'project');
  }

  Future<bool> _addItem(String name, String type) async {
    _setLoading(true);
    try {
      await _taskService.createCategory(name, type);
      await fetchCategories(); // Refresh list
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Add Task
  Future<bool> addTask(Map<String, dynamic> taskData) async {
    _setLoading(true);
    try {
      final newTask = await _taskService.createTask(taskData);
      _tasks.insert(0, newTask);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update Task
  Future<bool> updateTask(String id, Map<String, dynamic> taskData) async {
    _setLoading(true);
    try {
      final updatedTask = await _taskService.updateTask(id, taskData);
      final index = _tasks.indexWhere((t) => t.id == id);
      if (index != -1) {
        _tasks[index] = updatedTask;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete Task
  Future<bool> deleteTask(String id) async {
    _setLoading(true);
    try {
      await _taskService.deleteTask(id);
      _tasks.removeWhere((t) => t.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
