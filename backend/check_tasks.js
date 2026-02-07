const mongoose = require('mongoose');
const dotenv = require('dotenv');
const Task = require('./models/Task');

dotenv.config();

const checkTasks = async () => {
    try {
        await mongoose.connect(process.env.MONGODB_URI);
        const count = await Task.countDocuments();
        console.log(`Total Tasks in DB: ${count}`);
        const tasks = await Task.find().limit(5);
        console.log('Sample Tasks:');
        console.log(JSON.stringify(tasks, null, 2));
        process.exit();
    } catch (err) {
        console.error(err);
        process.exit(1);
    }
};

checkTasks();
