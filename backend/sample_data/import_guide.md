# How to Import Sample Data into MongoDB

## Prerequisites
- MongoDB must be running on `localhost:27017`
- Make sure you're in the `backend/sample_data` directory

## Important Notes
⚠️ **The sample users have placeholder passwords.** You'll need to register new users through the app to get properly hashed passwords, or update the password hashes manually.

## Method 1: Using MongoDB Compass (Easiest)

1. **Connect to MongoDB:**
   - Open MongoDB Compass
   - Connect to: `mongodb://localhost:27017`

2. **Create Database (if not exists):**
   - Click "Create Database"
   - Database Name: `task_mgmt_db`
   - Collection Name: `users`

3. **Import Categories:**
   - Select database `task_mgmt_db`
   - Click on `categories` collection (create if doesn't exist)
   - Click "ADD DATA" → "Import File"
   - Select `categories.json`
   - Click "Import"

4. **Import Users (Optional):**
   - Select `users` collection
   - Click "ADD DATA" → "Import File"
   - Select `users.json`
   - Click "Import"
   - ⚠️ Note: Passwords won't work. Register users through the app instead.

## Method 2: Using Command Line (mongoimport)

Open PowerShell in the `backend/sample_data` directory and run:

```powershell
# Import categories and projects
mongoimport --db task_mgmt_db --collection categories --file categories.json --jsonArray

# Import users (optional - passwords won't work)
mongoimport --db task_mgmt_db --collection users --file users.json --jsonArray
```

## Method 3: Using VS Code MongoDB Extension

1. Connect to `mongodb://localhost:27017`
2. Expand `task_mgmt_db`
3. Right-click on `categories` collection
4. Select "Import Documents"
5. Choose `categories.json`

## Recommended Approach

**For best results:**
1. Import only `categories.json` using any method above
2. Register users through your Flutter app (this ensures proper password hashing)
3. Create tasks through the app interface

This way, all authentication will work correctly!

## Verify Import

After importing, you should see:
- **categories collection:** 8 documents (4 categories + 4 projects)
- Categories: Work, Personal, Shopping, Urgent
- Projects: Mobile App Development, Website Redesign, Marketing Campaign, Main Project
