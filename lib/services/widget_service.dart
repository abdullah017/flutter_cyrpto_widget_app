import 'package:flutter/services.dart';
import 'crypto_service.dart';

class WidgetService {
  static const MethodChannel _channel = MethodChannel(
    'com.example.crypto_widget_app/widget',
  );

  /// Updates the Glance widget with new crypto data - INSTANT UPDATE
  static Future<bool> updateWidget(CryptoData data) async {
    try {
      final result = await _channel.invokeMethod('updateWidget', {
        'symbol': data.symbol,
        'price': data.formattedPrice,
        'change': data.formattedChange,
        'isPositive': data.isPositive,
        'lastUpdated': data.formattedTime,
      });
      return result == true;
    } catch (e) {
      print('WidgetService Error: $e');
      return false;
    }
  }

  /// Force refresh all widgets
  static Future<bool> forceRefresh() async {
    try {
      final result = await _channel.invokeMethod('forceRefresh');
      return result == true;
    } catch (e) {
      print('WidgetService ForceRefresh Error: $e');
      return false;
    }
  }

  /// Fetch data and update widget in one call
  static Future<bool> fetchAndUpdateWidget() async {
    final cryptoService = CryptoService();
    final data = await cryptoService.getBitcoinPrice();

    if (data != null) {
      return await updateWidget(data);
    }
    return false;
  }

  /// Initialize - not needed for Glance but kept for compatibility
  static Future<void> initialize() async {
    // No initialization needed for Glance widgets
  }
}
