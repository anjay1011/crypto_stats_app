import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/models/crypto_currency.dart';
import '../providers/crypto_providers.dart';

class DetailScreen extends ConsumerWidget {
  final CryptoCurrency coin;

  const DetailScreen({super.key, required this.coin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final days = ref.watch(chartDurationProvider);
    final chartDataAsync = ref.watch(dynamicMarketChartProvider(coin.id));
    final isPositive = coin.priceChangePercentage24h >= 0;

    return Scaffold(
      appBar: AppBar(title: Text(coin.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${coin.currentPrice.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          isPositive
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                          color: isPositive ? Colors.green : Colors.red,
                        ),
                        Text(
                          '${coin.priceChangePercentage24h.toStringAsFixed(2)}%',
                          style: TextStyle(
                            color: isPositive ? Colors.green : Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Image.network(coin.image, width: 50, height: 50),
              ],
            ),
            const SizedBox(height: 24),

            // Time Range Toggle
            ToggleButtons(
              isSelected: [days == 1, days == 7],
              onPressed: (index) {
                final newDays = index == 0 ? 1 : 7;
                ref.read(chartDurationProvider.notifier).state = newDays;
              },
              borderRadius: BorderRadius.circular(8),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('24H'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('7D'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Chart
            SizedBox(
              height: 250,
              child: chartDataAsync.when(
                data: (data) => _PriceLineChart(
                  prices: data.prices,
                  isPositive: isPositive,
                  days: days,
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
            const SizedBox(height: 24),

            // Detailed Stats Grid
            _buildStatGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildStatCard(context, 'Market Cap',
            '\$${NumberFormat.compact().format(coin.marketCap)}'),
        _buildStatCard(context, 'Rank', '#${coin.marketCapRank}'),
        _buildStatCard(
            context, 'High 24h', '\$${coin.high24h.toStringAsFixed(2)}'),
        _buildStatCard(
            context, 'Low 24h', '\$${coin.low24h.toStringAsFixed(2)}'),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            const SizedBox(height: 4),
            Text(value,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class _PriceLineChart extends StatelessWidget {
  final List<List<double>> prices;
  final bool isPositive;
  final int days;

  const _PriceLineChart({
    required this.prices,
    required this.isPositive,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    // Determine Grid/Text colors based on Theme
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gridColor = isDark ? Colors.white10 : Colors.grey[300]!;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: gridColor,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                String text;
                if (days > 1) {
                  // For 7D or more, show Month/Day
                  text = DateFormat('MM/dd').format(date);
                } else {
                  // For 1D, show Time
                  text = DateFormat('HH:mm').format(date);
                }
                return Padding(
                   padding: const EdgeInsets.only(top: 8.0),
                   child: Text(text, style: TextStyle(color: Colors.grey, fontSize: 10)),
                );
              },
              reservedSize: 30,
              interval: (prices.last[0] - prices.first[0]) / 5, // ~5 labels
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60, // Increased size for full price
              getTitlesWidget: (value, meta) {
                  return Text(
                    // "till 2 decimal places"
                    NumberFormat.currency(symbol: '', decimalDigits: 2).format(value),
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                    textAlign: TextAlign.right,
                  );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: prices.first[0],
        maxX: prices.last[0],
        minY: prices.map((e) => e[1]).reduce((a, b) => a < b ? a : b),
        maxY: prices.map((e) => e[1]).reduce((a, b) => a > b ? a : b),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                // Format price to 2 decimal places
                final price = flSpot.y.toStringAsFixed(2);
                final date = DateTime.fromMillisecondsSinceEpoch(flSpot.x.toInt());
                final dateStr = DateFormat('MM/dd HH:mm').format(date);
                
                return LineTooltipItem(
                  '\$$price\n$dateStr',
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: prices.map((e) => FlSpot(e[0], e[1])).toList(),
            isCurved: true,
            color: isPositive ? Colors.green : Colors.red,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: (isPositive ? Colors.green : Colors.red).withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}
