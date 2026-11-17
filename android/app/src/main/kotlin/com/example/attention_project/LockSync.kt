package com.example.attention_project

import android.content.Context
import android.os.Build
import android.util.Log
import com.google.firebase.FirebaseApp
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.DocumentReference
import com.google.firebase.firestore.FieldValue
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.ListenerRegistration

/**
 * Shares the lock session between every device signed in to the same Google account.
 *
 * One Firestore document, users/{uid}/sync/lock, holds the latest session. A device that starts
 * or ends a session writes it; the others see the change and do the same. Sessions are told
 * apart by their start time, which also keeps every device's locked and free phases in step.
 *
 * Started by the accessibility service (which keeps running while the app is closed) and by the
 * app itself. Sign-in happens in Flutter, which shares the native FirebaseAuth instance.
 */
object LockSync {
    private const val TAG = "LockSync"

    private var registration: ListenerRegistration? = null
    private var listeningUid: String? = null
    private var authListenerAdded = false

    private fun ready(context: Context) = FirebaseApp.getApps(context).isNotEmpty()

    private fun doc(uid: String): DocumentReference =
        FirebaseFirestore.getInstance().collection("users").document(uid).collection("sync").document("lock")

    private fun uid(context: Context): String? =
        if (ready(context)) FirebaseAuth.getInstance().currentUser?.uid else null

    /** Starts following the signed-in account, and keeps following it across sign-in and out. */
    @Synchronized
    fun start(context: Context) {
        val app = context.applicationContext
        if (!ready(app)) return
        if (authListenerAdded) return
        authListenerAdded = true
        // Called straight away with the current user, then on every sign-in and sign-out.
        FirebaseAuth.getInstance().addAuthStateListener { attach(app, it.currentUser?.uid) }
    }

    @Synchronized
    private fun attach(context: Context, uid: String?) {
        if (uid == listeningUid) return
        registration?.remove()
        registration = null
        listeningUid = uid
        if (uid == null) return
        registration = doc(uid).addSnapshotListener { snap, error ->
            if (error != null) {
                Log.w(TAG, "listen failed", error)
                return@addSnapshotListener
            }
            // Our own writes come back here first; there's nothing new in them.
            if (snap == null || snap.metadata.hasPendingWrites()) return@addSnapshotListener
            val data = snap.data
            if (data == null) {
                // Nothing shared yet: share what this device is doing.
                if (LockState.isActive(context)) push(context)
                return@addSnapshotListener
            }
            apply(context, data)
        }
    }

    private fun apply(context: Context, data: Map<String, Any?>) {
        val active = data["active"] as? Boolean ?: false
        val start = (data["startMillis"] as? Number)?.toLong() ?: 0L
        val localActive = LockState.isActive(context)
        val localStart = LockState.startMillis(context)

        when {
            // This device started (or ended) a newer session than the shared one, perhaps while
            // offline. The newest start wins.
            localStart > start -> push(context)

            active && (!localActive || localStart != start) -> {
                val codeHash = data["codeHash"] as? String ?: return
                LockState.applyRemote(
                    context,
                    packages = (data["packages"] as? List<*>)?.filterIsInstance<String>()?.toSet() ?: emptySet(),
                    lockMinutes = (data["lockMinutes"] as? Number)?.toInt() ?: 30,
                    unlockMinutes = (data["unlockMinutes"] as? Number)?.toInt() ?: 15,
                    startLocked = data["startLocked"] as? Boolean ?: true,
                    repeat = data["repeat"] as? Boolean ?: true,
                    strict = data["strict"] as? Boolean ?: false,
                    codeHash = codeHash,
                    startMillis = start,
                )
            }

            !active && localActive && localStart == start -> {
                val wasRecording = LockState.record(context)
                LockState.endRemote(context)
                if (wasRecording) LectureRecorderService.stop(context)
            }
        }

        // An unlock code emailed from any device works on all of them.
        if (active && LockState.isActive(context) && LockState.startMillis(context) == start) {
            LockState.setRescue(
                context,
                data["rescueHash"] as? String,
                (data["rescueUntil"] as? Number)?.toLong() ?: 0L,
            )
        }
    }

    /** Shares this device's session (or that it has ended). Does nothing when signed out. */
    fun push(context: Context) {
        val uid = uid(context) ?: return
        val data: Map<String, Any?> = if (LockState.isActive(context)) {
            mapOf(
                "active" to true,
                "packages" to LockState.packages(context).toList(),
                "lockMinutes" to LockState.lockMinutes(context),
                "unlockMinutes" to LockState.unlockMinutes(context),
                "startLocked" to LockState.startLocked(context),
                "repeat" to LockState.repeat(context),
                "strict" to LockState.strict(context),
                "startMillis" to LockState.startMillis(context),
                "codeHash" to LockState.codeHash(context),
                "rescueHash" to LockState.rescueHash(context),
                "rescueUntil" to LockState.rescueUntil(context),
                "device" to Build.MODEL,
                "updatedAt" to FieldValue.serverTimestamp(),
            )
        } else {
            mapOf(
                "active" to false,
                "startMillis" to LockState.startMillis(context),
                "device" to Build.MODEL,
                "updatedAt" to FieldValue.serverTimestamp(),
            )
        }
        doc(uid).set(data).addOnFailureListener { Log.w(TAG, "push failed", it) }
    }
}
