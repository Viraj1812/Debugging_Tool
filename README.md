# Debug Mate 🚀📱🔧

**Debug Mate** is a handy Android tool built for developers who want quick, hassle-free control over their device’s debugging settings. With an intuitive interface, you can instantly toggle essential developer features like USB and wireless debugging, or switch Developer Options on and off—all without digging through complex menus.

## ✨ Key Highlights

- Enable or disable USB Debugging with a single tap
- Control Wireless Debugging (Android 11+) directly from the app
- Turn Developer Options on or off instantly
- Check the real-time status of each debugging setting
- Clean, minimal design focused on speed and usability


## 📥 Installation
1. Build or obtain the APK – Clone the project from the repository and build it using Android Studio, or get the compiled APK from a trusted source.
2. Install it on your Android device.
3. Connect your device to your system, make sure **ADB** is installed, and run:
   ```bash
   adb shell pm grant com.hvdev.debugmate android.permission.WRITE_SECURE_SETTINGS
4. This will allow the app to make changes to Developer Settings.

