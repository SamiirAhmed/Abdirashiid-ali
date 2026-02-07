const Category = require('../models/Category');

// @desc    Get all categories for a user
// @route   GET /api/categories
// @access  Private
const getCategories = async (req, res) => {
    const categories = await Category.find({ userId: req.user._id });
    res.json(categories);
};

// @desc    Create a category
// @route   POST /api/categories
// @access  Private
const createCategory = async (req, res) => {
    const { name, type } = req.body;

    const category = new Category({
        name,
        userId: req.user._id,
        type: type || 'category',
    });

    const createdCategory = await category.save();
    res.status(201).json(createdCategory);
};

module.exports = { getCategories, createCategory };
