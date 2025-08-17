import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remiender_app/services/note_service.dart';
import 'package:remiender_app/theme/theme.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final TextEditingController headlineController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final NoteService noteService = NoteService();

  void addNote() async {
    await noteService.addNote(
      context: context,
      headline: headlineController.text.trim(),
      content: contentController.text.trim(),
    );

    // Refresh the notes list
    if (mounted) {
      // final notesProvider = Provider.of<NotesProvider>(context, listen: false);
      // await notesProvider.fetchnotesForUser(context);

      // Navigate back to the notes list
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.share)),
          IconButton(onPressed: addNote, icon: Icon(Icons.save_alt_rounded)),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: screenWidth,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                TextFormField(
                  controller: headlineController,
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontFamily: googleFontSemiBold,
                    color: whiteColor,
                  ),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                      fontSize: 30.sp,
                      fontFamily: googleFontSemiBold,
                      color: faintwhiteColor,
                    ),
                    hintText: 'Headline',
                    border: InputBorder.none,
                  ),
                ),
                TextFormField(
                  controller: contentController,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  scrollPhysics: BouncingScrollPhysics(),
                  selectionHeightStyle: BoxHeightStyle.max,
                  autofocus: true,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: googleFontNormal,
                    color: whiteColor,
                  ),
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
