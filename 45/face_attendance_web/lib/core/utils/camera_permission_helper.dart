import 'package:flutter/foundation.dart';

class CameraPermissionHelper {
  /// Get browser-specific camera access instructions
  static String getBrowserInstructions() {
    if (kIsWeb) {
      return """
╔════════════════════════════════════════════════════╗
║         CAMERA ACCESS TROUBLESHOOTING              ║
╠════════════════════════════════════════════════════╣
║                                                    ║
║  If you see "No Camera Found":                     ║
║                                                    ║
║  1️⃣  ALLOW CAMERA PERMISSION:                      ║
║     • Browser will ask for permission on first use ║
║     • Click "Allow" when prompted                  ║
║     • If denied, check browser settings            ║
║                                                    ║
║  2️⃣  CHECK BROWSER SETTINGS:                       ║
║     Chrome/Edge:   Settings → Privacy → Camera     ║
║     Firefox:       About:preferences → Privacy     ║
║     Safari:        Preferences → Websites          ║
║                                                    ║
║  3️⃣  HTTPS REQUIREMENT:                            ║
║     • Camera access ONLY works on HTTPS            ║
║     • Localhost (127.0.0.1) is an exception        ║
║     • Ensure URL starts with "https://" or         ║
║       uses "localhost:port"                        ║
║                                                    ║
║  4️⃣  CHECK CAMERA IN USE:                          ║
║     • Ensure camera is not used by another app     ║
║     • Close other video call apps                  ║
║     • Restart browser if camera is stuck           ║
║                                                    ║
║  5️⃣  TRY DIFFERENT BROWSER:                        ║
║     • Chrome (best support)                        ║
║     • Firefox                                      ║
║     • Edge                                         ║
║     • Safari (limited support)                     ║
║                                                    ║
╚════════════════════════════════════════════════════╝
""";
    }
    return "Camera is not available on this platform.";
  }

  /// Detailed debugging info
  static String getDebugInfo() {
    return """
DEBUG INFO:
- Platform: ${kIsWeb ? 'Web' : 'Native'}
- Is Web: $kIsWeb
- Browser Environment: Check console for details

STEPS TO DEBUG:
1. Open Developer Console (F12 / Cmd+Option+I)
2. Check Console tab for camera errors
3. Go to Console and run:
   navigator.mediaDevices.enumerateDevices()
4. This will show all available media devices
5. Check if camera appears in the list
""";
  }
}
