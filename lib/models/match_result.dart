import 'dart:math';

/// Represents a match result when comparing pets
class MatchResult {
  final String petId;
  final String petName;
  final double similarityScore;
  final String? imageUrl;

  MatchResult({
    required this.petId,
    required this.petName,
    required this.similarityScore,
    this.imageUrl,
  });

  @override
  String toString() {
    return 'MatchResult(petId: $petId, petName: $petName, score: ${(similarityScore * 100).toStringAsFixed(1)}%)';
  }
}

/// Represents a feature vector extracted from a pet image
class PetFeatureVector {
  final String petId;
  final List<double> features;
  final DateTime extractedAt;
  final String? imageUrl;

  PetFeatureVector({
    required this.petId,
    required this.features,
    DateTime? extractedAt,
    this.imageUrl,
  }) : extractedAt = extractedAt ?? DateTime.now();

  /// Calculate cosine similarity between two feature vectors
  static double cosineSimilarity(List<double> vectorA, List<double> vectorB) {
    if (vectorA.length != vectorB.length) {
      throw ArgumentError('Vectors must have the same length');
    }

    double dotProduct = 0.0;
    double normA = 0.0;
    double normB = 0.0;

    for (int i = 0; i < vectorA.length; i++) {
      dotProduct += vectorA[i] * vectorB[i];
      normA += vectorA[i] * vectorA[i];
      normB += vectorB[i] * vectorB[i];
    }

    final denominator = (sqrt(normA) * sqrt(normB));
    if (denominator == 0) return 0.0;

    return dotProduct / denominator;
  }

  /// Calculate Euclidean distance between two feature vectors
  static double euclideanDistance(List<double> vectorA, List<double> vectorB) {
    if (vectorA.length != vectorB.length) {
      throw ArgumentError('Vectors must have the same length');
    }

    double sum = 0.0;
    for (int i = 0; i < vectorA.length; i++) {
      final diff = vectorA[i] - vectorB[i];
      sum += diff * diff;
    }

    return sqrt(sum);
  }

  /// Calculate similarity to another feature vector
  double similarityTo(PetFeatureVector other) {
    return cosineSimilarity(features, other.features);
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() => {
        'petId': petId,
        'features': features,
        'extractedAt': extractedAt.toIso8601String(),
        'imageUrl': imageUrl,
      };

  /// Create from JSON map
  factory PetFeatureVector.fromJson(Map<String, dynamic> json) =>
      PetFeatureVector(
        petId: json['petId'] as String,
        features: (json['features'] as List<dynamic>)
            .map((f) => f as double)
            .toList(),
        extractedAt: DateTime.parse(json['extractedAt'] as String),
        imageUrl: json['imageUrl'] as String?,
      );
}
