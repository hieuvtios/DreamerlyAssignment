# Note app
 
Task-Management App

Working hours: ~ 14 hours

Features:
- Allow users to create, read, update, and delete tasks. ( Store database in Core Data)
- Implement task categorization lists (work, personal, etc.). ( User can add list with customize background color, tag color...)
- Add the ability to set reminders for tasks. ( Using local notifications)
- Create a dashboard view showing task statistics (e.g., completed vs. pending tasks). ( usings Charts)

Bonus Points (Optional):
- Implement data for persistent storage. (CoreData)
- Add haptic feedback for user interactions. (Add haptic feedback when user click done a task)
- Create a visually appealing onboarding experience for first-time users. (Onboarding for first time user use app)
- Implement drag-and-drop functionality for reordering tasks. (Drag-drop task lists)
- Filter data, set background color for list


IOS 16+ is the minimum requirement for this app


* Design decisions and rationale

Designing a task management app involves making several decisions about the app's functionality, user experience (UX), and technical architecture. Here's a breakdown of key design decisions and the rationale behind them:

1. User-Centered Design
- Target Audience: Understanding the target users (e.g., professionals, students, project managers) influences the features and user experience. A task management app aimed at professionals may focus more on task delegation and reporting, while one for personal use may emphasize simplicity and ease of use.
- User Flow: The task creation, editing, and completion processes should be simple and efficient. Users should be able to quickly add tasks, set deadlines, and mark tasks as complete.

2. Task Structuring
- Categories and Tags: Allowing users to group tasks into categories or use tags to filter and organize tasks provides flexibility in managing multiple projects or contexts.

3. Core Features
- Task Creation: This should be quick and intuitive, possibly integrating natural language processing for due dates (e.g., "Remind me tomorrow at 2 PM"). A minimalistic interface with the option to add additional details (tags, due dates, attachments) as needed can help reduce cognitive load.
- Deadlines and Reminders: Adding deadlines, notifications, and reminders ensures users are prompted when a task is due.
- Task Filtering and Sorting: Users should be able to filter tasks by completion status.
- Task Completion and Progress: User can see the progress in dashboard (finished, doing tasks)

4. Data Persistence
- Offline Support: Even without an internet connection, users should be able to create and edit tasks, with changes syncing when the device goes online.

5. UI/UX Design
- Minimalism: A task management app needs a clutter-free design that focuses on usability. The primary interaction points—such as creating tasks and viewing them—should be simple and visible.

6. Performance and Scalability
Local Database (e.g., Core Data): Using Core Data ensures that tasks and notes are efficiently stored and retrievable, even for users with large volumes of tasks. It also supports advanced filtering and sorting.

7. Notifications and Feedback
Reminders: Local notifications for upcoming tasks or deadlines can be crucial for users who need to be prompted to complete tasks.
Haptic Feedback: Subtle vibrations when completing a task, creating a satisfying user experience.

These design choices aim to balance functionality with user experience, ensuring the app is not only useful but also pleasant and easy to use.
  
Feature improvements:
- Filter lists & tasks by color
- Add File to Note
- Share list & note
- Filter by tags
- Sub task 
