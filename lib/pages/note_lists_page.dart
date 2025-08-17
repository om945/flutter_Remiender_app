import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:remiender_app/Provider/notes_provider.dart';
import 'package:remiender_app/pages/add_note_page.dart';
import 'package:remiender_app/services/note_service.dart';
import 'package:remiender_app/theme/note_list_ui.dart';
import 'package:remiender_app/theme/theme.dart';

class NotesListPage extends StatefulWidget {
  const NotesListPage({super.key});

  @override
  State<NotesListPage> createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> {
  bool _isLoading = false;
  final NoteService notes = NoteService();

  @override
  void initState() {
    super.initState();
    // Load data after the first frame is built to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final notesProvider = Provider.of<NotesProvider>(context, listen: false);
      await notesProvider.fetchnotesForUser(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading notes: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotesProvider>(
      builder: (context, notesProvider, child) {
        final notes = notesProvider.notes;

        String formatTime(DateTime? dateTime) {
          if (dateTime == null) return 'No date';
          try {
            // Format as 'yyyy-MM-dd'
            return "${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
          } catch (e) {
            return 'Invalid date';
          }
        }

        if (_isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: blueColor)),
          );
        }

        final noteWidgets = notes
            .map((note) {
              try {
                return NotesListUi(
                  content: note.content,
                  headline: note.headline,
                  date: formatTime(note.uploadTime),
                );
              } catch (e) {
                return const SizedBox.shrink(); // Return empty widget on error
              }
            })
            .where((widget) => widget is! SizedBox)
            .toList();

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: blueColor,
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddNotePage()),
              );
              // If AddNotePage pops with `true`, it means a note was added.
              if (result == true && mounted) {
                _loadData();
              }
            },
            child: Icon(Icons.add, color: blackColor, size: 30.sp),
          ),
          body: notes.isEmpty
              ? RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView(
                    children: [
                      Center(
                        child: Text(
                          'No notes yet',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontFamily: googleFontNormal,
                            color: whiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView(children: noteWidgets),
                ),
        );
      },
    );
  }
}
