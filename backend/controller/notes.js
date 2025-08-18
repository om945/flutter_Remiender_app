import Note from '../models/notes.js';
import User from '../models/user.js';

async function handleGenerateNewNote(req, res) {
  const { headline, content } = req.body;
  try {
    const userId = req.user;
    // console.log(req.user);
    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    if (!content || content.trim().length === 0) {
      return res.status(400).json({ error: 'Content is required' });
    }

    let note = new Note({
      headline: headline || '',
      content: content.trim(),
      userId: user._id,
    });

    note = await note.save();
    res.status(201).json(note);
  } catch (e) {
    console.error('Error creating note:', e);
    res.status(500).json({ error: e.message });
  }
}

async function handleGetNotes(req, res) {
  try {
    const userId = req.user;
    const notes = await Note.find({ userId });
    res.json(notes);
  } catch (e) {
    console.error('Error in handleGetNotes:', e);
    res.status(500).json({ error: e.message });
  }
}

async function handleEditNotes(req, res) {
  const userId = req.user; // Fix: was req.User (capital U)
  const { id, headline, content } = req.body; // Add id to destructuring

  if (!userId) {
    return res.status(400).json({
      success: false,
      message: 'No user found',
    });
  }

  if (!id) {
    return res.status(400).json({
      success: false,
      message: 'Note ID is required',
    });
  }

  try {
    const notes = await Note.findOneAndUpdate(
      {
        _id: id, // Use the note ID to find specific note
        userId: userId, // Also ensure it belongs to the user
      },
      {
        headline,
        content,
      },
      {
        new: true,
        runValidators: true,
      }
    );

    if (!notes) {
      return res.status(404).json({
        success: false,
        message: 'Note not found or you do not have permission to edit it',
      });
    }

    return res.status(200).json({
      success: true,
      message: 'Note edited successfully',
      note: {
        headline: notes.headline,
        content: notes.content,
        userId: notes.userId,
        _id: notes._id,
        createdAt: notes.createdAt,
        updatedAt: notes.updatedAt,
      },
    });
  } catch (e) {
    console.error('Error editing note:', e);
    return res.status(500).json({
      success: false,
      message: 'Something went wrong while editing note',
    });
  }
}

export { handleGenerateNewNote, handleGetNotes, handleEditNotes };
