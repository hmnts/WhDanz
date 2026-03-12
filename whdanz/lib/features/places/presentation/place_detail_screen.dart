import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';

class PlaceDetailScreen extends StatelessWidget {
  final String placeId;

  const PlaceDetailScreen({super.key, required this.placeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Salsa Club Latina'),
              background: Container(
                color: AppColors.surfaceLight,
                child: Icon(
                  Icons.nightlife,
                  size: 64,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: AppDimensions.xs),
                      Text(
                        '4.5',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        ' (28 reseñas)',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.md),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: AppColors.textMuted, size: 20),
                      const SizedBox(width: AppDimensions.xs),
                      Expanded(
                        child: Text(
                          'Calle Main 123, Madrid',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  Text(
                    'Descripción',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  Text(
                    'El mejor lugar para bailar salsa en Madrid. Ambiente increíble, clases de salsa los jueves y fiesta los fines de semana.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  Text(
                    'Información',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppDimensions.md),
                  _buildInfoRow(Icons.access_time, 'Jueves: Clases 20:00-22:00'),
                  _buildInfoRow(Icons.weekend, 'Viernes y Sábado: Fiesta 23:00-03:00'),
                  _buildInfoRow(Icons.music_note, 'Salsa, Bachata, Merengue'),
                  const SizedBox(height: AppDimensions.lg),
                  Text(
                    'Reseñas',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppDimensions.md),
                  _buildReview(context, 'Juan M.', '5', 'El mejor sitio de Madrid para bailar salsa'),
                  _buildReview(context, 'Maria L.', '4', 'Buen ambiente, pero suele estar muy lleno'),
                  const SizedBox(height: AppDimensions.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.xs),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: AppDimensions.sm),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildReview(BuildContext context, String name, String rating, String comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.md),
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: Theme.of(context).textTheme.titleSmall),
              Row(
                children: List.generate(5, (i) => Icon(
                  Icons.star,
                  size: 16,
                  color: i < int.parse(rating) ? Colors.amber : AppColors.textMuted,
                )),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(comment, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
