import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/place_model.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final List<PlaceModel> _places = [
    const PlaceModel(
      id: '1',
      name: 'Salsa Club Latina',
      address: 'Calle Main 123',
      type: 'discoteca',
      latitude: 40.4168,
      longitude: -3.7038,
      rating: 4.5,
      reviewsCount: 28,
      addedBy: 'user1',
      createdAt: null,
    ),
    const PlaceModel(
      id: '2',
      name: 'Academia de Baile Madrid',
      address: 'Plaza Centro 45',
      type: 'academia',
      latitude: 40.4170,
      longitude: -3.7040,
      rating: 4.8,
      reviewsCount: 56,
      addedBy: 'user2',
      createdAt: null,
    ),
    const PlaceModel(
      id: '3',
      name: 'Parque de la Danza',
      address: 'Avenida Parque s/n',
      type: 'espacio_publico',
      latitude: 40.4180,
      longitude: -3.7020,
      rating: 4.2,
      reviewsCount: 15,
      addedBy: 'user3',
      createdAt: null,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.places),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.md,
              vertical: AppDimensions.sm,
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('Todos', true),
                _buildFilterChip('Discotecas', false),
                _buildFilterChip('Academias', false),
                _buildFilterChip('Eventos', false),
                _buildFilterChip('Espacios', false),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  color: AppColors.surfaceLight,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map,
                          size: 64,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(height: AppDimensions.md),
                        Text(
                          'Mapa de lugares',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.xs),
                        Text(
                          'Configura Google Maps API para ver el mapa',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: AppDimensions.lg,
                  left: AppDimensions.md,
                  right: AppDimensions.md,
                  child: SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _places.length,
                      itemBuilder: (context, index) {
                        final place = _places[index];
                        return _PlaceCard(
                          place: place,
                          onTap: () => context.go('/map/place/${place.id}'),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/map/add'),
        child: const Icon(Icons.add_location),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool selected) {
    return Padding(
      padding: const EdgeInsets.only(right: AppDimensions.sm),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (s) {},
        selectedColor: AppColors.primary,
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: selected ? Colors.white : AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  final PlaceModel place;
  final VoidCallback onTap;

  const _PlaceCard({required this.place, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: AppDimensions.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.radiusMd),
                  bottomLeft: Radius.circular(AppDimensions.radiusMd),
                ),
              ),
              child: Icon(
                _getPlaceIcon(place.type),
                color: AppColors.primary,
                size: 32,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      place.name,
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppDimensions.xs),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: AppDimensions.xs),
                        Text(
                          '${place.rating}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          ' (${place.reviewsCount})',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.xs),
                    Text(
                      place.address,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPlaceIcon(String type) {
    switch (type) {
      case 'discoteca':
        return Icons.nightlife;
      case 'academia':
        return Icons.school;
      case 'evento':
        return Icons.event;
      case 'espacio_publico':
        return Icons.park;
      default:
        return Icons.place;
    }
  }
}
