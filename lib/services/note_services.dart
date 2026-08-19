import 'package:hive_flutter/adapters.dart';
import 'package:notes_app_hive/model/note.dart';

class noteservices{
  final Box<note> box  = Hive.box<note>('mynotes');

  Future<void> addNotes(String title , String content , {DateTime? createdAt}) async{
    final Note = note(title: title, content: content, createdAt: createdAt ?? DateTime.now());
    box.add(Note);
  }

  Future<void> restoreNote(dynamic key , note restoreNote) async{
    await box.put(key, restoreNote);

  }

  Future<void> updateNote(note Note, String newTitle , String newContent,) async{
    Note.title  = newTitle;
    Note.content = newContent;
    await Note.save();
  }

  void deleteNote(dynamic key){
    box.delete(key);
  }


}