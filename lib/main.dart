import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/note_bloc/note_bloc.dart';
import 'screens/note_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NoteBloc(),
      child: MaterialApp(
        title: 'Note App - BLoC + Dio',
        theme: ThemeData(
          primarySwatch: Colors.green,  // Different color from Provider version
          useMaterial3: true,
        ),
        home: const NoteListScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}