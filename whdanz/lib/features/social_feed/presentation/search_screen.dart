import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whdanz/core/constants/app_constants.dart';
import 'package:whdanz/core/theme/app_theme.dart';
import 'package:whdanz/core/widgets/modern_widgets.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  String _searchType = 'all';
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background,
              AppColors.backgroundSecondary,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildFilterChips(),
              Expanded(
                child: _searchQuery.isEmpty
                    ? _buildInitialState()
                    : _buildResults(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.md),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 20),
              onPressed: () => context.pop(),
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          ShaderMask(
            shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
            child: Text(
              'Buscar',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(
            color: AppColors.surfaceLight.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _searchQuery = value),
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Buscar bailarines, lugares, posts...',
            hintStyle: TextStyle(color: AppColors.textMuted),
            prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: AppColors.textMuted),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.md,
              vertical: AppDimensions.md,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = [
      {'label': 'Todo', 'value': 'all', 'icon': Icons.apps},
      {'label': 'Usuarios', 'value': 'users', 'icon': Icons.person},
      {'label': 'Lugares', 'value': 'places', 'icon': Icons.place},
      {'label': 'Videos', 'value': 'posts', 'icon': Icons.videocam},
    ];

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(AppDimensions.md),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _searchType == filter['value'];
          return Padding(
            padding: const EdgeInsets.only(right: AppDimensions.sm),
            child: ModernChip(
              label: filter['label'] as String,
              icon: filter['icon'] as IconData,
              isSelected: isSelected,
              onTap: () => setState(() => _searchType = filter['value'] as String),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInitialState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Bailarines trending'),
          const SizedBox(height: AppDimensions.sm),
          _buildTrendingUsers(),
          const SizedBox(height: AppDimensions.lg),
          _buildSectionTitle('Lugares populares'),
          const SizedBox(height: AppDimensions.sm),
          _buildTrendingPlaces(),
          const SizedBox(height: AppDimensions.lg),
          _buildSectionTitle('Últimas prácticas'),
          const SizedBox(height: AppDimensions.sm),
          _buildRecentPosts(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTrendingUsers() {
    final users = [
      {'name': 'Maria Dance', 'handle': '@mariadance', 'followers': '12.5K'},
      {'name': 'Juan Baila', 'handle': '@juanbaila', 'followers': '8.2K'},
      {'name': 'Sofia KPop', 'handle': '@sofiakpop', 'followers': '25K'},
      {'name': 'Alex HipHop', 'handle': '@alexhiphop', 'followers': '5.1K'},
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return _TrendingUserCard(
            name: user['name']!,
            handle: user['handle']!,
            followers: user['followers']!,
          );
        },
      ),
    );
  }

  Widget _buildTrendingPlaces() {
    final places = [
      {'name': 'Salsa Club Latina', 'rating': '4.5'},
      {'name': 'Academia Madrid', 'rating': '4.8'},
      {'name': 'Parque Danza', 'rating': '4.2'},
    ];

    return Column(
      children: places.map((place) {
        return _TrendingPlaceTile(
          name: place['name']!,
          rating: place['rating']!,
        );
      }).toList(),
    );
  }

  Widget _buildRecentPosts() {
    final posts = [
      {'user': 'Maria Dance', 'caption': 'Practicando salsa...', 'score': '85%'},
      {'user': 'Juan Baila', 'caption': 'Nuevo récord en bachata', 'score': '92%'},
    ];

    return Column(
      children: posts.map((post) {
        return _RecentPostTile(
          user: post['user']!,
          caption: post['caption']!,
          score: post['score']!,
        );
      }).toList(),
    );
  }

  Widget _buildResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: AppDimensions.md),
          Text(
            'No se encontraron resultados',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            'Intenta con otros términos',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _TrendingUserCard extends StatelessWidget {
  final String name;
  final String handle;
  final String followers;

  const _TrendingUserCard({
    required this.name,
    required this.handle,
    required this.followers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: AppDimensions.sm),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: AppColors.surfaceLight.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                name[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            name,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          Text(
            followers,
            style: TextStyle(fontSize: 10, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _TrendingPlaceTile extends StatelessWidget {
  final String name;
  final String rating;

  const _TrendingPlaceTile({
    required this.name,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.sm),
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: AppColors.surfaceLight.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: Icon(Icons.place, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text(rating, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecentPostTile extends StatelessWidget {
  final String user;
  final String caption;
  final String score;

  const _RecentPostTile({
    required this.user,
    required this.caption,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.sm),
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: AppColors.surfaceLight.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppColors.secondaryGradient,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                Text(caption, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: Text(score, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
