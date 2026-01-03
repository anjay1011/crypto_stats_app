import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../data/datasources/api_service.dart';
import '../../data/repositories/crypto_repository_impl.dart';
import '../../domain/repositories/crypto_repository.dart';
import '../../data/models/crypto_currency.dart';

// Service & Repository Providers
final httpClientProvider = Provider<http.Client>((ref) => http.Client());

final apiServiceProvider = Provider<ApiService>((ref) {
  final client = ref.watch(httpClientProvider);
  return ApiService(client: client);
});

final cryptoRepositoryProvider = Provider<CryptoRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return CryptoRepositoryImpl(apiService);
});

// Enums
enum SortOption {
  marketCapDesc,
  marketCapAsc,
  priceDesc,
  priceAsc,
  changeDesc,
  changeAsc,
}

// State Providers for Search & Sort
// Notifiers for Search & Sort
class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';
  
  @override
  set state(String value) => super.state = value;
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

class SortOptionNotifier extends Notifier<SortOption> {
  @override
  SortOption build() => SortOption.marketCapDesc;

  void toggle(SortOption option) {
    if (state == option) {
      state = SortOption.marketCapDesc; // Reset to default
    } else {
      state = option;
    }
  }

  @override
  set state(SortOption value) => super.state = value;
}

final sortOptionProvider = NotifierProvider<SortOptionNotifier, SortOption>(SortOptionNotifier.new);

// Main Data Provider (Async)
final cryptoListProvider = FutureProvider<List<CryptoCurrency>>((ref) async {
  final repository = ref.watch(cryptoRepositoryProvider);
  return repository.getCoins();
});

// Computed Provider for Filtering & Sorting
final filteredCryptoListProvider = Provider<AsyncValue<List<CryptoCurrency>>>((ref) {
  final cryptoListAsync = ref.watch(cryptoListProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
  final sortOption = ref.watch(sortOptionProvider);

  return cryptoListAsync.whenData((list) {
    // 1. Filter
    var filtered = list.where((coin) {
      return coin.name.toLowerCase().contains(searchQuery) ||
          coin.symbol.toLowerCase().contains(searchQuery);
    }).toList();

    // 2. Sort
    switch (sortOption) {
      case SortOption.priceDesc:
        filtered.sort((a, b) => b.currentPrice.compareTo(a.currentPrice));
        break;
      case SortOption.priceAsc:
        filtered.sort((a, b) => a.currentPrice.compareTo(b.currentPrice));
        break;
      case SortOption.changeDesc:
        filtered.sort((a, b) => b.priceChangePercentage24h.compareTo(a.priceChangePercentage24h));
        break;
      case SortOption.changeAsc:
        filtered.sort((a, b) => a.priceChangePercentage24h.compareTo(b.priceChangePercentage24h));
        break;
      case SortOption.marketCapAsc:
        filtered.sort((a, b) => a.marketCap.compareTo(b.marketCap));
        break;
      case SortOption.marketCapDesc:
        filtered.sort((a, b) => b.marketCap.compareTo(a.marketCap));
        break;
      default:
        // Fallback
        filtered.sort((a, b) => b.marketCap.compareTo(a.marketCap));
        break;
    }

    return filtered;
  });
});

// Market Chart Provider (Family)
final marketChartProvider = FutureProvider.family<MarketChartData, String>((ref, id) async {
  final repository = ref.watch(cryptoRepositoryProvider);
  // Default to 1 day for initial load, can extend to support params if needed
  // Or create a separate StateProvider for chart duration if UI toggles it.
  return repository.getCoinChartData(id, days: 1); // defaulting to 1 day
});

class ChartDurationNotifier extends Notifier<int> {
  @override
  int build() => 1;

  @override
  set state(int value) => super.state = value;
}

final chartDurationProvider = NotifierProvider<ChartDurationNotifier, int>(ChartDurationNotifier.new);

final dynamicMarketChartProvider = FutureProvider.family<MarketChartData, String>((ref, id) async {
  final repository = ref.watch(cryptoRepositoryProvider);
  final days = ref.watch(chartDurationProvider);
  return repository.getCoinChartData(id, days: days);
});
