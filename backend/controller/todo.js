import Todo from '../models/todo.js';
import User from '../models/user.js';

async function handleGenerateNewTodos(req, res) {
  const { content } = req.body;
  try {
    const userId = req.user;
    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    if (!content || content.trim().length === 0) {
      return res.status(400).json({ error: 'Content is required' });
    }
    let todo = new Todo({
      content: content.trim(),
      userId: user._id,
    });
    todo = await todo.save();
    res.status(201).json(todo);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
}

async function handleGetTodos(req, res) {
  try {
    const userId = req.user;
    const todo = await Todo.find({ userId });
    res.json(todo);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
}

async function handleEditTodos(req, res) {
  const userId = req.user;
  const { id, content } = req.body;

  if (!userId) {
    return res.status(400).json({
      success: false,
      message: 'No user found',
    });
  }

  if (!id) {
    return res.status(400).json({
      success: false,
      message: 'Todo ID is required',
    });
  }

  try {
    const todo = await Todo.findOneAndUpdate(
      {
        _id: id,
        userId: userId,
      },
      {
        content,
      },
      {
        new: true,
        runValidators: true,
      }
    );
    if (!todo) {
      return res.status(404).json({
        success: false,
        message: 'Todo not found or you do not have permition to edit it',
      });
    }
    return res.status(200).json({
      success: true,
      message: 'Todo edited successfully',
      todo: {
        content: todo.content,
        userId: todo.userId,
        _id: todo._id,
        createdAt: todo.createdAt,
        updatedAt: todo.updatedAt,
      },
    });
  } catch (e) {
    return res.status(500).json({
      success: false,
      message: 'Something went wrong while editing Todo',
    });
  }
}

async function handleDeletetodos(req, res) {
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
      message: 'Todo ID is not found',
    });
  }
  try {
    const deletetodo = await Todo.findOneAndDelete({
      _id: id,
      userId: userId,
    });
    if (!deletetodo) {
      return res.status(404).json({
        success: false,
        message: 'faild to delete note',
      });
    }
    return res.status(200).json({
      success: true,
      message: 'Todo is deleted',
    });
  } catch (e) {
    return res.status(500).json({
      success: false,
      message: 'Something went wrong while deleting note',
    });
  }
}

export {
  handleEditTodos,
  handleGenerateNewTodos,
  handleGetTodos,
  handleDeletetodos,
};
