import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/crypto_currency.dart';

class ApiService {
  final http.Client client;

  ApiService({required this.client});

  Future<List<CryptoCurrency>> getMarkets({
    String vsCurrency = 'usd',
    int perPage = 100,
    int page = 1,
  }) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}/coins/markets?vs_currency=$vsCurrency&order=market_cap_desc&per_page=$perPage&page=$page&sparkline=false',
    );

    try {
      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => CryptoCurrency.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load coins: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load coins: $e');
    }
  }

  Future<MarketChartData> getCoinMarketChart({
    required String id,
    String vsCurrency = 'usd',
    int days = 1,
  }) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}/coins/$id/market_chart?vs_currency=$vsCurrency&days=$days',
    );

    try {
      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return MarketChartData.fromJson(data);
      } else {
        throw Exception('Failed to load chart data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load chart data: $e');
    }
  }
}
