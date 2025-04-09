package com.example.netshift

import android.app.*
import android.content.Context
import android.content.Intent
import android.content.BroadcastReceiver
import android.content.IntentFilter
import android.os.*
import androidx.core.app.NotificationCompat
import android.net.TrafficStats
import android.widget.Toast
import io.flutter.Log
import com.example.netshift.R


class ForegroundService : Service() {
    companion object {
        var isRunning = false
        var isServiceRunning = false
    }

    private val handler = Handler(Looper.getMainLooper())
    private val updateInterval: Long = 1000
    private lateinit var runnable: Runnable
    // private var isServiceRunning = false
    private var initialDownloadBytes: Long = 0
    private var initialUploadBytes: Long = 0
    private var downloadMB = 0.0
    private var uploadMB = 0.0
    private var previousDownloadBytes = 0L
    private var previousUploadBytes = 0L
    private var receiver: BroadcastReceiver? = null
    // private val runnable = object : Runnable {
    //     override fun run() {
    //         if (isRunning) {

    //             handler.postDelayed(this, 1000)
    //         }
    //     }
    // }
    override fun onCreate() {
        super.onCreate()
        handler
        initialDownloadBytes = TrafficStats.getTotalRxBytes()
        initialUploadBytes = TrafficStats.getTotalTxBytes()

        // Toast.makeText(applicationContext, "Service Started Successfully", Toast.LENGTH_SHORT).show()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        previousDownloadBytes = TrafficStats.getTotalRxBytes()
        previousUploadBytes = TrafficStats.getTotalTxBytes()

        when (intent?.action) {
            "STOP_DNS" -> {
//                isRunning = false
                Log.d("NetShift Service","Stopped from notification")
                stopVpnService()
                stopSelf()
                setServiceStatus(false)
                sendServiceStatusToFlutter()
                return START_NOT_STICKY
            }
            else -> {
                if (!isRunning) {
                    Log.d("NetShift Service","Started from notification")
                    val contentText = intent?.getStringExtra("contentText") ?: "Foreground Service Running"
                    isRunning = true
                    setServiceStatus(true)
                    sendServiceStatusToFlutter()
                    startForegroundService(contentText)
                    startDataUsageUpdates()
                }
            }
        }
        return START_STICKY
    }
    private fun startDataUsageUpdates() {
        runnable = object : Runnable {
            override fun run() {
                if (isRunning) {
                    val dataUsage = getDataUsage()
                    // logDataUsage(dataUsage)
                    sendMessageToFlutter(dataUsage)
                    handler.postDelayed(this, 100) 
                }
            }
        }
        handler.post(runnable)
    }
    private fun getDataUsage(): Map<String, Long> {
        val currentDownloadBytes = TrafficStats.getTotalRxBytes()
        val currentUploadBytes = TrafficStats.getTotalTxBytes()

        val downloadBytes = currentDownloadBytes - initialDownloadBytes
        val uploadBytes = currentUploadBytes - initialUploadBytes

        return mapOf(
            "download" to downloadBytes,
            "upload" to uploadBytes
        )
    }

    // private fun logDataUsage(dataUsage: Map<String, Long>) {
    //     val downloadMB = dataUsage["download"]!! / (1024.0 * 1024.0)
    //     val uploadMB = dataUsage["upload"]!! / (1024.0 * 1024.0)

    //     Log.d("DataUsage", "Download: %.2f MB, Upload: %.2f MB".format(downloadMB, uploadMB))
    // }

