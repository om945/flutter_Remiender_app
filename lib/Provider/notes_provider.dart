import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:remiender_app/Provider/user_provider.dart';
import 'package:remiender_app/models/notes.dart';
import 'package:remiender_app/services/note_service.dart';

class NotesProvider extends ChangeNotifier {
  List<Notes> _notes = [];
  List<Notes> get notes => _notes;

  void setNotes(List<Notes> notes) {
    notes.sort((a, b) {
      final dateTimeA = a.uploadTime;
      final dateTimeB = b.uploadTime;

      if (dateTimeA == null && dateTimeB == null) {
        return 0;
      } else if (dateTimeA == null) {
        return 1;
      } else if (dateTimeB == null) {
        return -1;
      } else {
        return dateTimeB.compareTo(dateTimeA);
      }
    });
    _notes = notes;
    notifyListeners();
  }

  Future<void> fetchnotesForUser(BuildContext context) async {
    final noteService = NoteService();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user.id;

    if (userId.isNotEmpty) {
      final fetchNotes = await noteService.fetchnotes(context, userId);
      setNotes(fetchNotes);
    }
  }
}
