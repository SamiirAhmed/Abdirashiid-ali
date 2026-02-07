const express = require('express');
const {
    getTasks,
    createTask,
    getTaskById,
    updateTask,
    deleteTask,
} = require('../controllers/taskController');
const { protect, admin } = require('../middleware/authMiddleware');

const router = express.Router();

router.route('/')
    .get(protect, getTasks)
    .post(protect, admin, createTask);

router.route('/:id')
    .get(protect, getTaskById)
    .put(protect, admin, updateTask)
    .delete(protect, admin, deleteTask);

module.exports = router;
