import 'package:flutter/material.dart';
import 'package:schedule_generator/services/openai_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> tasks = [];
  final TextEditingController taskController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  String? priority;
  String scheduleResult = "";
  bool isLoading = false;

  void _addTask() {
    if (taskController.text.isNotEmpty && durationController.text.isNotEmpty && priority != null) {
      setState(() {
        tasks.add({
          "name": taskController.text,
          "priority": priority!,
          "duration": int.tryParse(durationController.text) ?? 30,
          "deadline": "Tidak Ada"
        });
      });
      taskController.clear();
      durationController.clear();
    }
  }

  Future<void> _generateSchedule() async {
    setState(() => isLoading = true);
    try {
      String schedule = await OpenAIService.generateSchedule(tasks);
      setState(() => scheduleResult = schedule);
    } catch (e) {
      setState(() => scheduleResult = "Gagal menghasilkan jadwal.");
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}