import '../../../models/note_model.dart';

abstract class NoteEvent {}

class LoadNotes extends NoteEvent {}

class AddNote extends NoteEvent {
  final String title;
  final String body;
  AddNote({required this.title, required this.body});
}

class UpdateNote extends NoteEvent {
  final String id;  // Change from int to String
  final String title;
  final String body;
  UpdateNote({
    required this.id,
    required this.title,
    required this.body,
  });
}

class DeleteNote extends NoteEvent {
  final String id;  // Change from int to String
  DeleteNote({required this.id});
}