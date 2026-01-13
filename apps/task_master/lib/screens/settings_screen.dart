import 'package:flutter/material.dart';
import '../services/database_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _showClearAllDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Очистить все задачи?'),
          content: const Text(
            'Это действие удалит все задачи из базы данных. Это действие необратимо!',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () async {
                final db = await DatabaseService.instance.database;
                await db.delete('tasks');
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Все задачи удалены'),
                    ),
                  );
                }
              },
              child: const Text(
                'Удалить',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showClearCompletedDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Очистить выполненные задачи?'),
          content: const Text(
            'Это действие удалит все выполненные задачи из базы данных.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () async {
                final db = await DatabaseService.instance.database;
                await db.delete('tasks', where: 'isCompleted = ?', whereArgs: [1]);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Выполненные задачи удалены'),
                    ),
                  );
                }
              },
              child: const Text(
                'Удалить',
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'О приложении',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('TaskMaster'),
            subtitle: const Text('Версия 1.0.0'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'v1.0.0',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Функции',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check_circle, color: Colors.green[700]),
            title: const Text('CRUD операции'),
            subtitle: const Text('Создание, чтение, обновление, удаление'),
          ),
          ListTile(
            leading: Icon(Icons.swipe, color: Colors.orange[700]),
            title: const Text('Свайп для удаления'),
            subtitle: const Text('Быстрое удаление задач свайпом'),
          ),
          ListTile(
            leading: Icon(Icons.priority_high, color: Colors.red[700]),
            title: const Text('Приоритеты'),
            subtitle: const Text('Низкий, средний, высокий'),
          ),
          ListTile(
            leading: Icon(Icons.filter_list, color: Colors.blue[700]),
            title: const Text('Фильтры'),
            subtitle: const Text('Все, активные, выполненные'),
          ),
          ListTile(
            leading: Icon(Icons.bar_chart, color: Colors.purple[700]),
            title: const Text('Статистика'),
            subtitle: const Text('Прогресс и аналитика задач'),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Управление данными',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.delete_sweep, color: Colors.orange),
            title: const Text('Очистить выполненные'),
            subtitle: const Text('Удалить все выполненные задачи'),
            onTap: () => _showClearCompletedDialog(context),
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('Очистить всё'),
            subtitle: const Text('Удалить все задачи'),
            onTap: () => _showClearAllDialog(context),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Технологии',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.code, color: Colors.blue),
            title: Text('Flutter'),
            subtitle: Text('UI framework'),
          ),
          const ListTile(
            leading: Icon(Icons.storage, color: Colors.green),
            title: Text('SQLite'),
            subtitle: Text('Локальная база данных'),
          ),
          const ListTile(
            leading: Icon(Icons.show_chart, color: Colors.purple),
            title: Text('FL Chart'),
            subtitle: Text('Графики и диаграммы'),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Created with Flutter\n© 2026 TaskMaster',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
