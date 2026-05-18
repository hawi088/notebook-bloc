import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/note_bloc/note_bloc.dart';
import '../blocs/note_bloc/note_event.dart';
import '../models/note_model.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? note;
  final bool isEditing;

  const AddEditNoteScreen({
    super.key,
    this.note,
    required this.isEditing,
  });

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _bodyController = TextEditingController(text: widget.note?.body ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _saveNote() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    if (widget.isEditing) {
      context.read<NoteBloc>().add(
        UpdateNote(
          id: widget.note!.id,
          title: _titleController.text.trim(),
          body: _bodyController.text.trim(),
        ),
      );
    } else {
      context.read<NoteBloc>().add(
        AddNote(
          title: _titleController.text.trim(),
          body: _bodyController.text.trim(),
        ),
      );
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pop(context, true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Note' : 'Add Note'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  if (value.length < 3) {
                    return 'Title must be at least 3 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextFormField(
                  controller: _bodyController,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.notes),
                  ),
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter content';
                    }
                    if (value.length < 5) {
                      return 'Content must be at least 5 characters';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveNote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(widget.isEditing ? 'UPDATE NOTE' : 'SAVE NOTE'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}