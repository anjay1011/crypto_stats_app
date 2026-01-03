import '../../data/datasources/api_service.dart';
import '../../data/models/crypto_currency.dart';
import '../../domain/repositories/crypto_repository.dart';

class CryptoRepositoryImpl implements CryptoRepository {
  final ApiService apiService;

  CryptoRepositoryImpl(this.apiService);

  @override
  Future<List<CryptoCurrency>> getCoins({int page = 1}) {
    return apiService.getMarkets(page: page);
  }

  @override
  Future<MarketChartData> getCoinChartData(String id, {int days = 1}) {
    return apiService.getCoinMarketChart(id: id, days: days);
  }
}
