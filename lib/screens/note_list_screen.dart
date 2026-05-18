import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/note_bloc/note_bloc.dart';
import '../blocs/note_bloc/note_state.dart';
import '../blocs/note_bloc/note_event.dart';
import 'add_edit_note_screen.dart';

class NoteListScreen extends StatelessWidget {
  const NoteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes (BLoC + Dio)'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<NoteBloc>().add(LoadNotes());
            },
          ),
        ],
      ),
      body: BlocConsumer<NoteBloc, NoteState>(
        listener: (context, state) {
          if (state is NoteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
          if (state is NoteError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is NoteLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading notes...'),
                ],
              ),
            );
          }

          if (state is NoteError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<NoteBloc>().add(LoadNotes());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is NoteLoaded && state.notes.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_add, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No notes yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text('Tap + to create your first note'),
                ],
              ),
            );
          }

          if (state is NoteLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: state.notes.length,
              itemBuilder: (context, index) {
                final note = state.notes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    title: Text(
                      note.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      note.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddEditNoteScreen(
                                  note: note,
                                  isEditing: true,
                                ),
                              ),
                            );
                            if (result == true) {
                              context.read<NoteBloc>().add(LoadNotes());
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Delete Note'),
                                content: const Text('Are you sure you want to delete this note?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                            
                            if (confirm == true) {
                              context.read<NoteBloc>().add(DeleteNote(id: note.id));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditNoteScreen(isEditing: false),
            ),
          );
          if (result == true) {
            context.read<NoteBloc>().add(LoadNotes());
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}