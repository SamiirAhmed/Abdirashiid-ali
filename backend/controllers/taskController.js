const Task = require('../models/Task');

// @desc    Get all tasks for a user
// @route   GET /api/tasks
// @access  Private
const getTasks = async (req, res) => {
    console.log(`Fetching tasks for user: ${req.user.email} (Role: ${req.user.role})`);
    try {
        let query = {};

        // Hadii uusan aheyn admin, tus kaliya hawshiisa
        if (req.user.role !== 'admin') {
            query = { userId: req.user._id };
        }

        const tasks = await Task.find(query)
            .populate('userId', 'name email')
            .sort({ createdAt: -1 });

        console.log(`[TASKS_API] Found ${tasks.length} tasks in database`);
        res.json(tasks);
    } catch (error) {
        console.error('Error fetching tasks:', error);
        res.status(500).json({ message: 'Error fetching tasks' });
    }
};

// @desc    Create a task
// @route   POST /api/tasks
// @access  Private
const createTask = async (req, res) => {
    const { title, description, priority, dueDate, category, project, userId } = req.body;

    // Default userId is the logged in user
    let assignedUserId = req.user._id;

    // If admin provides a userId, use that instead
    if (req.user.role === 'admin' && userId) {
        assignedUserId = userId;
    }

    const task = new Task({
        userId: assignedUserId,
        title,
        description,
        priority,
        dueDate,
        category,
        project,
    });

    try {
        const createdTask = await task.save();
        res.status(201).json(createdTask);
    } catch (error) {
        console.error('Task Creation Error:', error);
        res.status(400).json({ message: 'Xog qaldan ayaad soo dirtay: ' + error.message });
    }
};

// @desc    Get task by ID
// @route   GET /api/tasks/:id
// @access  Private
const getTaskById = async (req, res) => {
    try {
        const task = await Task.findById(req.params.id);

        if (task) {
            // Xaqiiji inuu isticmaalaha leeyahay hawshaan ama yahay admin
            if (task.userId.toString() !== req.user._id.toString() && req.user.role !== 'admin') {
                res.status(401).json({ message: 'Ma kuu ogola ' });
                return;
            }
            res.json(task);
        } else {
            res.status(404).json({ message: 'Hawsha lama helin' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Cillad ayaa dhacday' });
    }
};

// @desc    Update task
// @route   PUT /api/tasks/:id
// @access  Private
const updateTask = async (req, res) => {
    const { title, description, status, priority, dueDate, category, project } = req.body;

    try {
        const task = await Task.findById(req.params.id);

        if (task) {
            // Xaqiiji inuu isticmaalaha leeyahay hawshaan ama yahay admin
            if (task.userId.toString() !== req.user._id.toString() && req.user.role !== 'admin') {
                res.status(401).json({ message: 'Ma kuu ogola inaad wax ka badasho hawshaan' });
                return;
            }

            task.title = title || task.title;
            task.description = description || task.description;
            task.status = status || task.status;
            task.priority = priority || task.priority;
            task.dueDate = dueDate || task.dueDate;
            task.category = category || task.category;
            task.project = project || task.project;

            const updatedTask = await task.save();
            res.json(updatedTask);
        } else {
            res.status(404).json({ message: 'Hawsha lama helin' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Cillad ayaa dhacday markii la cusboonaysiinayay' });
    }
};

// @desc    Delete task
// @route   DELETE /api/tasks/:id
// @access  Private
const deleteTask = async (req, res) => {
    try {
        const task = await Task.findById(req.params.id);

        if (task) {
            // Xaqiiji inuu isticmaalaha leeyahay hawshaan ama yahay admin
            if (task.userId.toString() !== req.user._id.toString() && req.user.role !== 'admin') {
                res.status(401).json({ message: 'Ma kuu ogola inaad tirtirto hawshaan' });
                return;
            }

            await task.deleteOne();
            res.json({ message: 'Hawsha waa la tirtiray' });
        } else {
            res.status(404).json({ message: 'Hawsha lama helin' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Cillad ayaa dhacday markii la tirtirayay' });
    }
};

module.exports = {
    getTasks,
    createTask,
    getTaskById,
    updateTask,
    deleteTask,
};
