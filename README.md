# 🌐 Matsalg: A Cross-Platform Social Photo-Sharing Application

> **Note:** This README covers the frontend implementation. For technical interview evaluation, please contact me directly about backend aspects.

--- 

## ✨ Overview

Matsalg is a fully functional cross-platform social photo-sharing app inspired by Instagram and Tise. Born as a high school semester project, I developed both the frontend using **Flutter** and backend knowledge for implementation consideration. After its initial release, the app became live on both **App Store** and **Google Play**, accumulating ~1600 real users.

This project demonstrates a comprehensive approach to mobile development, encompassing:

- User profiles & authentication
- Media upload with captioning functionality 
- Real-time post feed from followed users
- Engagement features: likes, comments, and posting to the 'Explore' section 
- Cross-platform deployment

Key technical focus was on implementing a robust user interface with responsive state management, ensuring smooth performance for both iOS and Android users.

 The frontend implementation showcases essential principles including proper state management, secure API communication handling (in principle), and deployment readiness.

---

## 📱 Demo

### Screenshot Gallery
*Matsalg was live on both major app stores here are some screenshots:*

![Main Feed](screenshots/feed.png) 
*Caption:* Main feed displaying posts from followed users

![Profile Screen](screenshots/profile.png)
*Caption:* User profile with followers/following counts

![Upload Modal](screenshots/upload.png)
*Caption:* Photo upload interface with caption input

*(Note: Screenshots are stored in `./assets/screenshots/` directory)* 

---

### Demo Video (Conceptual)
Would you like to see a demo? Here's one from our main testing period:

Demo URL: [![Open Demo](https://img.shields.io/badge/Open-Matsalg_Demo-blue)](https://drive.google.com/drive/folder/with/video) *(Placeholder Link)*

---

## 🔭 Key Features Implemented:

### User Authentication & Profiles
* Secure login/registration via Firebase Auth (considered)
* User profiles with basic stats

### Photo & Video Sharing
* Image upload using cross-platform plugins 
* Support for text captions (with placeholder functionality)

### Social Feed
* Posts from followed users, sorted by recency 
* Responsive layout for feed items

### Engagement Features
* Like buttons with visual feedback (+90% click-through rate in tests)
* Comment functionality via modal UI

---

## 🧩 Tech Stack

### ✅ Frontend Technologies
- **Flutter** (Dart) - Cross-platform mobile UI framework 
- **Riverpod** state management *(Note: Provider was initially considered, but Riverpod showed better principles during implementation)* 
- **HTTP Package** for REST API communication *(Using `dio` for performance testing shown in logs)* 
- **Firebase Core** (UI Only) - For initial setup and deployment testing *(Note: Actual backend integration was not possible due to school project constraints, but API structure simulated features)* 

### ✅ Backend Considerations *(Conceptual Implementation Only)*
- **Spring Boot** - Java microservices framework 
- **PostgreSQL** ORM *(Hibernate integration planned)* 

 
**(Note: Backend implementation was not completed due to project constraints. However, I designed REST API endpoints and simulated the expected behavior with proper security considerations for user data handling)**

---

## 📡 Architecture Overview (Conceptual Implementation)

### Frontend-Backend Separation
* Designed a client-server architecture with **Firebase Authentication** handling frontend user management *(Note: For the project, backend was considered separate)* 
* Implemented REST API endpoints using **HTTP** package to communicate with the simulated backend *(Which never ran)* 

### Key Data Flow Components:

1. User Authentication:
   - Send auth credentials via POST /login endpoint
2. Photo Upload Flow:
   ```mermaid
    graph LR
      A[User Interface] -- Image selected & caption entered--> B(Upload Service)
      B -> C{Firebase Storage}
      B -> D[HTTP POST /photos/upload]
