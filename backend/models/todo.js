import mongoose from 'mongoose';

const todoSchema = mongoose.Schema(
  {
    userId: {
      required: true,
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
    },
    content: {
      required: true,
      type: String,
      trim: true,
      validate: {
        validator: (value) => {
          return value && value.trim().length > 0;
        },
        message: 'Add todo to save',
      },
    },
    reminderDate: {
      type: Date,
      required: false,
    },
    isCompleted: {
      type: Boolean,
      default: false,
    },
    dateTimeToComplete: {
      required: false,
      type: String,
    },
  },
  { timestamps: true }
);

const Todo = mongoose.model('Todo', todoSchema);
export default Todo;
