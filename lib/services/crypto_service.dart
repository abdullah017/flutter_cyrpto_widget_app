import 'dart:convert';
import 'package:http/http.dart' as http;

class CryptoData {
  final String symbol;
  final double price;
  final double change24h;
  final bool isPositive;
  final DateTime lastUpdated;

  CryptoData({
    required this.symbol,
    required this.price,
    required this.change24h,
    required this.isPositive,
    required this.lastUpdated,
  });

  String get formattedPrice {
    if (price >= 1000) {
      return '\$${price.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
    }
    return '\$${price.toStringAsFixed(2)}';
  }

  String get formattedChange {
    final sign = isPositive ? '+' : '';
    return '$sign${change24h.toStringAsFixed(2)}%';
  }

  String get formattedTime {
    return '${lastUpdated.hour.toString().padLeft(2, '0')}:${lastUpdated.minute.toString().padLeft(2, '0')}';
  }
}

class CryptoService {
  static const String _baseUrl = 'https://api.coingecko.com/api/v3';

  Future<CryptoData?> getBitcoinPrice() async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/simple/price?ids=bitcoin&vs_currencies=usd&include_24hr_change=true',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final btcData = data['bitcoin'];

        final price = (btcData['usd'] as num).toDouble();
        final change = (btcData['usd_24h_change'] as num?)?.toDouble() ?? 0.0;

        return CryptoData(
          symbol: 'BTC',
          price: price,
          change24h: change,
          isPositive: change >= 0,
          lastUpdated: DateTime.now(),
        );
      }
      return null;
    } catch (e) {
      print('CryptoService Error: $e');
      return null;
    }
  }
}
