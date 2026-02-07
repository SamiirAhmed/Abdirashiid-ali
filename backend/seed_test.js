const mongoose = require('mongoose');
const dotenv = require('dotenv');
const Task = require('./models/Task');
const User = require('./models/User');

dotenv.config();

const seedTestTask = async () => {
    try {
        await mongoose.connect(process.env.MONGODB_URI);

        // Find an admin user to be the owner
        let admin = await User.findOne({ role: 'admin' });
        if (!admin) {
            admin = await User.findOne();
        }

        if (!admin) {
            console.log('No users found in DB. Please register first.');
            process.exit(1);
        }

        const testTask = await Task.create({
            userId: admin._id,
            title: 'Welcome to TaskFlow! ✅',
            description: 'Mid kasta waa halkan si uu kuu caawiyo. This is a test task to verify visibility.',
            status: 'pending',
            priority: 'high',
            category: 'Work',
            project: 'Main Project',
            dueDate: new Date()
        });

        console.log('Test task created successfully:');
        console.log(JSON.stringify(testTask, null, 2));
        process.exit();
    } catch (err) {
        console.error(err);
        process.exit(1);
    }
};

seedTestTask();
