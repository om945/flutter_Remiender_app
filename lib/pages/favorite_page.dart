import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:remiender_app/Provider/notes_provider.dart';
import 'package:remiender_app/models/notes.dart';
import 'package:remiender_app/pages/add_note_page.dart';
import 'package:remiender_app/services/note_service.dart';
import 'package:remiender_app/theme/note_list_ui.dart';
import 'package:remiender_app/theme/theme.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final NotesProvider notesProvider = NotesProvider();
  final NoteService noteService = NoteService();
  bool _isLoading = false;
  bool _isSelectionMode = false;
  final Set<String> _selectedNoteIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    await Provider.of<NotesProvider>(
      context,
      listen: false,
    ).fetchnotesForUser(context);

    setState(() {
      _isLoading = false;
    });
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

        if (_selectedNoteIds.isEmpty) {
          _isSelectionMode = false;
        }
      });
    } else {
      final result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => AddNotePage(
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

  void _canceleSelectionNode() {
    setState(() {
      _isSelectionMode = false;
      _selectedNoteIds.clear();
    });
  }

  Future<void> _removeFavoriteNotes() async {
    for (String noteId in _selectedNoteIds) {
      await noteService.updateFavoriteNote(
        context: context,
        noteId: noteId,
        isFavorite: false,
      );
    }
    _canceleSelectionNode();
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
            'Are you sure you want to delete ${_selectedNoteIds.length} selected note(s)',
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

      _canceleSelectionNode();
      await _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotesProvider>(
      builder: (BuildContext context, NotesProvider noteProvider, Widget? child) {
        final favoriteNotes = noteProvider.notes
            .where((note) => note.isFavorite == true)
            .toList();

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
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 80.h,
              title: Text(
                'Favorite',
                style: TextStyle(
                  fontFamily: googleFontNormal,
                  color: whiteColor,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(child: CircularProgressIndicator(color: blueColor)),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 80.h,
            title: Text(
              'Favorite',
              style: TextStyle(fontFamily: googleFontNormal, color: whiteColor),
            ),
          ),
          floatingActionButton: _isSelectionMode
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        heroTag: 'favorite_button',
                        onPressed: _removeFavoriteNotes,
                        backgroundColor: blueColor,
                        child: const Icon(Icons.star, color: blackColor),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FloatingActionButton(
                            heroTag: 'cancel_button',
                            onPressed: _canceleSelectionNode,
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
                  ),
                )
              : SizedBox.shrink(),
          body: favoriteNotes.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: RefreshIndicator(
                    onRefresh: _loadData,
                    child: ListView(
                      children: [
                        Center(
                          child: Text(
                            'No Favorite notes yet',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontFamily: googleFontNormal,
                              color: whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                    itemCount: favoriteNotes.length,
                    itemBuilder: (context, index) {
                      final note = favoriteNotes[index];
                      return NotesListUi(
                        headline: note.headline,
                        content: note.content,
                        date: formatTime(note.uploadTime),
                        noteId: note.id,
                        isSelectionMode: _isSelectionMode,
                        isSelected: _selectedNoteIds.contains(note.id),
                        onTap: () => _onNoteTap(note),
                        onLongPress: () => _onNoteLongPress(note.id),
                        isFavorite: false,
                      );
                    },
                  ),
                ),
        );
      },
    );
  }
}
