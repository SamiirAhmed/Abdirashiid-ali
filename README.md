# Task Management App

A full-stack Task Management System built with Flutter and Node.js.

## Architecture

- **Backend**: Node.js, Express, MongoDB, JWT Authentication.
- **Frontend**: Flutter, MVVM Architecture, Provider State Management.
- **Commentary**: All code is commented in Somali language.

## Features

- User Authentication (Login/Register)
- Task CRUD (Create, Read, Update, Delete)
- Prioritize Tasks (Low, Medium, High)
- Task Categories (Work, Personal, etc.)
- Dashboard with Task Summary
- Clean UI with Material Design

## Setup Instructions

### Backend
1. Go to `backend` directory.
2. Run `npm install`.
3. Create `.env` file with `PORT`, `MONGODB_URI`, and `JWT_SECRET`.
4. Run `npm start`.

### Frontend
1. Go to `frontend` directory.
2. Run `flutter pub get`.
3. Update `baseUrl` in `lib/core/constants.dart` if needed.
4. Run `flutter run`.

## API Documentation

- `POST /api/auth/register` - Register a new user
- `POST /api/auth/login` - Login and get token
- `GET /api/tasks` - Get all tasks (Protected)
- `POST /api/tasks` - Create a task (Protected)
- `PUT /api/tasks/:id` - Update a task (Protected)
- `DELETE /api/tasks/:id` - Delete a task (Protected)
