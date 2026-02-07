import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/task_viewmodel.dart';
import '../../viewmodels/auth_viewmodel.dart';
import 'task_detail_view.dart';

// Task List View
class TaskListView extends StatelessWidget {
  const TaskListView({super.key});

  @override
  Widget build(BuildContext context) {
    final taskVM = Provider.of<TaskViewModel>(context, listen: false);
    final authVM = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Tasks'),
      ),
      body: Consumer<TaskViewModel>(
        builder: (context, taskVM, child) {
          if (taskVM.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (taskVM.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 40),
                  const SizedBox(height: 10),
                  Text(
                    'Error: ${taskVM.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: () => taskVM.fetchTasks(),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (taskVM.tasks.isEmpty) {
            return const Center(child: Text('No tasks found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: taskVM.tasks.length,
            itemBuilder: (context, index) {
              final task = taskVM.tasks[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TaskDetailView(task: task)),
                    );
                  },
                  leading: Icon(
                    Icons.task_alt,
                    color: _getPriorityColor(task.priority),
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.status == 'completed'
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  subtitle: Text('${task.category} • ${task.project}'),
                  trailing: Checkbox(
                    value: task.status == 'completed',
                    onChanged: (value) {
                      taskVM.updateTask(task.id, {'status': value! ? 'completed' : 'pending'});
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high': return Colors.red;
      case 'medium': return Colors.orange;
      case 'low': return Colors.green;
      default: return Colors.blue;
    }
  }
}
