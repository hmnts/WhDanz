import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whdanz/core/constants/app_constants.dart';
import 'package:whdanz/features/social_feed/domain/post_model.dart';
import 'package:whdanz/core/theme/app_theme.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = _getMockPosts();

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
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            _buildStoriesBar(context),
            SliverPadding(
              padding: const EdgeInsets.only(bottom: AppDimensions.xxl),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _PostCard(
                    post: posts[index],
                    index: index,
                  ),
                  childCount: posts.length,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      backgroundColor: AppColors.background.withValues(alpha: 0.9),
      title: ShaderMask(
        shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
        child: const Text(
          AppStrings.appName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      actions: [
        _buildIconButton(
          icon: Icons.search,
          onPressed: () => context.go('/search'),
        ),
        _buildIconButton(
          icon: Icons.favorite_border,
          onPressed: () => context.go('/notifications'),
        ),
        _buildIconButton(
          icon: Icons.send,
          onPressed: () => context.push('/feed/messages'),
        ),
        const SizedBox(width: AppDimensions.sm),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: IconButton(
        icon: Icon(icon, size: 22),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildStoriesBar(BuildContext context) {
    final stories = [
      {'name': 'Tu historia', 'isOwn': true},
      {'name': 'Maria', 'isOwn': false},
      {'name': 'Juan', 'isOwn': false},
      {'name': 'Sofia', 'isOwn': false},
      {'name': 'Carlos', 'isOwn': false},
      {'name': 'Ana', 'isOwn': false},
    ];

    return SliverToBoxAdapter(
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(vertical: AppDimensions.sm),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
          itemCount: stories.length,
          itemBuilder: (context, index) {
            final story = stories[index];
            final isOwn = story['isOwn'] as bool;
            final name = story['name'] as String;

            return GestureDetector(
              onTap: () {
                if (isOwn) {
                  context.push('/feed/stories/create');
                } else {
                  context.push('/feed/stories/view/$index');
                }
              },
              child: Container(
                width: 70,
                margin: const EdgeInsets.only(right: AppDimensions.sm),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: isOwn
                            ? AppColors.primaryGradient
                            : LinearGradient(
                                colors: [
                                  AppColors.surfaceLight,
                                  AppColors.surfaceElevated,
                                ],
                              ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isOwn
                              ? Colors.transparent
                              : AppColors.surface,
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: isOwn
                            ? const Icon(Icons.add, color: Colors.white, size: 28)
                            : Text(
                                name[0].toUpperCase(),
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: AppShadows.glow,
      ),
      child: FloatingActionButton(
        onPressed: () => context.go('/feed/create'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  List<PostModel> _getMockPosts() {
    return [
      PostModel(
        id: '1',
        userId: 'user1',
        userName: 'Maria Dance',
        caption: 'Practiqué el paso básico de salsa toda la mañana 🕺💃',
        poseScore: 85,
        likesCount: 42,
        commentsCount: 5,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      PostModel(
        id: '2',
        userId: 'user2',
        userName: 'Juan Baila',
        caption: 'Nuevo récord en mi práctica de Bachata!',
        poseScore: 92,
        likesCount: 78,
        commentsCount: 12,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      PostModel(
        id: '3',
        userId: 'user3',
        userName: 'Sofia KPop',
        caption: 'Aprendiendo esta coreografía increíble',
        poseScore: 73,
        likesCount: 156,
        commentsCount: 23,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }
}

class _PostCard extends StatefulWidget {
  final PostModel post;
  final int index;

  const _PostCard({required this.post, required this.index});

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    Future.delayed(Duration(milliseconds: widget.index * 150), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppDimensions.md,
            vertical: AppDimensions.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(
              color: AppColors.surfaceLight.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildMedia(),
              _buildActions(),
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.xs,
      ),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.secondary,
            ],
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Center(
          child: Text(
            widget.post.userName[0].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
      title: Text(
        widget.post.userName,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        _formatTimeAgo(widget.post.createdAt),
        style: TextStyle(
          color: AppColors.textMuted,
          fontSize: 12,
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        child: const Icon(Icons.more_horiz, size: 20),
      ),
    );
  }

  Widget _buildMedia() {
    return Container(
      height: 220,
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        gradient: LinearGradient(
          colors: [
            AppColors.surfaceLight,
            AppColors.surfaceElevated,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                size: 50,
                color: AppColors.primary,
              ),
            ),
          ),
          if (widget.post.poseScore != null)
            Positioned(
              top: AppDimensions.sm,
              right: AppDimensions.sm,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.sm,
                  vertical: AppDimensions.xs,
                ),
                decoration: BoxDecoration(
                  gradient: _getScoreGradient(widget.post.poseScore!),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  boxShadow: [
                    BoxShadow(
                      color: _getScoreColor(widget.post.poseScore!).withValues(alpha: 0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getScoreIcon(widget.post.poseScore!),
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.post.poseScore!.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.sm),
      child: Row(
        children: [
          _ActionButton(
            icon: _isLiked ? Icons.favorite : Icons.favorite_border,
            iconColor: _isLiked ? AppColors.error : null,
            label: widget.post.likesCount.toString(),
            onTap: () {
              setState(() => _isLiked = !_isLiked);
            },
          ),
          _ActionButton(
            icon: Icons.chat_bubble_outline,
            label: widget.post.commentsCount.toString(),
            onTap: () {},
          ),
          _ActionButton(
            icon: Icons.share_outlined,
            label: 'Compartir',
            onTap: () {},
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.only(right: AppDimensions.md),
            child: Icon(
              Icons.bookmark_border,
              color: AppColors.textMuted,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.md,
        0,
        AppDimensions.md,
        AppDimensions.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: widget.post.userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextSpan(
                  text: ' ${widget.post.caption}',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            'Ver los ${widget.post.commentsCount} comentarios',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _getScoreGradient(double score) {
    if (score >= 80) return AppColors.primaryGradient;
    if (score >= 60) {
      return const LinearGradient(
        colors: [AppColors.warning, Color(0xFFFBBF24)],
      );
    }
    return const LinearGradient(
      colors: [AppColors.error, Color(0xFFF87171)],
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return AppColors.primary;
    if (score >= 60) return AppColors.warning;
    return AppColors.error;
  }

  IconData _getScoreIcon(double score) {
    if (score >= 80) return Icons.star;
    if (score >= 60) return Icons.thumb_up;
    return Icons.trending_up;
  }

  String _formatTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 0) return 'hace ${diff.inDays}d';
    if (diff.inHours > 0) return 'hace ${diff.inHours}h';
    if (diff.inMinutes > 0) return 'hace ${diff.inMinutes}m';
    return 'hace un momento';
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    this.iconColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.sm,
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: iconColor ?? AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
