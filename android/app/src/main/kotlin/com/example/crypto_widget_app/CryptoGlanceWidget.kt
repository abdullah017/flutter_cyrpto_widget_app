package com.example.crypto_widget_app

import android.content.Context
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.GlanceTheme
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.provideContent
import androidx.glance.appwidget.cornerRadius
import androidx.glance.background
import androidx.glance.currentState
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.layout.size
import androidx.glance.layout.width
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider
import androidx.glance.appwidget.state.updateAppWidgetState
import androidx.glance.state.GlanceStateDefinition
import androidx.glance.state.PreferencesGlanceStateDefinition

class CryptoGlanceWidget : GlanceAppWidget() {

    override val stateDefinition: GlanceStateDefinition<*> = PreferencesGlanceStateDefinition

    companion object {
        val symbolKey = stringPreferencesKey("symbol")
        val priceKey = stringPreferencesKey("price")
        val changeKey = stringPreferencesKey("change")
        val isPositiveKey = booleanPreferencesKey("isPositive")
        val lastUpdatedKey = stringPreferencesKey("lastUpdated")
    }

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            GlanceTheme {
                CryptoWidgetContent()
            }
        }
    }

    @Composable
    private fun CryptoWidgetContent() {
        val prefs = currentState<androidx.datastore.preferences.core.Preferences>()

        val symbol = prefs[symbolKey] ?: "BTC"
        val price = prefs[priceKey] ?: "$--,---"
        val change = prefs[changeKey] ?: "+0.00%"
        val isPositive = prefs[isPositiveKey] ?: true
        val lastUpdated = prefs[lastUpdatedKey] ?: "--:--"

        val backgroundColor = Color(0xFF1A1A2E)
        val cardColor = Color(0xFF2D2D44)
        val textColor = Color.White
        val secondaryTextColor = Color(0xFF888888)
        val positiveColor = Color(0xFF4CAF50)
        val negativeColor = Color(0xFFF44336)
        val accentColor = Color(0xFFFF9800)

        Box(
            modifier = GlanceModifier
                .fillMaxSize()
                .background(backgroundColor)
                .cornerRadius(16.dp)
                .padding(12.dp)
        ) {
            Column(
                modifier = GlanceModifier.fillMaxSize(),
                verticalAlignment = Alignment.Top,
                horizontalAlignment = Alignment.Start
            ) {
                // Header Row - BTC Icon + Symbol
                Row(
                    modifier = GlanceModifier.fillMaxWidth(),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    // BTC Icon (Orange Box)
                    Box(
                        modifier = GlanceModifier
                            .size(32.dp)
                            .background(accentColor)
                            .cornerRadius(8.dp),
                        contentAlignment = Alignment.Center
                    ) {
                        Text(
                            text = "₿",
                            style = TextStyle(
                                color = ColorProvider(Color.White),
                                fontSize = 18.sp,
                                fontWeight = FontWeight.Bold
                            )
                        )
                    }

                    Spacer(modifier = GlanceModifier.width(8.dp))

                    Text(
                        text = symbol,
                        style = TextStyle(
                            color = ColorProvider(textColor),
                            fontSize = 18.sp,
                            fontWeight = FontWeight.Bold
                        )
                    )
                }

                Spacer(modifier = GlanceModifier.height(12.dp))

                // Price
                Text(
                    text = price,
                    style = TextStyle(
                        color = ColorProvider(textColor),
                        fontSize = 24.sp,
                        fontWeight = FontWeight.Bold
                    )
                )

                Spacer(modifier = GlanceModifier.height(4.dp))

                // Change Percentage
                Text(
                    text = change,
                    style = TextStyle(
                        color = ColorProvider(if (isPositive) positiveColor else negativeColor),
                        fontSize = 16.sp,
                        fontWeight = FontWeight.Bold
                    )
                )

                Spacer(modifier = GlanceModifier.height(8.dp))

                // Last Updated
                Text(
                    text = "Son: $lastUpdated",
                    style = TextStyle(
                        color = ColorProvider(secondaryTextColor),
                        fontSize = 12.sp
                    )
                )
            }
        }
    }
}
