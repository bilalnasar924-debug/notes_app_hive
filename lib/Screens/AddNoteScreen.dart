import 'package:flutter/material.dart';
import 'package:notes_app_hive/model/note.dart';
import 'package:notes_app_hive/services/note_services.dart';
import 'package:notes_app_hive/utils/GradientAppBar.dart';

class add_note_screen extends StatefulWidget {
  final note? Note;
  const add_note_screen({super.key , this.Note});

  @override
  State<add_note_screen> createState() => _add_note_screenState();
}

class _add_note_screenState extends State<add_note_screen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  bool get isUpdate => widget.Note != null;
  @override
  void initState(){
    super.initState();
    if(widget.Note != null){
      titleController.text = widget.Note!.title;
      contentController.text = widget.Note!.content;
    }

  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void saveNote() async{
    if (titleController.text
        .trim()
        .isEmpty ||
        contentController.text
            .trim()
            .isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter both title and content"),
        ),
      );
      return;

    }
    if(isUpdate){
      await noteservices().updateNote(widget.Note!, titleController.text, contentController.text);
    }else{
      await noteservices().addNotes(titleController.text, contentController.text);
    }

    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(title: isUpdate ? "Update Note" : "Save Note"),
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                  labelText: "Title",
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24),),
                  hint: Text("Enter Note Title"),
                  prefixIcon: Icon(Icons.note),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24))
              ),
            ),
          ),
          const SizedBox(height: 15,),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                controller: contentController,
                maxLines: 15,
                decoration: InputDecoration(
                    labelText: "Content",
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24),),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24))
                ),
              ),
            ),
          ),
          const SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 45),
            child: ElevatedButton(onPressed: (){
              saveNote();
            }
            , child: Text(isUpdate ? "Update Note" : "Save Note")),
          )
        ],
      ),),
    );
  }
}
