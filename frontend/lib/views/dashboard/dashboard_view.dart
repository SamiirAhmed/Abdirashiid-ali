import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/task_viewmodel.dart';
import '../tasks/task_list_view.dart';
import '../tasks/task_create_view.dart';
import '../widgets/app_drawer.dart';

// Dashboard View
class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    // Fetch tasks if list is empty
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final taskVM = Provider.of<TaskViewModel>(context, listen: false);
      if (taskVM.tasks.isEmpty) {
        taskVM.fetchTasks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    final taskVM = Provider.of<TaskViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Task Management')),
      drawer: const AppDrawer(),
      body: Consumer<TaskViewModel>(
        builder: (context, taskVM, child) {
          final completedTasks = taskVM.tasks
              .where((t) => t.status == 'completed')
              .length;
          final pendingTasks = taskVM.tasks
              .where((t) => t.status == 'pending')
              .length;

          return RefreshIndicator(
            onRefresh: () => taskVM.fetchTasks(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<AuthViewModel>(
                    builder: (context, authVM, child) {
                      return Text(
                        'Welcome, ${authVM.user?.name ?? "User"}!',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  // Summary Cards
                  Row(
                    children: [
                      _buildSummaryCard(
                        context,
                        'Completed',
                        completedTasks.toString(),
                        Colors.green,
                        Icons.check_circle,
                      ),
                      const SizedBox(width: 16),
                      _buildSummaryCard(
                        context,
                        'Pending',
                        pendingTasks.toString(),
                        Colors.orange,
                        Icons.pending_actions,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Your recent tasks',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // Task List Preview
                  if (taskVM.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (taskVM.error.isNotEmpty)
                    Center(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 40,
                          ),
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
                    )
                  else if (taskVM.tasks.isEmpty)
                    const Center(child: Text('No tasks right now'))
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: taskVM.tasks.length > 5 ? 5 : taskVM.tasks.length,
                      itemBuilder: (context, index) {
                        final task = taskVM.tasks[index];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _getPriorityColor(task.priority),
                              child: const Icon(Icons.task, color: Colors.white),
                            ),
                            title: Text(task.title),
                            subtitle: Text(task.category),
                            trailing: Icon(
                              task.status == 'completed'
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: task.status == 'completed'
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TaskListView()),
                        );
                      },
                      child: const Text('View all tasks'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TaskCreateView()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(title, style: TextStyle(color: color.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }
}
