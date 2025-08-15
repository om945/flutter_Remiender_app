import mongoose from 'mongoose';

const notesSchema = mongoose.Schema({
  userId: {
    required: true,
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
  },
  headline: {
    required: false,
    type: String,
    trim: true,
  },
  content: {
    required: true,
    type: String,
    trim: true,
    validate: {
      validator: (value) => {
        return value && value.trim().length > 0;
      },
      message: 'Add note to save',
    },
  },
});

const Note = mongoose.model('Note', notesSchema);
export default Note;
