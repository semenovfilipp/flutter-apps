import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/database_service.dart';
import '../widgets/task_card.dart';
import 'add_edit_task_screen.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({super.key});

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  final DatabaseService _databaseService = DatabaseService.instance;
  List<Task> _completedTasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCompletedTasks();
  }

  Future<void> _loadCompletedTasks() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      final tasks = await _databaseService.readCompletedTasks();

      if (!mounted) return;

      setState(() {
        _completedTasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки: $e')),
        );
      }
    }
  }

  /// Снимаем отметку о выполнении
  Future<void> _uncompleteTask(Task task) async {
    final updatedTask = task.copyWith(
      isCompleted: false,
      completedAt: null,
    );
    await _databaseService.updateTask(updatedTask);
    _loadCompletedTasks();
  }

  Future<void> _deleteTask(int id) async {
    await _databaseService.deleteTask(id);
    _loadCompletedTasks();
  }

  Future<void> _navigateToEditTask(Task task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditTaskScreen(task: task),
      ),
    );

    if (result == true) {
      _loadCompletedTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выполненные задачи'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _completedTasks.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Нет выполненных задач',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: _loadCompletedTasks,
        child: ListView.builder(
          itemCount: _completedTasks.length,
          itemBuilder: (context, index) {
            final task = _completedTasks[index];
            return TaskCard(
              task: task,
              onTap: () => _navigateToEditTask(task),
              onCheckChanged: (_) => _uncompleteTask(task),
              onDelete: () => _deleteTask(task.id!),
            );
          },
        ),
      ),
    );
  }
}
