# The on-device notes AI (flutter_gemma) runs on MediaPipe, which its native code reaches by
# reflection, so R8 must keep it whole. The two proto classes it mentions aren't shipped at all.
-keep class com.google.mediapipe.** { *; }
-dontwarn com.google.mediapipe.proto.**

# Google sign-in goes through Credential Manager, which finds its Play Services backend by
# reflection. Without these, release builds can't open the account picker.
-if class androidx.credentials.CredentialManager
-keep class androidx.credentials.playservices.** { *; }
-keep class com.google.android.libraries.identity.googleid.** { *; }
