import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://acces-ia-backend.onrender.com/api/v1';

  static Future<String> analyzeImage(File imageFile, {String? prompt}) async {
    try {
      var uri = Uri.parse('$baseUrl/visual/analyze');
      var request = http.MultipartRequest('POST', uri);

      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      if (prompt != null && prompt.isNotEmpty) {
        request.fields['prompt'] = prompt;
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        return jsonResponse['description'] ?? 'No se recibió descripción.';
      } else {
        return 'Error del servidor: código ${response.statusCode}';
      }
    } catch (e) {
      return 'Error de conexión. Verifica tu internet.';
    }
  }

  static Future<dynamic> processAuditoryText(String rawText) async {
    try {
      var uri = Uri.parse('$baseUrl/auditory/process');

      var response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'raw_text': rawText}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error del servidor: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error de conexión: $e');
      return null;
    }
  }
}
