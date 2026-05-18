import 'package:flutter_bloc/flutter_bloc.dart';
import 'note_event.dart';
import 'note_state.dart';
import '../../../models/note_model.dart';
import '../../../services/api_service.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final ApiService _apiService = ApiService();
  List<Note> _currentNotes = [];

  NoteBloc() : super(NoteInitial()) {
    on<LoadNotes>(_onLoadNotes);
    on<AddNote>(_onAddNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
  }

  // Load Notes
  Future<void> _onLoadNotes(LoadNotes event, Emitter<NoteState> emit) async {
    emit(NoteLoading());
    try {
      _currentNotes = await _apiService.getNotes();
      emit(NoteLoaded(notes: _currentNotes));
    } catch (e) {
      emit(NoteError(message: e.toString()));
    }
  }

  // Add Note
  Future<void> _onAddNote(AddNote event, Emitter<NoteState> emit) async {
    emit(NoteLoading());
    try {
      final newNote = await _apiService.createNote(event.title, event.body);
      _currentNotes.insert(0, newNote);
      emit(NoteLoaded(notes: _currentNotes));
      emit(NoteSuccess(message: 'Note created successfully!'));
      // Reload to remove success state
      emit(NoteLoaded(notes: _currentNotes));
    } catch (e) {
      emit(NoteError(message: e.toString()));
    }
  }

  // Update Note
  Future<void> _onUpdateNote(UpdateNote event, Emitter<NoteState> emit) async {
    emit(NoteLoading());
    try {
      final updatedNote = await _apiService.updateNote(
        event.id,
        event.title,
        event.body,
      );
      final index = _currentNotes.indexWhere((note) => note.id == event.id);
      if (index != -1) {
        _currentNotes[index] = updatedNote;
      }
      emit(NoteLoaded(notes: _currentNotes));
      emit(NoteSuccess(message: 'Note updated successfully!'));
      emit(NoteLoaded(notes: _currentNotes));
    } catch (e) {
      emit(NoteError(message: e.toString()));
    }
  }

  // Delete Note
  Future<void> _onDeleteNote(DeleteNote event, Emitter<NoteState> emit) async {
    emit(NoteLoading());
    try {
      await _apiService.deleteNote(event.id);
      _currentNotes.removeWhere((note) => note.id == event.id);
      emit(NoteLoaded(notes: _currentNotes));
      emit(NoteSuccess(message: 'Note deleted successfully!'));
      emit(NoteLoaded(notes: _currentNotes));
    } catch (e) {
      emit(NoteError(message: e.toString()));
    }
  }
}