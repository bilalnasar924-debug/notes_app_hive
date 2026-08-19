import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notes_app_hive/Screens/AddNoteScreen.dart';
import 'package:notes_app_hive/model/note.dart';
import '../services/note_services.dart';
import '../utils/GradientAppBar.dart';

class homescreen extends StatefulWidget {
  const homescreen({super.key});

  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(title: 'Notes App',
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (_) => add_note_screen() ));
      },
      backgroundColor: Color(0xff5B21B6),
        child: Icon(Icons.add , color: Colors.white,),
      ),
      body:ValueListenableBuilder(valueListenable: Hive.box<note>('mynotes').listenable(), builder: (context , Box<note> box , _){
        final notes = box.values.toList();
        if(notes.isEmpty){
          return const Center(child: Text("No Notes Add yet"),);
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.separated(itemBuilder: (context , index) {
            final Note =notes[index];
            return ListTile(
              onTap: (){
                Navigator.push(context , MaterialPageRoute(builder: (context) => add_note_screen(Note: Note,)));
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              leading: const Icon(
                Icons.note,
                color: Color(0xFF5B21B6),
              ),
              title:  Text(Note.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle:  Text(Note.content,
              ),
              trailing: IconButton(onPressed: (){
                final title = Note.title;  final content = Note.content; final key = Note.key; final createdAt = Note.createdAt;
                noteservices().deleteNote(Note.key);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Undo The Delete Note"),action: SnackBarAction(label: "Undo", onPressed: (){
                  noteservices().restoreNote(key, note(title: title, content: content, createdAt: createdAt));
                }),));

              }, icon: Icon(Icons.delete,color: Colors.red,)),
            );
          }, separatorBuilder: (context , index) => const SizedBox(height: 12,), itemCount: notes.length),
        );{
        }
      }),

    );

  }
}
