# Assignment 1 – Taleb+ RESTful API Integration

##  Student Info
- Name: Qusai Iyad
- ID: 1171174

##  Project Summary
This project is part of the Web Services course (COM4381).  
I created a mobile app called **Taleb+** that gives students discounts from local shops.

I also built a simple backend using **Node.js and Express** to handle user sign up, login, and shop management.

The app uses this backend to send and receive data using RESTful APIs.

##  What’s in the Repo?
- `lib/` → Flutter app (client-side)
- `backend/` → Node.js API (server-side)
- `README.md` → This file

##  How to Run the Project

###  Flutter App
- Make sure Flutter is installed
- Run this in terminal:
```bash
flutter pub get
flutter run
```

###  Backend (Optional)
```bash
cd backend
npm install
node index.js
```

> The server runs on `http://localhost:3000`

##  API Endpoints (from backend)
- `POST /signup` → Register new student
- `POST /login` → Login
- `GET /shops` → Get all shops
- `POST /shops` → Add shop
- `PUT /shops/:id` → Update shop
- `DELETE /shops/:id` → Delete shop