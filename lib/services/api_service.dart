import 'package:dio/dio.dart';
import '../models/note_model.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    // Your MockAPI URL
    baseUrl: 'https://6a0aa7d721e4456256963e9b.mockapi.io',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {'Content-Type': 'application/json'},
  ));

  // READ - Get all notes
  Future<List<Note>> getNotes() async {
    try {
      final response = await _dio.get('/notes');
      
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Note.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load notes: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  // CREATE - Add new note
  Future<Note> createNote(String title, String body) async {
    try {
      final response = await _dio.post(
        '/notes',
        data: {
          'title': title,
          'body': body,
          'createdAt': DateTime.now().toIso8601String(),
        },
      );
      
      if (response.statusCode == 201) {
        return Note.fromJson(response.data);
      } else {
        throw Exception('Failed to create note: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  // UPDATE - Edit note
  Future<Note> updateNote(String id, String title, String body) async {
    try {
      final response = await _dio.put(
        '/notes/$id',
        data: {
          'title': title,
          'body': body,
          'createdAt': DateTime.now().toIso8601String(),
        },
      );
      
      if (response.statusCode == 200) {
        return Note.fromJson(response.data);
      } else {
        throw Exception('Failed to update note: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  // DELETE - Remove note
  Future<void> deleteNote(String id) async {
    try {
      final response = await _dio.delete('/notes/$id');
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      } else {
        throw Exception('Failed to delete note: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}