    private fun sendMessageToFlutter(dataUsage: Map<String, Long>) {
        handler.post {
            try {
                MainActivity.methodChannel?.invokeMethod("dataUsageUpdate", dataUsage)
                // println("Sending data to Flutter: $dataUsage")
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }
    

      private fun realTimeSpeed(): Map<String, Long> {
        val currentDownloadBytes = TrafficStats.getTotalRxBytes() 
        val currentUploadBytes = TrafficStats.getTotalTxBytes()

        val downloadDiff = currentDownloadBytes - previousDownloadBytes
        val uploadDiff = currentUploadBytes - previousUploadBytes

        previousDownloadBytes = currentDownloadBytes
        previousUploadBytes = currentUploadBytes

        return mapOf(
            "download" to downloadDiff,
            "upload" to uploadDiff
        )
    }
    private fun formatSpeed(bytes: Long): String {
        val kb = bytes / 1024.0
        val mb = kb / 1024.0
        val gb = mb / 1024.0
        return when {
            gb >= 1 -> String.format("%.2f GB/s", gb)
            mb >= 1 -> String.format("%.2f MB/s", mb)
            kb >= 1 -> String.format("%.2f KB/s", kb)
            else -> "$bytes B/s"
        }
    }
    
    private fun startForegroundService(contentText: String) {
        downloadMB = 0.0
        uploadMB = 0.0
        val channelId = "NetShift Service"
        val channelName = "NetShift Service"
    
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                channelName,
                NotificationManager.IMPORTANCE_LOW
            )
            getSystemService(NotificationManager::class.java)?.createNotificationChannel(channel)
        }
    
        val intent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
        }
        val pendingIntent = PendingIntent.getActivity(
            this, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    
        val stopIntent = Intent(this, ForegroundService::class.java).apply {
            action = "STOP_DNS"
        }
        val stopPendingIntent = PendingIntent.getService(
            this, 1, stopIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        val notificationBuilder = NotificationCompat.Builder(this@ForegroundService, channelId)
            .setContentTitle(contentText)
            .setOngoing(true)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setContentIntent(pendingIntent)
            .addAction(0, "STOP", stopPendingIntent)
    
        val notification = notificationBuilder.build()
        startForeground(1, notification)
    
        handler.postDelayed(object : Runnable {
            override fun run() {
                val dataUsage = realTimeSpeed()
                val formattedDownload = formatSpeed(dataUsage["download"] ?: 0L)
                val formattedUpload = formatSpeed(dataUsage["upload"] ?: 0L)
    
                notificationBuilder.setContentText("↓ $formattedDownload | ↑ $formattedUpload")
                val updatedNotification = notificationBuilder.build()
                val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                notificationManager.notify(1, updatedNotification)
    
                handler.postDelayed(this, updateInterval)
            }
        }, updateInterval)
    }

    private fun stopVpnService() {
        Log.d("NetShiftService", "stopVpnService called")
        val stopVpnIntent = Intent(this, NetShiftService::class.java).apply {
            action = NetShiftService.ACTION_STOP_DNS
        }
        startService(stopVpnIntent)
        stopService(stopVpnIntent)
    }
    

    override fun onDestroy() {
        super.onDestroy()
        stopForeground(STOP_FOREGROUND_REMOVE)
        stopSelf()
        handler.removeCallbacksAndMessages(null)
        setServiceStatus(false)
        sendServiceStatusToFlutter()
        isRunning = false
        // Toast.makeText(applicationContext, "Service Stopped Successfully", Toast.LENGTH_SHORT).show()
    }

    override fun onBind(intent: Intent?): IBinder? = null
    fun getServiceStatus(): Boolean {
        val sharedPreferences = getSharedPreferences("NetShiftPrefs", Context.MODE_PRIVATE)
        val status = sharedPreferences.getBoolean("service_running", false)
        Log.d("ForegroundService", "Loaded service status: $status")
        isServiceRunning = status
        return status
    }

    private fun setServiceStatus(isRunning: Boolean) {
        val sharedPreferences = getSharedPreferences("NetShiftPrefs", Context.MODE_PRIVATE)
        sharedPreferences.edit().putBoolean("service_running", isRunning).apply()
        Log.d("ForegroundService", "Saved service status: $isRunning")
    }

    private fun sendServiceStatusToFlutter() {
        val status = getServiceStatus()
        Log.d("ForegroundService", "Sending service status to Flutter: $status")
        MainActivity.methodChannel?.invokeMethod("serviceStatusUpdate", status)
    }
}
