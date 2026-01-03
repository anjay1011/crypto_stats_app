import '../../data/models/crypto_currency.dart';

abstract class CryptoRepository {
  Future<List<CryptoCurrency>> getCoins({int page = 1});
  Future<MarketChartData> getCoinChartData(String id, {int days = 1});
}


