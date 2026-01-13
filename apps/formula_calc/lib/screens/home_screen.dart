import 'package:flutter/material.dart';
import '../services/formula_service.dart';
import '../widgets/subject_card.dart';
import 'formula_list_screen.dart';
import 'favorites_screen.dart';
import 'help_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FormulaService _formulaService = FormulaService();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _formulaService.loadFormulas();
    setState(() {});
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return const FavoritesScreen();
      case 2:
        return const HelpScreen();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'FormulaCalc',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Справочник формул с калькулятором',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(8),
            children: [
              SubjectCard(
                subject: 'math',
                displayName: 'Математика',
                formulaCount: _formulaService.getFormulasBySubject('math').length,
                onTap: () => _navigateToSubject('math'),
                icon: Icons.calculate,
                color: Colors.blue,
              ),
              SubjectCard(
                subject: 'physics',
                displayName: 'Физика',
                formulaCount:
                    _formulaService.getFormulasBySubject('physics').length,
                onTap: () => _navigateToSubject('physics'),
                icon: Icons.science,
                color: Colors.green,
              ),
              SubjectCard(
                subject: 'chemistry',
                displayName: 'Химия',
                formulaCount:
                    _formulaService.getFormulasBySubject('chemistry').length,
                onTap: () => _navigateToSubject('chemistry'),
                icon: Icons.biotech,
                color: Colors.purple,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _navigateToSubject(String subject) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormulaListScreen(subject: subject),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getSelectedScreen(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Избранное',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: 'Справка',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
      ),
    );
  }
}
