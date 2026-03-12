import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/post_model.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = _getMockPosts();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.go('/notifications'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: AppDimensions.xxl),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return _PostCard(post: post);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/feed/create'),
        child: const Icon(Icons.add),
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

class _PostCard extends StatelessWidget {
  final PostModel post;

  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Text(
                post.userName[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(post.userName),
            subtitle: Text(_formatTimeAgo(post.createdAt)),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ),
          Container(
            height: 200,
            width: double.infinity,
            color: AppColors.surfaceLight,
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.play_circle_outline,
                    size: 64,
                    color: AppColors.textMuted,
                  ),
                ),
                if (post.poseScore != null)
                  Positioned(
                    top: AppDimensions.sm,
                    right: AppDimensions.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.sm,
                        vertical: AppDimensions.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.poseCorrect,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                      ),
                      child: Text(
                        '${post.poseScore!.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        post.isLiked ? Icons.favorite : Icons.favorite_border,
                        color: post.isLiked ? AppColors.error : null,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.chat_bubble_outline),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.share_outlined),
                      onPressed: () {},
                    ),
                  ],
                ),
                Text(
                  '${post.likesCount} me gusta',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppDimensions.xs),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: post.userName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' ${post.caption}'),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  'Ver los ${post.commentsCount} comentarios',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 0) return 'hace ${diff.inDays}d';
    if (diff.inHours > 0) return 'hace ${diff.inHours}h';
    if (diff.inMinutes > 0) return 'hace ${diff.inMinutes}m';
    return 'hace un momento';
  }
}
