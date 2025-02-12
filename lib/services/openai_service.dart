import 'dart:convert';

import 'package:http/http.dart' as http;

class OpenAIService {
  static const String apiKey = "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";
  static const String baseUrl = "https://api.openai.com/v1/chat/completions";

  static Future<String> generateSchedule(List<Map<String, dynamic>> tasks) async {
    final prompt = _buildPrompt(tasks);


    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey"
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {
            "role": "system",
            "content": "You are a student and you need to schedule the following tasks. Please provide a schedule for the tasks.",
          },
          {
            "role": "user",
            "content": prompt,
          }
        ],
        "max_tokens": 500
      })
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["choices"][0]["message"]["content"];
    } else {
      throw Exception("Gagal menghasilkan jadwal");
    }
  }

  static String _buildPrompt(List<Map<String, dynamic>> tasks) {
    String taskList = tasks.map((task) => 
      "- ${task['name']} (Prioritas: ${task['priority']}, Durasi: ${task['duration']} menit, Deadline: ${task['deadline']})"
    ).join("\n");

    return "Buatkan jadwal harian yang optimal untuk tugas-tugas berikut: \n$taskList\nSusun jadwal dari pagi hingga malam dengan efisien";
  }
}