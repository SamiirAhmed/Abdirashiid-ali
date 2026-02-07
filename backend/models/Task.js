const mongoose = require('mongoose');

// Task Schema - Qaabka xogta hawsha (Task)
const taskSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    },
    title: {
        type: String,
        required: [true, 'Please enter task title'],
        trim: true,
    },
    description: {
        type: String,
        required: [true, 'Please enter task description'],
    },
    status: {
        type: String,
        enum: ['pending', 'completed'],
        default: 'pending',
    },
    priority: {
        type: String,
        enum: ['low', 'medium', 'high'],
        default: 'medium',
    },
    dueDate: {
        type: Date,
    },
    category: {
        type: String,
        required: [true, 'Please select a category'],
    },
    project: {
        type: String,
        default: 'Main Project',
    }
}, {
    timestamps: true,
});

module.exports = mongoose.model('Task', taskSchema);
