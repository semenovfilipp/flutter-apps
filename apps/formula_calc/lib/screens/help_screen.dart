import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Справка'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionCard(
            title: 'О приложении',
            icon: Icons.info,
            color: Colors.blue,
            children: [
              const Text(
                'FormulaCalc - справочник формул с калькулятором для школьников и студентов.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              const Text(
                'Приложение содержит формулы по математике, физике и химии с возможностью быстрого расчета.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            title: 'Как использовать',
            icon: Icons.help_outline,
            color: Colors.green,
            children: [
              _buildHelpItem(
                '1. Выберите предмет',
                'На главной странице выберите нужный предмет: Математика, Физика или Химия.',
              ),
              _buildHelpItem(
                '2. Найдите формулу',
                'Просмотрите список формул и выберите нужную для расчета.',
              ),
              _buildHelpItem(
                '3. Введите данные',
                'Заполните значения всех переменных в калькуляторе.',
              ),
              _buildHelpItem(
                '4. Получите результат',
                'Нажмите кнопку "Вычислить" для получения результата.',
              ),
              _buildHelpItem(
                '5. Избранное',
                'Добавляйте формулы в избранное нажатием на иконку сердца.',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            title: 'Разделы приложения',
            icon: Icons.dashboard,
            color: Colors.orange,
            children: [
              _buildFeatureItem(
                Icons.home,
                'Главная',
                'Выбор предмета и навигация по приложению',
              ),
              _buildFeatureItem(
                Icons.list,
                'Список формул',
                'Просмотр всех формул выбранного предмета',
              ),
              _buildFeatureItem(
                Icons.calculate,
                'Калькулятор',
                'Ввод значений и расчет результата по формуле',
              ),
              _buildFeatureItem(
                Icons.favorite,
                'Избранное',
                'Быстрый доступ к сохраненным формулам',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            title: 'Предметы',
            icon: Icons.school,
            color: Colors.purple,
            children: [
              _buildSubjectItem(
                Icons.calculate,
                'Математика',
                'Геометрия, алгебра, тригонометрия',
                Colors.blue,
              ),
              _buildSubjectItem(
                Icons.science,
                'Физика',
                'Механика, электричество, термодинамика',
                Colors.green,
              ),
              _buildSubjectItem(
                Icons.biotech,
                'Химия',
                'Молярная масса, концентрации, pH',
                Colors.purple,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            title: 'Советы',
            icon: Icons.lightbulb,
            color: Colors.amber,
            children: [
              const Text(
                '• Используйте точку как разделитель дробной части',
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 8),
              const Text(
                '• Проверяйте единицы измерения перед вычислением',
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 8),
              const Text(
                '• Обращайте внимание на примеры использования формул',
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 8),
              const Text(
                '• Добавляйте часто используемые формулы в избранное',
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'Версия 1.0.0',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildHelpItem(String step, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectItem(
      IconData icon, String title, String description, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
