# QR Code Inventory Management and Item Tracking System - Mobile Application

## **Overview**

The `mobile app` is designed to keep track of purchase requests and receive inventory items. This can be done by  scanning the QR codes attached from the issuance documents or stickers, after which the app updates the issuance status and notifies the supply custodian in the desktop app.

---

## **Features**

- **Authentication**: Secure login with email and admin verification before accessing the app.
- **Home**: Quick overview of purchase requests, including ongoing ones.
- **Purchase Request Overview**: View detailed information about your request and send follow-up notifications to the supply custodian.
- **Notifications**: Receive app notifications when your request is registered, issued, or canceled.
- **QR Code Scanning for Issuance**: Scan QR codes from issuance documents or items stickers to see details and confirm receipt. Once confirmed, the supply custodian is notified and the issuance status is updated.
- **Profile**: View your personal information such as name, position, and department. 

---

## **Technologies Used**  
Tools, language, and frameworks used in the project:  
- **Frameworks**: Flutter, Dart Frog 
- **Language**: Dart  
- **Database**: PostgreSQL  
- **Version Control**: Git & GitHub
- **State Management**: BLoC
- **IDE**: Android Studio / VS Code

---

## **Setup & Installation**

### **Prerequisites**

* [Flutter SDK](https://flutter.dev/docs/get-started/install)
* Dart (comes with Flutter)
* Code Editor: VS Code / Android Studio

---

### **Steps to Run the Project**

1. **Clone the Repository**

   ```bash
   git clone https://github.com/kal-i/qrims_mobile.git
   cd qrims_mobile
   ```

2. **Install Dependencies**

   ```bash
   flutter pub get
   ```

3. **Set Up the Local Server**

   1. Find your computer’s IP address:

      ```bash
      ipconfig
      ```

      Look for the **IPv4 Address** (e.g., `192.168.1.22`).

   2. Update your `.env` file:

      ```dotenv
      IPv4_ADDRESS = '192.168.1.22'
      BASE_URL = 'http://${IPv4_ADDRESS}:your-port-here'
      ```

   3. Make sure your **computer (server)** and **mobile device** are on the **same Wi-Fi network**.

   4. Start the backend server (Dart Frog) before running the app.

4. **Run the App**

   ```bash
   flutter run
   ```

---


## Screenshots  
![Mobile Home View](https://raw.githubusercontent.com/kal-i/qrims_desktop/main/assets/images/home.jpg) 

## How to Use  
[Download User Manual (PDF)](https://github.com/kal-i/qrims_desktop/raw/main/UserManual.pdf)
