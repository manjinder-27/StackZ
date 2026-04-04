# 🚀 StackZ – Backend-Driven Learning Platform

StackZ is a full-stack learning platform built with a Flutter mobile app and a Django REST backend, designed to deliver structured course content dynamically.

## 🧠 Key Features
- 📚 Structured course system (Courses → Modules → Lessons)
- 📝 Markdown-based content delivery (dynamic & easily updatable)
- 🔐 User authentication and progress tracking
- ⚙️ Clean backend architecture with Django REST Framework
- 🚀 Scalable design with separation of concerns

## 🏗️ Architecture
- Frontend: Flutter (mobile app)
- Backend: Django + Django REST Framework
- Content Storage: Markdown files (filesystem-based)
- Database: Stores metadata (courses, users, progress)

## 💡 Design Decisions
- Used a hybrid approach:
  - Database for structured data
  - Filesystem (Markdown) for content
- This allows:
  - Easy content updates
  - Better separation of concerns
  - Lightweight and flexible system

## 📂 Project Structure
```
stackz/
 ├── app/      # Flutter application
 └── backend/         # Django REST API
```

## 🔧 Setup Instructions
### Backend
```
cd backend
pip install -r requirements.txt
python manage.py runserver
```
### Mobile App
```
cd app
flutter pub get
flutter run
```

## 🎯 Purpose

This project demonstrates:

- Backend system design
- API development
- Content management strategy
- Real-world architecture decisions