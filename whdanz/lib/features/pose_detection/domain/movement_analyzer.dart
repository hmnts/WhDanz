import 'dart:collection';
import '../domain/advanced_angle_calculator.dart';

class MovementAnalyzer {
  final Queue<Map<String, double>> _angleHistory = Queue();
  final int _historySize = 30;
  DateTime? _lastFrameTime;
  final List<double> _velocityHistory = [];

  void addFrame(Map<String, double> angles) {
    final now = DateTime.now();
    
    if (_lastFrameTime != null) {
      final deltaTime = now.difference(_lastFrameTime!).inMilliseconds / 1000.0;
      if (deltaTime > 0) {
        _calculateVelocity(angles, deltaTime);
      }
    }

    _angleHistory.add(angles);
    if (_angleHistory.length > _historySize) {
      _angleHistory.removeFirst();
    }
    
    _lastFrameTime = now;
  }

  void _calculateVelocity(Map<String, double> currentAngles, double deltaTime) {
    if (_angleHistory.isEmpty) return;

    final previousAngles = _angleHistory.last;
    double totalVelocity = 0;
    int jointCount = 0;

    for (final joint in currentAngles.keys) {
      if (previousAngles.containsKey(joint)) {
        final velocity = (currentAngles[joint]! - previousAngles[joint]!).abs() / deltaTime;
        totalVelocity += velocity;
        jointCount++;
      }
    }

    if (jointCount > 0) {
      _velocityHistory.add(totalVelocity / jointCount);
      if (_velocityHistory.length > 20) {
        _velocityHistory.removeAt(0);
      }
    }
  }

  double getFluencyScore() {
    if (_velocityHistory.length < 5) return 50;

    double variance = 0;
    final mean = _velocityHistory.reduce((a, b) => a + b) / _velocityHistory.length;

    for (final v in _velocityHistory) {
      variance += (v - mean) * (v - mean);
    }
    variance /= _velocityHistory.length;

    final stdDev = variance > 0 ? variance * 0.5 : 0.0;
    final fluency = (100 - (stdDev * 10)).clamp(0.0, 100.0);
    return fluency;
  }

  double getAverageVelocity() {
    if (_velocityHistory.isEmpty) return 0;
    return _velocityHistory.reduce((a, b) => a + b) / _velocityHistory.length;
  }

  double getConsistencyScore() {
    if (_angleHistory.length < 5) return 50;

    double consistencySum = 0;
    int comparisons = 0;

    final firstAngles = _angleHistory.first;
    final lastAngles = _angleHistory.last;

    for (final joint in firstAngles.keys) {
      if (lastAngles.containsKey(joint)) {
        final diff = (firstAngles[joint]! - lastAngles[joint]!).abs();
        consistencySum += (100 - diff).clamp(0, 100);
        comparisons++;
      }
    }

    return comparisons > 0 ? consistencySum / comparisons : 50;
  }

  MovementMetrics getMetrics() {
    return MovementMetrics(
      fluency: getFluencyScore(),
      averageVelocity: getAverageVelocity(),
      consistency: getConsistencyScore(),
      frameCount: _angleHistory.length,
    );
  }

  void reset() {
    _angleHistory.clear();
    _velocityHistory.clear();
    _lastFrameTime = null;
  }
}

class MovementMetrics {
  final double fluency;
  final double averageVelocity;
  final double consistency;
  final int frameCount;

  const MovementMetrics({
    required this.fluency,
    required this.averageVelocity,
    required this.consistency,
    required this.frameCount,
  });

  double get overallScore => (fluency + consistency) / 2;
}
