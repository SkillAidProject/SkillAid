## SkillAid – Inclusive Skill Learning for All

# Project Vision

SkillAid is a mobilefirst learning platform built to break barriers in digital education. Our mission is to empower individuals—regardless of physical ability, literacy level, or internet access—with practical and digital skills that improve livelihoods and confidence.

SkillAid is not just an app. It’s a movement toward inclusive, accessible, and humancentered learning.


# Objectives

* Deliver skillbased education in formats accessible to visually impaired, hearingimpaired, and lowliteracy learners.

* Provide offline access to lessons for users in lowconnectivity regions.

* Connect learners with mentors for personalized guidance and motivation.

* Offer a scalable platform that grows with community contributions and regional relevance.



## User Roles

# Learner

* Browse and enroll in skill programs.

* Learn via video, audio, or simplified text formats.

* Use voice navigation and audio playback for accessibility.

* Enable captions or transcripts for hearing support.

* Download lessons for offline learning.

* Request mentorship after completing modules.

* Rate and review lessons.

* Customize display settings (font size, theme).

# Mentor

* Register and await admin approval.

* Upload tutorials in video, audio, or text formats.

* Respond to mentorship requests.

* Track learner progress.

* Communicate via chat or announcements.

# Admin

* Manage learner and mentor accounts.

* Approve or remove mentors.

* Create and categorize skill programs.

* Monitor engagement and app analytics.

* Send global notifications and updates.

## Skill Categories

* Soft Skills: Communication, Leadership, Emotional Intelligence

* Technical Skills: Python, Web Development, UI/UX Design

* Vocational Skills: Tailoring, Soap Making, Cashew Juice Production

* Entrepreneurship: Business Planning, Financial Literacy



## Accessibility Features

SkillAid is designed with empathy and inclusion at its core:

* Voice Navigation: Speechguided app interaction for visually impaired users.

* Sign Language & Captions: Video content with sign language and closed captions.

* Text Transcripts: Readable alternatives for audio/video lessons.

* Adjustable Font Size: For readability and eye comfort.

* Theme Settings: Light/Dark mode toggle for visual accessibility.

* Offline Learning Mode: Download lessons for uninterrupted access.

* Simple Layouts & Large Buttons: Easy navigation for all users.



## System Logic Overview

* Learner → Browse → Enroll → Learn (Text/Audio/Video) → Download Offline → Complete Module → Request Mentorship

* Mentor → Upload Lessons → Respond to Learners → Review Progress

* Admin → Manage Users → Upload Skill Categories → Send Global Updates



## Tech Stack

* Frontend: Flutter (crossplatform mobile development)

* Backend: Firebase (authentication, database, cloud functions)

* Version Control: GitHub

* Design Tools: Figma / Whimsical (for wireframes)


 
## Repository Structure

```
SkillAid/
├── lib/
│   ├── screens/
│   ├── widgets/
│   ├── models/
│   └── services/
├── assets/
│   ├── images/
│   └── icons/
├── pubspec.yaml
└── README.md
```

 
## Setup Instructions

* Clone the repository:git clone https://github.com/yourusername/skillaid.git

* Navigate to the project folder:cd skillaid

* Install dependencies:flutter pub get

* Run the app:flutter run



## Version Control

* Initial commit: flutter create skillaid

* Commit history includes:

* Login and registration screens

* Accessibility settings integration

* Skill program listing and detail views

* Mentor dashboard and chat module
  # TEAM MEMBERS AND THEIR ROLES
 * Emmanuel Adu Yeboah  Team Leader.
  * Okoro Ikechukwu Stephen  Programmer.
  * MD Qasim                 Programme.r
  * Eugene Priest            Designer.
  * Prashant Puri            Project Manager.

 
## Feedback & Contributions

We welcome feedback from learners, educators, and developers. If you have ideas to improve SkillAid or want to contribute, feel free to open an issue or submit a pull request.


 
## Impact Statement

SkillAid is built for the millions who are often left behind in digital education. By combining technology, empathy, and accessibility, we aim to create a platform that’s not just functional—but transformational.

“Education should be a right, not a privilege. SkillAid makes that right accessible to all.”



# **SkillAid – Inclusive Skill Learning for All**

### Week 2 Deliverable – Functional UI Prototype



**Project Overview**

SkillAid continues to evolve into an accessible and inclusive mobile learning platform that empowers individuals of all abilities to gain practical and digital skills.

In **Week 2**, the focus was on **translating wireframes into a working UI prototype** using Flutter, implementing navigation between the main app screens, and ensuring that accessibility and simplicity remained central to the design.



##  **Objectives Achieved (Week 2)**

* Developed **four fully functional UI screens**:

  1. **Login Screen** – Simple authentication interface for learners and mentors.
  2. **Home Screen** – Displays key learning categories and navigation options.
  3. **Program Listing Screen** – Organized view of all available skill programs.
  4. **Program Details Screen** – Displays detailed course info with mentorship and offline options.

* Implemented **interactive navigation** between screens using Flutter’s `Navigator` and `MaterialPageRoute`.

* Incorporated **consistent color themes and layout spacing** for improved readability.

* Updated **README documentation** and **GitHub repository** with screenshots and progress commits.

* Ensured that **accessibility widgets** such as `Semantics`, scalable text, and contrastaware themes are planned and partially integrated.



##  **Tech Stack**

* **Frontend:** Flutter (Dart)
* **Backend:** Firebase (for authentication and cloud data management – planned for Week 3)
* **Version Control:** Git & GitHub
* **Design Tool:** Figma





##  **Improvements Based on Week 1 Feedback**

 Area                    Feedback                    Action Taken                                          
      
 **User Journey**        Too detailed                Simplified for better readability and clarity         
 **Tech Stack Mention**  Missing accessibility tech  Added Flutter Semantics and TTS API references        
 **Visual Elements**     Needed annotations          Added annotated screenshots and clear navigation flow 
 **Privacy Concerns**    Not addressed               Added data privacy note for mentorship features       



##  **Team Members and Roles**

 Name                         Role             Responsibilities                                

 **Emmanuel Yeboah Adu**      Team Leader      UI development, navigation setup, documentation 
 **Okoro Ikechukwu Stephen**  Programmer       Screen implementation, widget creation          
 **MD Qasim**                 Programmer       Layout design and feature testing               
 **Eugene Priest**            Designer         UI layout design, Figma updates                 
 **Prashant Puri**            Project Manager  Coordination, quality review, and submissions   



## **Next Steps (Week 3 Preview)**

* Integrate Firebase authentication and realtime data storage.
* Begin backend connection for user login and mentorship data.
* Expand UI to include mentorship chat and profile settings.
* Conduct accessibility testing for voice and text scaling features.

0

##  **Closing Statement**

Week 2 marked the transition from concept to interaction — transforming static wireframes into a working user interface. The SkillAid prototype now provides a functional and visually cohesive user experience that reflects our vision of accessible learning for all.

> “Accessibility is not an option — it’s the foundation of true education for everyone.”






