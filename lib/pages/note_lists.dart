import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remiender_app/models/notes.dart';
import 'package:provider/provider.dart';
import 'package:remiender_app/Provider/notes_provider.dart';
import 'package:remiender_app/pages/add_note_page.dart';
import 'package:remiender_app/services/note_service.dart';
import 'package:remiender_app/theme/note_list_ui.dart';
import 'package:remiender_app/theme/theme.dart';

class NotesList extends StatefulWidget {
  const NotesList({super.key});

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  bool _isLoading = false;
  final NoteService noteService = NoteService();

  // State for selection mode
  bool _isSelectionMode = false;
  final Set<String> _selectedNoteIds = {};

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

  void _onNoteLongPress(String noteId) {
    if (!_isSelectionMode) {
      setState(() {
        _isSelectionMode = true;
        _selectedNoteIds.add(noteId);
      });
    }
  }

  void _onNoteTap(Notes note) async {
    if (_isSelectionMode) {
      setState(() {
        if (_selectedNoteIds.contains(note.id)) {
          _selectedNoteIds.remove(note.id);
        } else {
          _selectedNoteIds.add(note.id);
        }
        // Exit selection mode if no items are selected
        if (_selectedNoteIds.isEmpty) {
          _isSelectionMode = false;
        }
      });
    } else {
      // Navigate to edit page
      final result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AddNotePage(
            noteId: note.id,
            headline: note.headline,
            content: note.content,
          ),
        ),
      );
      if (result == true && mounted) {
        _loadData();
      }
    }
  }

  void _cancelSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedNoteIds.clear();
    });
  }

  Future<void> _favoriteNotes() async {
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    bool isCurrentlyFavorite = false;

    if (_selectedNoteIds.isNotEmpty) {
      final firstSelectedNoteId = _selectedNoteIds.first;
      final firstSelectedNote = notesProvider.notes.firstWhere(
        (note) => note.id == firstSelectedNoteId,
      );
      isCurrentlyFavorite = firstSelectedNote.isFavorite ?? false;
    }

    for (String noteId in _selectedNoteIds) {
      await noteService.updateFavoriteNote(
        context: context,
        noteId: noteId,
        isFavorite: !isCurrentlyFavorite,
      );
    }
    // Optionally refresh data and exit selection mode
    _cancelSelectionMode();
    await _loadData();
  }

  Future<void> _deleteSelectedNotes() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Notes',
            style: TextStyle(color: whiteColor, fontFamily: googleFontNormal),
          ),
          content: Text(
            'Are you sure you want to delete ${_selectedNoteIds.length} selected note(s)?',
            style: TextStyle(color: whiteColor, fontFamily: googleFontNormal),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: blueColor,
                  fontFamily: googleFontNormal,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Delete',
                style: TextStyle(
                  color: blueColor,
                  fontFamily: googleFontNormal,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true && mounted) {
      final idsToDelete = Set<String>.from(_selectedNoteIds);
      for (String noteId in idsToDelete) {
        await noteService.deleteNote(context: context, noteId: noteId);
      }
      // Refresh list and exit selection mode
      _cancelSelectionMode();
      await _loadData();
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

        if (_isLoading && !_isSelectionMode) {
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
                  noteId: note.id,
                  isSelectionMode: _isSelectionMode,
                  isSelected: _selectedNoteIds.contains(note.id),
                  onTap: () => _onNoteTap(note),
                  onLongPress: () => _onNoteLongPress(note.id),
                );
              } catch (e) {
                return const SizedBox.shrink(); // Return empty widget on error
              }
            })
            .where((widget) => widget is! SizedBox)
            .toList();

        return Scaffold(
          floatingActionButton: _isSelectionMode
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      heroTag: 'favorite_button',
                      onPressed: _selectedNoteIds.isNotEmpty
                          ? _favoriteNotes
                          : null,
                      backgroundColor: blueColor,
                      child:
                          (_selectedNoteIds.isNotEmpty &&
                              notes
                                      .firstWhere(
                                        (n) => n.id == _selectedNoteIds.first,
                                      )
                                      .isFavorite ==
                                  true)
                          ? const Icon(Icons.star)
                          : const Icon(Icons.star_border),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FloatingActionButton(
                          heroTag: 'cancel_button',
                          onPressed: _cancelSelectionMode,
                          backgroundColor: blueColor,
                          child: const Icon(Icons.close, color: blackColor),
                        ),
                        SizedBox(width: 10.w),
                        FloatingActionButton(
                          heroTag: 'delete_button',
                          onPressed: _selectedNoteIds.isNotEmpty
                              ? _deleteSelectedNotes
                              : null,
                          backgroundColor: _selectedNoteIds.isNotEmpty
                              ? Colors.red
                              : Colors.grey,
                          child: const Icon(Icons.delete, color: whiteColor),
                        ),
                      ],
                    ),
                  ],
                )
              : FloatingActionButton(
                  backgroundColor: blueColor,
                  onPressed: () async {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AddNotePage(),
                      ),
                    );
                    if (result == true && mounted) _loadData();
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
