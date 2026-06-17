import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/presentation/app_notifiers.dart';
import '../../core/utils/constants.dart';
import '../../widgets/creator_card_widget.dart';
import '../../widgets/filter_bottom_sheet.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/niche_chip_widget.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});
  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  String _selectedNiche = 'All';
  String _searchQuery = '';
  Map<String, String> _filters = {
    'niche': 'All',
    'platform': 'All',
    'country': 'All Countries',
    'language': 'English',
    'followers': 'All',
    'activity': 'All',
  };
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List creatorsFiltered() {
    final creators = ref.read(authNotifierProvider.notifier).suggestedCreators;
    return creators.where((creator) {
      final matchesSearch = _searchQuery.isEmpty ||
          creator.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          creator.username.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          creator.niche.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesNiche =
          _filters['niche'] == 'All' || creator.niche == _filters['niche'];
      final matchesPlatform = _filters['platform'] == 'All' ||
          creator.platforms.contains(_filters['platform']);
      final matchesSelectNiche =
          _selectedNiche == 'All' || creator.niche == _selectedNiche;
      return matchesSearch &&
          matchesNiche &&
          matchesPlatform &&
          matchesSelectNiche;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final creators = creatorsFiltered();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              final result = await FilterBottomSheet.open(context, _filters);
              if (result != null) setState(() => _filters = result);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBarWidget(
              controller: _searchController,
              placeholder: 'Search Creators, Communities, Niches',
              onChanged: (value) => setState(() => _searchQuery = value),
              onTapFilter: () async {
                final result = await FilterBottomSheet.open(context, _filters);
                if (result != null) setState(() => _filters = result);
              },
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              children: [
                NicheChipWidget(
                  label: 'All',
                  selected: _selectedNiche == 'All',
                  onTap: () => setState(() => _selectedNiche = 'All'),
                ),
                ...AppConstants.niches.take(8).map(
                      (niche) => Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: NicheChipWidget(
                          label: niche,
                          selected: _selectedNiche == niche,
                          onTap: () => setState(() => _selectedNiche = niche),
                        ),
                      ),
                    ),
              ],
            ),
          ),
          Expanded(
            child: creators.isEmpty
                ? const Center(child: Text('No creators found'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: creators.length,
                    itemBuilder: (ctx, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CreatorCardWidget(creator: creators[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
