import Note from '../models/notes.js';
import User from '../models/user.js';
import crypto from 'crypto';
import dotenv from 'dotenv';
dotenv.config();

// method to generate NOTES_IV and NOTES_KEY

//  console.log("Key:", crypto.randomBytes(32).toString('hex')); // 32 bytes hex for aes-256-cbc
//  console.log("IV: ", crypto.randomBytes(16).toString('hex')); // 16 bytes hex for aes-256-cbc

const algorithm = 'aes-256-cbc';
const key = Buffer.from(process.env.NOTES_KEY, 'hex');
const iv = Buffer.from(process.env.NOTES_IV, 'hex');

function encrypt(text) {
  const cipher = crypto.createCipheriv(algorithm, key, iv);
  const encrypted = Buffer.concat([
    cipher.update(text, 'utf8'),
    cipher.final(),
  ]);
  return encrypted.toString('hex');
}

function decrypt(encrypted) {
  const decipher = crypto.createDecipheriv(algorithm, key, iv);
  const decrypted = Buffer.concat([
    decipher.update(Buffer.from(encrypted, 'hex')),
    decipher.final(),
  ]);
  return decrypted.toString('utf8');
}

async function handleGenerateNewNote(req, res) {
  const { headline, content, isFavorite } = req.body;
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
    const encryptedHeadline = encrypt(headline || '');
    const encryptedContent = encrypt(content);

    let note = new Note({
      headline: encryptedHeadline,
      content: encryptedContent,
      userId: user._id,
      isFavorite: isFavorite,
    });

    note = await note.save();
    res.status(201).json(note);
  } catch (e) {
    // console.error('Error creating note:', e);
    res.status(500).json({ error: e.message });
  }
}

async function handleGetNotes(req, res) {
  try {
    const userId = req.user;
    const notes = await Note.find({ userId });
    const readableNotes = notes.map((note) => ({
      ...note.toObject(),
      headline: decrypt(note.headline),
      content: decrypt(note.content),
    }));
    res.json(readableNotes);
  } catch (e) {
    console.error('Error in handleGetNotes:', e);
    res.status(500).json({ error: e.message });
  }
}

async function handleEditNotes(req, res) {
  const userId = req.user;
  const { id, headline, content } = req.body;

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
        headline: encrypt(headline || ''),
        content: encrypt(content),
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
        headline: decrypt(notes.headline),
        content: decrypt(notes.content),
        userId: notes.userId,
        _id: notes._id,
        createdAt: notes.createdAt,
        updatedAt: notes.updatedAt,
        isFavorite: notes.isFavorite,
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

async function handleDeleteNote(req, res) {
  const userId = req.user;
  const { id } = req.body;
  if (!userId) {
    return res.status(400).json({
      success: false,
      message: 'User not found',
    });
  }
  if (!id) {
    return res.status(400).json({
      success: false,
      message: 'Note ID is not found',
    });
  }

  try {
    const deletnote = await Note.findOneAndDelete({
      _id: id,
      userId: userId,
    });
    if (!deletnote) {
      return res.status(404).json({
        success: false,
        message: 'Failed to delete note',
      });
    }
    return res.status(200).json({
      success: true,
      message: 'Note is deleted',
    });
  } catch (e) {
    return res.status(500).json({
      success: false,
      message: 'Something went wrong while deleting note',
    });
  }
}

async function handleUpdateFavorite(req, res) {
  const userId = req.user;
  const { id } = req.params;
  const { isFavorite } = req.body;

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
    const note = await Note.findOneAndUpdate(
      {
        _id: id,
        userId: userId,
      },
      {
        isFavorite,
      },
      {
        new: true,
      }
    );

    if (!note) {
      return res.status(404).json({
        success: false,
        message: 'Note not found or you do not have permission to edit it',
      });
    }

    return res.status(200).json({
      success: true,
      message: 'Note favorite status updated successfully',
      note: {
        headline: decrypt(note.headline),
        content: decrypt(note.content),
        userId: note.userId,
        _id: note._id,
        createdAt: note.createdAt,
        updatedAt: note.updatedAt,
        isFavorite: note.isFavorite,
      },
    });
  } catch (e) {
    return res.status(500).json({
      success: false,
      message: 'Something went wrong while updating favorite note',
      error: e.message,
    });
  }
}

export {
  handleGenerateNewNote,
  handleGetNotes,
  handleEditNotes,
  handleDeleteNote,
  handleUpdateFavorite,
};
