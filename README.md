# Flutter Todo

![demo](https://github.com/dev-hippo-an/flutter_todo/assets/65079652/894fad96-e590-4e11-89ab-458ce0dc4870)

# References

[to-do list - Google Play Store](https://play.google.com/store/apps/details?id=todolist.scheduleplanner.dailyplanner.todo.reminders&hl=ko&gl=US)

# How to start

1. Clone repository to your device
   ``` bash
   $ git clone https://github.com/dev-hippo-an/flutter_todo.git
   ```
2. Firebase project initialize.
   Visit [Firebase Console](https://console.firebase.google.com/) and create your own project to run clone to-do list
   project.
3. Install required tools
   ``` bash
   $ firebase login
   $ dart pub global activate flutterfire_cli
   ```
4. Configure firebase project on project terminal
   ``` bash
   $ flutterfire configure  # tick android and ios
   ```

Or you can simply follow along steps
on [firebase official document](https://firebase.google.com/docs/flutter/setup?platform=ios)

## 1.Project Outline

As beginner of Flutter and Dart, this project is stared to learn effectively Flutter and Dart.
While working on this project, I tried to focus on what I needed and wanted to learn.

1. Layout widgets without overflow
    - Understanding flutter widget and layout
2. State management using Provider
    - Dependency injection with GetIt
    - State management with Provider
3. Actively utilize firebase
    - Authentication with firebase auth
    - Data store with firebase firestore
    - File store with firebase storage

## 2. Main Features

| Domain        | Feature                                     | Complete                 |
|---------------|---------------------------------------------|--------------------------|
| User          | Email Login / Email Sign Up                 | ✅ / ✅                    |
|               | Google Login / Google Sign Up               | ✅ / ✅                    |
|               | Persist User Data                           | ✅                        |
|               | Profile Update                              |                          |
|               | profile photo pick                          |                          |
| Category      | create / edit / delete / star               | ✅ / ✅ / ✅ / ✅            |
|               | List State Management                       | ✅                        |
|               | hide & seen                                 | ✅                        |
| Task          | create                                      | ✅                        |
|               | subtask                                     | ✅                        |
|               | realtime editing                            | ⚠️(subtasks manual save) |
|               | temp delete / perm delete (infinity scroll) | ✅ / ✅                    |
|               | star (infinity scroll)                      | ✅                        |
|               | Main Task List State Management             | ✅                        |
|               | notify                                      |                          |
|               | repeat                                      |                          |
| Calendar View | Mark on Calendar                            | ✅                        |
|               | Calendar view                               | ✅                        |
|               | Selected date task list                     | ✅                        |
| Statics       | Task statics completed task                 | ✅                        |
|               | Share my statics                            |                          |

## 3. Dependencies

- [table_calendar](https://pub.dev/packages/table_calendar) - easily implement calendar widget
- [intl](https://pub.dev/packages/intl) - format date and internalization
- [go_router](https://pub.dev/packages/go_router) - path based route
- [provider](https://pub.dev/packages/provider) - state management
- [uuid](https://pub.dev/packages/uuid) - generate unique key
- [flutter_slidable](https://pub.dev/packages/flutter_slidable) - easily implement to slidable widget
- [image_picker](https://pub.dev/packages/image_picker) - native image picking
- [cloud_firestore](https://pub.dev/packages/cloud_firestore) - firestore database
- [firebase_core](https://pub.dev/packages/firebase_core) - configuration firebase
- [firebase_auth](https://pub.dev/packages/firebase_auth) - authentication (email)
- [firebase_storage](https://pub.dev/packages/firebase_storage) - store files
- [google_sign_in](https://pub.dev/packages/google_sign_in) - google sign in
- [flutter_signin_button](https://pub.dev/packages/flutter_signin_button) - easily implement standard sign in button
- [get_it](https://pub.dev/packages/get_it) - dependency injection
- [avatar_glow](https://pub.dev/packages/avatar_glow) - easily implement glow animation
- [fl_chart](https://pub.dev/packages/fl_chart) - easily implement flutter charts

