[ToDoList_README.md](https://github.com/user-attachments/files/25318047/ToDoList_README.md)
# To-Do List App

A comprehensive iOS to-do list application with categories, due dates, reminders, search functionality, and sharing capabilities.

## 📱 About

This app was created as part of the IT8108 Mobile Programming re-assessment (Part 2). It features full CRUD operations, data persistence, local notifications, and advanced filtering to help users manage their tasks effectively.

## ✨ Features

### Base Features
- **Create, Read, Update, Delete** - Full task management
- **Task Completion** - Mark tasks as complete/incomplete with visual feedback
- **Data Persistence** - Tasks saved locally using UserDefaults with JSON encoding
- **Swipe Actions** - Quick actions for completing, deleting, and sharing tasks
- **Edit Mode** - Bulk deletion support
- **Table View** - Native iOS list interface with smooth scrolling

### Stretch Goals Implemented ✅

- ✅ **Share Function** - Activity Controller for sharing task details via Mail, Messages, Notes, etc.
- ✅ **Search Field** - Live search filtering by task title or notes with category scope buttons
- ✅ **Categories/Tags** - 5 color-coded categories with emoji icons (Work, Personal, Shopping, Health, Other)
- ✅ **Due Dates** - Date picker integration with visual indicators for overdue and upcoming tasks
- ✅ **Reminder Notifications** - Local notifications via UNUserNotificationCenter scheduled for due dates

## 🎨 Design

**Figma Prototype:** https://www.figma.com/design/g9fJWgKewLRTXp0OAbaOsE/ToDoList-Prototype?node-id=0-1&t=C0z53lbIl27Aekhn-1

The app follows iOS design principles:
- Native table view patterns
- iOS-standard swipe gestures
- Search bar with scope filtering
- Grouped table view for forms
- Category-based color coding
- Status indicators (overdue, due soon, completed)

## 🛠️ Technical Details

- **Platform:** iOS 17.0+
- **Language:** Swift 5.9
- **UI Framework:** UIKit (Storyboards with Static Cells)
- **Architecture:** MVC (Model-View-Controller)
- **Data Storage:** UserDefaults with Codable protocol
- **Notifications:** UNUserNotificationCenter for local reminders

## 📦 Installation

### Requirements
- Xcode 15 or 16
- iOS 17.0+ device or simulator

### Steps
```bash
git clone https://github.com/wazawski0/ToDoList-iOS.git
cd ToDoList-iOS
open ToDoList.xcodeproj
```

Press ⌘R to build and run

## 🏗️ Project Structure

```
ToDoList/
├── Models/
│   └── ToDoItem.swift              # Task model with categories, dates, reminders
├── Controllers/
│   ├── ToDoTableViewController.swift        # Main list view
│   └── ToDoDetailTableViewController.swift  # Add/edit form
├── Views/
│   └── Main.storyboard
└── Supporting Files/
    ├── AppDelegate.swift
    ├── SceneDelegate.swift
    └── Assets.xcassets/
```

## 🎯 Feature Details

### Categories
5 color-coded categories with emojis:
- 💼 **Work** (Blue) - Professional tasks
- 👤 **Personal** (Green) - Personal errands
- 🛒 **Shopping** (Orange) - Shopping lists
- 💪 **Health** (Red) - Health & fitness
- 📝 **Other** (Gray) - Miscellaneous tasks

### Search & Filter
- **Live Text Search** - Updates as you type, searches title and notes
- **Category Scope Buttons** - Filter by specific category
- **Combined Filtering** - Use text search + category filter together
- **Case-Insensitive** - Flexible search matching

### Due Dates & Visual Indicators
- **Date Picker** - Collapsible inline date picker
- **Overdue Tasks** - Red text for overdue items
- **Due Soon** - Orange text for tasks due within 24 hours
- **No Clutter** - Tasks without due dates show normally

### Reminder Notifications
- **Local Notifications** - Scheduled at 9 AM on due date
- **Toggle Per Task** - Enable/disable reminders individually
- **Auto-Cancel** - Removing reminder or deleting task cancels notification
- **Permission Handling** - Requests notification access on first launch

### Swipe Actions
**Left Swipe:**
- 🗑️ **Delete** (Red) - Remove task
- 📤 **Share** (Blue) - Open Activity Controller

**Right Swipe:**
- ✅ **Complete** (Green) - Mark as done
- ⏳ **Incomplete** (Orange) - Mark as pending

### Share Function
Shares formatted task details including:
- Task title
- Notes (if present)
- Due date (if set)
- Category with emoji
- Completion status

## 🧪 Testing

Tested on:
- iPhone 14 Pro (Simulator)
- iPhone 15 (Simulator)
- iPad Pro 12.9" (Simulator)

### Test Coverage
- ✅ Create new tasks
- ✅ Edit existing tasks
- ✅ Delete tasks (swipe and edit mode)
- ✅ Mark complete/incomplete
- ✅ Search and filter
- ✅ Category selection
- ✅ Due date setting
- ✅ Reminder scheduling
- ✅ Share functionality
- ✅ Data persistence across app restarts

## 📚 Learning Outcomes

This project demonstrates:
- **LO1:** User-centric UI with intuitive interactions (swipe actions, search, date picker)
- **LO2:** Complex iOS app with data persistence, notifications, and table view management
- **LO3:** Industry standards including MVC architecture, Codable, proper error handling

## 🎓 Code Quality

### Industry Standards
- ✅ MVC architecture
- ✅ Protocol conformance via extensions
- ✅ MARK comments for organization
- ✅ Guard statements and optional binding
- ✅ Codable for data persistence
- ✅ Memory-safe (weak self in closures)
- ✅ Consistent naming conventions
- ✅ Proper error handling

### Swift Best Practices
- Value types (structs) for models
- Enums for categories
- Computed properties for status checks
- Extensions for protocol conformance
- Default values in initializers

## 🔔 Permissions

The app requests notification permissions on first launch for the reminder feature. Users can manage permissions in Settings.

## 🙏 Acknowledgments

- Apple's "Develop with Swift: Data Collections" curriculum
- Apple Human Interface Guidelines
- iOS Developer Documentation

## 📄 License

This project is created for educational purposes as part of IT8108 Mobile Programming course assessment.

## 👤 Author

**Yousif Abdulsalam**  
Student ID: 202302024  
Course: IT8108 Mobile Programming  
Year: Semester 1 / 2025-2026

## 📞 Contact

- Email: 202302024@student.polytechnic.bh
- GitHub: https://github.com/wazawski0/ToDoList-iOS.git

---

**Submission:** February 15, 2026 | Part 2 of 2  
**Status:** ✅ Complete with all stretch goals implemented

---

## 🚀 Future Enhancements

Potential improvements:
- iCloud sync across devices
- Recurring tasks
- Subtasks/checklists
- Task priority levels
- Statistics and insights
- Dark mode
- Widgets
- Siri shortcuts
- Collaborative lists

---

**Note:** This is an educational project demonstrating iOS development skills including UIKit, table views, data persistence, local notifications, and user interaction patterns.
