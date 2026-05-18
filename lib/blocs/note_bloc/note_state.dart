import '../../../models/note_model.dart';

abstract class NoteState {}

class NoteInitial extends NoteState {}

class NoteLoading extends NoteState {}

class NoteLoaded extends NoteState {
  final List<Note> notes;
  NoteLoaded({required this.notes});
}

class NoteError extends NoteState {
  final String message;
  NoteError({required this.message});
}

class NoteSuccess extends NoteState {
  final String message;
  NoteSuccess({required this.message});
}