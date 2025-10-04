import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remiender_app/services/note_service.dart';
import 'package:remiender_app/theme/theme.dart';

class AddNotePage extends StatefulWidget {
  final String? headline;
  final String? content;
  final String? noteId; // Add note ID parameter
  const AddNotePage({super.key, this.headline, this.content, this.noteId});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final TextEditingController headlineController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final NoteService noteService = NoteService();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data if editing
    if (widget.headline != null && widget.headline!.isNotEmpty) {
      headlineController.text = widget.headline!;
    }
    if (widget.content != null && widget.content!.isNotEmpty) {
      contentController.text = widget.content!;
    }
  }

  void addNote() async {
    await noteService.addNote(
      context: context,
      noteId: widget.noteId,
      headline: headlineController.text.trim(),
      content: contentController.text.trim(),
      isUpdate:
          widget.noteId != null &&
          widget.noteId!.isNotEmpty, // Check if editing
    );

    // Refresh the notes list
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isEditing = widget.noteId != null && widget.noteId!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Note' : 'Add Note',
          style: TextStyle(fontFamily: googleFontNormal, color: whiteColor),
        ), // Show appropriate title
        actions: [
          IconButton(
            onPressed: addNote,
            icon: Icon(
              isEditing ? Icons.save_as_outlined : Icons.save_outlined,
            ),
            tooltip: isEditing ? 'Update Note' : 'Save Note',
          ),
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
