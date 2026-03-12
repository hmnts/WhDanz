import 'package:cloud_firestore/cloud_firestore.dart';

class PoseReference {
  final String id;
  final String name;
  final String style;
  final String difficulty;
  final List<Map<String, dynamic>> frames;

  const PoseReference({
    required this.id,
    required this.name,
    required this.style,
    required this.difficulty,
    required this.frames,
  });

  factory PoseReference.fromJson(Map<String, dynamic> json) {
    return PoseReference(
      id: json['id'] as String,
      name: json['name'] as String,
      style: json['style'] as String,
      difficulty: json['difficulty'] as String,
      frames: (json['frames'] as List?)?.map((e) => Map<String, dynamic>.from(e as Map)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'style': style,
      'difficulty': difficulty,
      'frames': frames,
    };
  }
}

class PoseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<PoseReference>> getAllPoses() async {
    try {
      final snapshot = await _firestore.collection('reference_poses').get();
      return snapshot.docs.map((doc) => PoseReference.fromJson(doc.data())).toList();
    } catch (e) {
      return _getDefaultPoses();
    }
  }

  Future<List<PoseReference>> getPosesByStyle(String style) async {
    try {
      final snapshot = await _firestore.collection('reference_poses')
          .where('style', isEqualTo: style)
          .get();
      return snapshot.docs.map((doc) => PoseReference.fromJson(doc.data())).toList();
    } catch (e) {
      return _getDefaultPoses().where((p) => p.style == style).toList();
    }
  }

  Future<PoseReference?> getPoseById(String id) async {
    try {
      final doc = await _firestore.collection('reference_poses').doc(id).get();
      if (doc.exists) {
        return PoseReference.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      return _getDefaultPoses().firstWhere((p) => p.id == id, orElse: () => _getDefaultPoses().first);
    }
  }

  List<PoseReference> _getDefaultPoses() {
    return [
      const PoseReference(
        id: 'salsa_paso_basico',
        name: 'Salsa - Paso básico',
        style: 'salsa',
        difficulty: 'principiante',
        frames: [],
      ),
      const PoseReference(
        id: 'bachata_basic',
        name: 'Bachata - Basic Step',
        style: 'bachata',
        difficulty: 'principiante',
        frames: [],
      ),
      const PoseReference(
        id: 'reggaeton_perreo',
        name: 'Reggaetón - Perreo',
        style: 'reggaeton',
        difficulty: 'intermedio',
        frames: [],
      ),
      const PoseReference(
        id: 'kpop_basic',
        name: 'K-Pop - Coreografía',
        style: 'kpop',
        difficulty: 'avanzado',
        frames: [],
      ),
      const PoseReference(
        id: 'hiphop_basic',
        name: 'Hip Hop - Basics',
        style: 'hiphop',
        difficulty: 'principiante',
        frames: [],
      ),
      const PoseReference(
        id: 'salsa_turn',
        name: 'Salsa - Giro',
        style: 'salsa',
        difficulty: 'intermedio',
        frames: [],
      ),
    ];
  }
}
