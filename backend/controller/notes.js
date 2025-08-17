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
    // notes will be an array, even if empty, so we don't need to check if it's falsy
    // console.log('Notes found:', notes);
    res.json(notes);
  } catch (e) {
    console.error('Error in handleGetNotes:', e);
    res.status(500).json({ error: e.message });
  }
}

export { handleGenerateNewNote, handleGetNotes };
