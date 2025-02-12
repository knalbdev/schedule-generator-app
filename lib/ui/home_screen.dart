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
    return Scaffold(
      appBar: AppBar(title: Text("Schedule Generator")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: taskController,
              decoration: InputDecoration(labelText: "Nama Tugas"),
            ),
            TextField(
              controller: durationController,
              decoration: InputDecoration(labelText: "Durasi (menit)"),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: priority,
              hint: Text("Pilih Prioritas"),
              onChanged: (value) => setState(() => priority = value),
              items: [
                "Tinggi",
                "Sedang",
                "Rendah"
              ].map((priorityMember) => DropdownMenuItem(
                value: priorityMember,
                child: Text(priorityMember)
              )).toList()
            ),
            ElevatedButton(
              onPressed: _addTask,
              child: Text("Tambahkan Tugas"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return ListTile(
                    title: Text("${task['name']}"),
                    subtitle: Text("Prioritas: ${task['priority']} | Durasi: ${task['duration']} menit"),
                  );
                },
              ),
            ),
            isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
              onPressed: _generateSchedule,
              child: Text("Generate Schedule"),
            ),
            SizedBox(height: 20),
            scheduleResult.isNotEmpty
            ? Text(
              scheduleResult,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            )
            : Container()
          ],
        ),
      )
    );
  }
}