import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceModel {
  final String id;
  final String name;
  final String address;
  final String? description;
  final String type;
  final double latitude;
  final double longitude;
  final String? imageURL;
  final double rating;
  final int reviewsCount;
  final String addedBy;
  final DateTime createdAt;

  const PlaceModel({
    required this.id,
    required this.name,
    required this.address,
    this.description,
    required this.type,
    required this.latitude,
    required this.longitude,
    this.imageURL,
    this.rating = 0,
    this.reviewsCount = 0,
    required this.addedBy,
    required this.createdAt,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      description: json['description'] as String?,
      type: json['type'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      imageURL: json['imageURL'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      reviewsCount: json['reviewsCount'] as int? ?? 0,
      addedBy: json['addedBy'] as String,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'description': description,
      'type': type,
      'latitude': latitude,
      'longitude': longitude,
      'imageURL': imageURL,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'addedBy': addedBy,
      'createdAt': createdAt,
    };
  }
}
