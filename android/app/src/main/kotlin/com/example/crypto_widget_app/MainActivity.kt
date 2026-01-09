package com.example.crypto_widget_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.example.crypto_widget_app/widget"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "updateWidget" -> {
                    val symbol = call.argument<String>("symbol") ?: "BTC"
                    val price = call.argument<String>("price") ?: "$--,---"
                    val change = call.argument<String>("change") ?: "+0.00%"
                    val isPositive = call.argument<Boolean>("isPositive") ?: true
                    val lastUpdated = call.argument<String>("lastUpdated") ?: "--:--"

                    CryptoWidgetUpdater.updateWidget(
                        context = applicationContext,
                        symbol = symbol,
                        price = price,
                        change = change,
                        isPositive = isPositive,
                        lastUpdated = lastUpdated
                    )

                    result.success(true)
                }
                "forceRefresh" -> {
                    CryptoWidgetUpdater.forceRefreshAll(applicationContext)
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
