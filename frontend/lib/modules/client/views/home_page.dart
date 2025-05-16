import 'package:flutter/material.dart';
import 'package:frontend/modules/client/views/patient_list_page.dart';
import 'package:frontend/modules/client/views/exercise_list_page.dart';
import 'package:frontend/modules/client/views/schedule_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final List<Widget> pages = [
    PatientListPage(),
    ExerciseListPage(),
    const ScheduleListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Pacientes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Exercícios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Prescrições',
          ),
        ],
      ),
    );
  }
}
