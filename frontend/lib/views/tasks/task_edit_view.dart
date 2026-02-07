import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/task_model.dart';
import '../../viewmodels/task_viewmodel.dart';
import '../../viewmodels/auth_viewmodel.dart';

// Task Edit View
class TaskEditView extends StatefulWidget {
  final Task task;
  const TaskEditView({super.key, required this.task});

  @override
  State<TaskEditView> createState() => _TaskEditViewState();
}

class _TaskEditViewState extends State<TaskEditView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late String _priority;
  late String _category;
  late String _project;
  String? _assignedUserId;
  DateTime? _dueDate;

  final List<String> _priorities = ['low', 'medium', 'high'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descController = TextEditingController(text: widget.task.description);
    _priority = widget.task.priority;
    _category = widget.task.category;
    _project = widget.task.project;
    _dueDate = widget.task.dueDate;
    _assignedUserId = widget.task.userId;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final taskVM = Provider.of<TaskViewModel>(context, listen: false);
      final authVM = Provider.of<AuthViewModel>(context, listen: false);
      
      taskVM.fetchCategories();
      
      if (authVM.user?.role == 'admin') {
        taskVM.fetchUsers();
      }
    });
  }

  Future<void> _update() async {
    if (_formKey.currentState!.validate()) {
      final authVM = Provider.of<AuthViewModel>(context, listen: false);
      
      final Map<String, dynamic> taskData = {
        'title': _titleController.text,
        'description': _descController.text,
        'priority': _priority,
        'category': _category,
        'project': _project,
        'dueDate': _dueDate?.toIso8601String(),
      };

      if (authVM.user?.role == 'admin') {
        taskData['userId'] = _assignedUserId;
      }

      final success = await Provider.of<TaskViewModel>(context, listen: false)
          .updateTask(widget.task.id, taskData);

      if (success && mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskVM = Provider.of<TaskViewModel>(context, listen: false);
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Enter title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Enter description'
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _priority,
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                ),
                items: _priorities
                    .map(
                      (p) => DropdownMenuItem(
                        value: p,
                        child: Text(p.toUpperCase()),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _priority = val!),
              ),
              const SizedBox(height: 16),
              Consumer<TaskViewModel>(
                builder: (context, taskVM, child) {
                  return DropdownButtonFormField<String>(
                    value: _category,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: taskVM.categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) => setState(() => _category = val!),
                  );
                },
              ),
              const SizedBox(height: 16),
              Consumer<TaskViewModel>(
                builder: (context, taskVM, child) {
                  return DropdownButtonFormField<String>(
                    value: _project,
                    decoration: const InputDecoration(
                      labelText: 'Project',
                      border: OutlineInputBorder(),
                    ),
                    items: taskVM.projects
                        .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                    onChanged: (val) => setState(() => _project = val!),
                  );
                },
              ),
              const SizedBox(height: 16),
              if (authVM.user?.role == 'admin')
                Consumer<TaskViewModel>(
                  builder: (context, taskVM, child) {
                    return DropdownButtonFormField<String>(
                      value: _assignedUserId,
                      decoration: const InputDecoration(
                        labelText: 'Assign to User',
                        hintText: 'Select a user',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      items: taskVM.assignableUsers
                          .map((u) => DropdownMenuItem(
                                value: u.id,
                                child: Text(u.name),
                              ))
                          .toList(),
                      onChanged: (val) => setState(() => _assignedUserId = val),
                    );
                  },
                ),
              if (authVM.user?.role == 'admin') const SizedBox(height: 16),
              ListTile(
                title: Text(
                  _dueDate == null
                      ? 'Select Date'
                      : DateFormat('MMM dd, yyyy').format(_dueDate!),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _dueDate ?? DateTime.now(),
                    firstDate: DateTime.now().subtract(
                      const Duration(days: 365),
                    ),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) setState(() => _dueDate = date);
                },
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _update,
                child: const Text('Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
