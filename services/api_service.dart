import 'package:dio/dio.dart';
import '../models/note_model.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {'Content-Type': 'application/json'},
  ));

  // READ - Get all notes
  Future<List<Note>> getNotes() async {
    try {
      final response = await _dio.get('/posts');
      
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<Note> notes = data.map((json) => Note.fromJson(json)).toList();
        return notes.take(10).toList();
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
        '/posts',
        data: {
          'title': title,
          'body': body,
          'userId': 1,
        },
      );
      
      if (response.statusCode == 201) {
        return Note(
          id: response.data['id'],
          title: response.data['title'],
          body: response.data['body'],
          createdAt: DateTime.now(),
        );
      } else {
        throw Exception('Failed to create note: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  // UPDATE - Edit note
  Future<Note> updateNote(int id, String title, String body) async {
    try {
      final response = await _dio.put(
        '/posts/$id',
        data: {
          'id': id,
          'title': title,
          'body': body,
          'userId': 1,
        },
      );
      
      if (response.statusCode == 200) {
        return Note(
          id: response.data['id'],
          title: response.data['title'],
          body: response.data['body'],
          createdAt: DateTime.now(),
        );
      } else {
        throw Exception('Failed to update note: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  // DELETE - Remove note
  Future<void> deleteNote(int id) async {
    try {
      final response = await _dio.delete('/posts/$id');
      
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete note: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}