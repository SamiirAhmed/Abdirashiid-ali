const mongoose = require('mongoose');

// Category/Project Schema
const categorySchema = new mongoose.Schema({
    name: {
        type: String,
        required: [true, 'Please enter category name'],
        trim: true,
    },
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    },
    type: {
        type: String,
        enum: ['category', 'project'],
        default: 'category',
    }
}, {
    timestamps: true,
});

module.exports = mongoose.model('Category', categorySchema);
