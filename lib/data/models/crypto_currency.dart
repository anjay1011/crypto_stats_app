class CryptoCurrency {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final double currentPrice;
  final double marketCap;
  final int marketCapRank;
  final double priceChangePercentage24h;
  final double high24h;
  final double low24h;

  CryptoCurrency({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.marketCapRank,
    required this.priceChangePercentage24h,
    required this.high24h,
    required this.low24h,
  });

  factory CryptoCurrency.fromJson(Map<String, dynamic> json) {
    return CryptoCurrency(
      id: json['id'] ?? '',
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      currentPrice: (json['current_price'] as num?)?.toDouble() ?? 0.0,
      marketCap: (json['market_cap'] as num?)?.toDouble() ?? 0.0,
      marketCapRank: (json['market_cap_rank'] as num?)?.toInt() ?? 0,
      priceChangePercentage24h:
          (json['price_change_percentage_24h'] as num?)?.toDouble() ?? 0.0,
      high24h: (json['high_24h'] as num?)?.toDouble() ?? 0.0,
      low24h: (json['low_24h'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class MarketChartData {
  final List<List<double>> prices;

  MarketChartData({required this.prices});

  factory MarketChartData.fromJson(Map<String, dynamic> json) {
    var pricesList = <List<double>>[];
    if (json['prices'] != null) {
      json['prices'].forEach((v) {
        if (v is List) {
          pricesList.add(v.map((e) => (e as num).toDouble()).toList());
        }
      });
    }
    return MarketChartData(prices: pricesList);
  }
}
