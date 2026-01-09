package com.example.crypto_widget_app

import android.content.Context
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.longPreferencesKey
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.glance.appwidget.GlanceAppWidgetManager
import androidx.glance.appwidget.state.updateAppWidgetState
import androidx.glance.state.PreferencesGlanceStateDefinition
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

object CryptoWidgetUpdater {

    private val symbolKey = stringPreferencesKey("symbol")
    private val priceKey = stringPreferencesKey("price")
    private val changeKey = stringPreferencesKey("change")
    private val isPositiveKey = booleanPreferencesKey("isPositive")
    private val lastUpdatedKey = stringPreferencesKey("lastUpdated")
    private val timestampKey = longPreferencesKey("timestamp")

    /**
     * Updates the widget with new crypto data - INSTANT UPDATE
     */
    fun updateWidget(
        context: Context,
        symbol: String,
        price: String,
        change: String,
        isPositive: Boolean,
        lastUpdated: String
    ) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val manager = GlanceAppWidgetManager(context)
                val glanceIds = manager.getGlanceIds(CryptoGlanceWidget::class.java)
                val widget = CryptoGlanceWidget()

                glanceIds.forEach { glanceId ->
                    // Update state with new data + timestamp to force refresh
                    updateAppWidgetState(context, PreferencesGlanceStateDefinition, glanceId) { prefs ->
                        prefs.toMutablePreferences().apply {
                            this[symbolKey] = symbol
                            this[priceKey] = price
                            this[changeKey] = change
                            this[isPositiveKey] = isPositive
                            this[lastUpdatedKey] = lastUpdated
                            this[timestampKey] = System.currentTimeMillis()
                        }
                    }

                    // Trigger immediate update
                    widget.update(context, glanceId)
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    /**
     * Force refresh all widgets - useful for pull-to-refresh
     */
    fun forceRefreshAll(context: Context) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val manager = GlanceAppWidgetManager(context)
                val glanceIds = manager.getGlanceIds(CryptoGlanceWidget::class.java)
                val widget = CryptoGlanceWidget()

                glanceIds.forEach { glanceId ->
                    widget.update(context, glanceId)
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }
}
