# TODO List for Flutter Todo App

## Current Issues
- [x] When a user clicks the checkbox to mark a task as complete, the task is moved to the 'Tugas Selesai' (Completed Tasks) section. This is the intended behavior, not a bug. (Previously, it was unclear why the checkmark disappeared; it is because the task is filtered out from the active/upcoming list and shown in the completed section.)
- [x] Default due date in Add Task dialog is now set to today.
- [x] Grouping logic updated: tasks due today are only shown in 'Hari Ini', not in 'Tugas Mendatang'.
- [x] CRUD polish: Custom SnackBar messages and undo for delete implemented in all task screens.

## Project Setup
- [ ] Initialize Flutter project
- [ ] Set up version control (Git)
- [ ] Configure project structure
- [x] Add required dependencies (Supabase)

## Supabase Integration
- [x] Set up Supabase project
- [x] Integrate Supabase SDK with Flutter *(update pubspec.yaml, main.dart)*
- [x] Implement Supabase initialization in Flutter *(main.dart)*
- [x] Implement user authentication (login, registration, logout)
- [x] Manage user sessions
- [x] Connect app data (tasks, journal, etc.) to Supabase backend

## Design Implementation
- [x] Login Screen (Figma)
- [x] Register Screen (Figma)
- [x] Forgot Password Screen (Figma)
- [ ] Review Figma design (other screens)
- [ ] Export assets (icons, images)
- [ ] Set up color scheme and typography

## Core Features
- [ ] Create main UI screens
  - [x] Home (Task List)
  - [x] Add Task (Basic Dialog)
  - [x] Edit Task (Dialog)
  - [ ] Task Details
  - [x] Side Bar (Navigation Drawer)
  - [ ] Dashboard (Main Home)
  - [x] Add New Task Dialog/Screen (Figma style)
- [ ] Implement task CRUD (Create, Read, Update, Delete)
- [ ] Checklist/Subtask: Allow tasks to have subtasks or checklists
- [ ] Due Date & Reminder: Add notifications or reminders for tasks
- [ ] Progress Tracking: Show progress bars or completion stats for tasks
- [ ] Drag & Drop: Reorder tasks via drag-and-drop
- [ ] Add persistent storage (local database or shared preferences)

## Organization & Categorization
- [ ] Tags & Labels: Assign labels to tasks
- [ ] Color Coding: Assign colors to categories
- [ ] Search & Filter: Search and filter tasks by category/date

## Productivity Features
- [ ] Habit Tracker: Track daily habits (e.g., drink water, exercise)
- [ ] Daily Goals: Set and track daily goals with progress bar
- [ ] Dashboard Graphs: Show completion percentage (daily, weekly, monthly)

## Journal Features
- [ ] Daily Journal: Write daily notes or feelings
- [ ] Calendar View: View journal entries by date
- [ ] Journal Search: Search journal entries by keyword

## Personalization & Settings
- [ ] Dark/Light Theme: Toggle between dark and light mode
- [ ] Custom Colors: Choose favorite colors for categories
- [ ] Notification Settings: Configure notification preferences

## Prioritization
- [ ] Smart Scheduling: Suggest task order based on priority, deadline, and estimated duration
- [ ] Priority Rebalancing: Auto-adjust priorities when tasks or deadlines change

## Polish & Testing
- [ ] UI/UX refinements
- [ ] Accessibility improvements
- [ ] Write unit and widget tests
- [ ] Manual QA and bug fixing

## Deployment
- [ ] Prepare app for release
- [ ] Build for Android/iOS
- [ ] Publish to app stores (optional)

## Real Data Integration (Journal, Habit Tracker, Filter & Label)
- [ ] Design and create Supabase tables for:
    - [ ] Journal entries (date, content, user_id)
    - [ ] Habits and habit tracking (habit name, per-day status, user_id)
    - [ ] Labels (label name, color, user_id)
- [ ] Integrate Supabase CRUD operations in Flutter for:
    - [ ] JournalScreen: Add, fetch, and display journal entries for the logged-in user
    - [ ] HabitTrackerScreen: Fetch habits, mark completion, and display weekly status
    - [ ] FilterLabelScreen: Fetch, add, and manage labels
- [ ] Update UI to show real data, loading, and error states
- [x] Add edit/delete functionality for journal entries
- [ ] Add edit/delete functionality for habits
- [ ] Add edit/delete functionality for labels
- [ ] (Optional) Allow assigning labels to tasks or journal entries

---

## Progress Checklist
- [ ] Task completed
- [ ] Code reviewed
- [ ] Tested
- [ ] Documentation updated

---

**Note:**
- Please run `flutter pub get` in your terminal to resolve linter errors and complete Supabase integration. 