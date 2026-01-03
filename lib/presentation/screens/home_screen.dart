import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/crypto_providers.dart';
import '../providers/theme_provider.dart';
import '../widgets/crypto_list_item.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch providers
    final cryptoListAsync = ref.watch(filteredCryptoListProvider);
    final themeModeNotifier = ref.read(themeModeProvider.notifier);
    final currentTheme = ref.watch(themeModeProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: const Text('Crypto Stats'),
            actions: [
              IconButton(
                icon: Icon(
                  currentTheme == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: () {
                  themeModeNotifier.toggleTheme();
                },
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  onChanged: (value) {
                    ref.read(searchQueryProvider.notifier).state = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Search coins...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                   _SortChip(label: 'Price High', option: SortOption.priceDesc),
                   _SortChip(label: 'Price Low', option: SortOption.priceAsc),
                   _SortChip(label: 'Profit 24h', option: SortOption.changeDesc),
                   _SortChip(label: 'Loss 24h', option: SortOption.changeAsc),
                ],
              ),
            ),
          ),
          cryptoListAsync.when(
            data: (cryptos) {
              if (cryptos.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text('No coins found')),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final coin = cryptos[index];
                      return CryptoListItem(coin: coin);
                    },
                    childCount: cryptos.length,
                  ),
                ),
              );
            },
            loading: () => SliverFillRemaining(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: ListView.builder(
                  itemCount: 10,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) => Container(
                    height: 80,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     const Icon(Icons.error_outline, size: 48, color: Colors.red),
                     const SizedBox(height: 16),
                     Text('Error loading data: $err', textAlign: TextAlign.center),
                     const SizedBox(height: 16),
                     ElevatedButton(
                       onPressed: () {
                          // Invalidate provider to retry
                          ref.invalidate(cryptoListProvider);
                       }, 
                       child: const Text('Retry'),
                     )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SortChip extends ConsumerWidget {
  final String label;
  final SortOption option;

  const _SortChip({required this.label, required this.option});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSort = ref.watch(sortOptionProvider);
    final isSelected = currentSort == option;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          ref.read(sortOptionProvider.notifier).toggle(option);
        },
        checkmarkColor: Colors.white,
        selectedColor: Theme.of(context).primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ),
    );
  }
}
