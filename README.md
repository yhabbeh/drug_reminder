# Drug Dose - Medication Management App

A Flutter-based mobile application designed to help users manage their medication schedules effectively and reliably.

## About The Project

This application provides a simple and intuitive interface for users to track their medications, schedule doses, and receive timely reminders. The goal is to ensure users adhere to their prescribed medication plans, improving their health outcomes. Built with Flutter, the app targets both Android and iOS platforms from a single codebase.

The project utilizes the BLoC pattern for state management to create a scalable and maintainable architecture.

## Core Features

*   **Medication Scheduling:** Easily add medications and set up complex recurring schedules (e.g., daily, specific days of the week, hourly intervals).
*   **Dose Reminders:** Delivers reliable local notifications to remind users when it's time to take their medication.
*   **Contact Integration:** Allows the app to interact with the user's contacts, likely for features involving caregivers or emergency contacts.
*   **Permission Handling:** Gracefully requests necessary permissions for notifications and contact access.

## Project Vision

The vision is to evolve this app from a simple reminder tool into a comprehensive personal health assistant. It aims to be a central hub for a user's medication and health-related information, with the ability to securely share data with caregivers or healthcare professionals.

## Future Features Roadmap

-   [ ] **Medication Adherence Tracking:**
    *   Log whether a dose was taken, skipped, or taken late.
    *   Provide visual reports (charts, graphs) to show adherence over time.

-   [ ] **Enhanced Caregiver Features:**
    *   Automatically notify a designated contact (e.g., via SMS using the telephony package) if a dose is missed.
    *   Allow a caregiver to remotely monitor medication adherence.

-   [ ] **Inventory and Refill Reminders:**
    *   Track the number of pills remaining for each prescription.
    *   Send a notification when a prescription is running low and needs a refill.

-   [ ] **Health Data Logging:**
    *   Add sections to log symptoms, side effects, or other relevant health metrics (e.g., blood pressure, glucose levels).
    *   Correlate this data with medication intake.

-   [ ] **Data Export:**
    *   Generate and export medication and adherence reports as a PDF or CSV to share with doctors.

-   [ ] **User Profile Management:**
    *   Support multiple user profiles within the same app for family use.

-   [ ] **Cloud Sync & Backup:**
    *   Implement a backend service (e.g., Firebase) to securely back up and sync user data across multiple devices.

-   [ ] **Drug Database Integration:**
    *   Integrate with a drug API to auto-fill medication details.
    *   Implement a barcode scanner to add medications quickly.
    *   Check for potential drug-to-drug interactions.

## Getting Started

This is a standard Flutter project.

1.  Ensure you have the Flutter SDK installed.
2.  Clone the repository.
3.  Install dependencies:
    ```sh
    flutter pub get
    ```
4.  Run the application:
    ```sh
    flutter run
    ```
