package com.example.crypto_widget_app

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.GlanceAppWidgetReceiver

class CryptoWidgetReceiver : GlanceAppWidgetReceiver() {

    override val glanceAppWidget: GlanceAppWidget = CryptoGlanceWidget()

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)

        // Custom action for instant update from Flutter
        if (intent.action == ACTION_UPDATE_WIDGET) {
            // Widget will be updated via GlanceAppWidget.update()
        }
    }

    companion object {
        const val ACTION_UPDATE_WIDGET = "com.example.crypto_widget_app.ACTION_UPDATE_WIDGET"
    }
}
