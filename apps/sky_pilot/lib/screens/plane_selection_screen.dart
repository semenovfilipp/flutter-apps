import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/plane_type.dart';
import '../widgets/plane_widget.dart';

class PlaneSelectionScreen extends StatefulWidget {
  const PlaneSelectionScreen({super.key});

  @override
  State<PlaneSelectionScreen> createState() => _PlaneSelectionScreenState();
}

class _PlaneSelectionScreenState extends State<PlaneSelectionScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadSelection();
  }

  Future<void> _loadSelection() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedIndex = prefs.getInt('selected_plane') ?? 0;
    });
  }

  Future<void> _saveSelection(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selected_plane', index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Plane'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade300,
              Colors.blue.shade600,
            ],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: PlaneModel.availablePlanes.length,
          itemBuilder: (context, index) {
            final plane = PlaneModel.availablePlanes[index];
            final isSelected = index == _selectedIndex;

            return Card(
              margin: const EdgeInsets.only(bottom: 20),
              elevation: isSelected ? 10 : 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color: isSelected ? Colors.amber : Colors.transparent,
                  width: 3,
                ),
              ),
              child: InkWell(
                onTap: () => _saveSelection(index),
                borderRadius: BorderRadius.circular(15),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: plane.color.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: PlaneWidget(plane: plane),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  plane.name,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: plane.color,
                                  ),
                                ),
                                if (isSelected) ...[
                                  const SizedBox(width: 10),
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.amber,
                                    size: 28,
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              plane.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                _StatChip(
                                  icon: Icons.speed,
                                  label: 'Speed',
                                  value: plane.speed.toInt().toString(),
                                ),
                                const SizedBox(width: 10),
                                _StatChip(
                                  icon: Icons.photo_size_select_small,
                                  label: 'Size',
                                  value: plane.size.toInt().toString(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.blue.shade700),
          const SizedBox(width: 4),
          Text(
            '$label: $value',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
