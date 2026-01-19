class MatchResult {
  final String petId;
  final String petName;
  final double similarityScore; // 0-1
  final String? imageUrl;
  final String? breed;
  final String? location;
  final DateTime? lastSeen;
  final String? contactInfo;
  final Map<String, dynamic>? additionalData;

  MatchResult({
    required this.petId,
    required this.petName,
    required this.similarityScore,
    this.imageUrl,
    this.breed,
    this.location,
    this.lastSeen,
    this.contactInfo,
    this.additionalData,
  });

  bool get isHighMatch => similarityScore > 0.8;
  bool get isMediumMatch => similarityScore > 0.6 && similarityScore <= 0.8;
  bool get isLowMatch => similarityScore <= 0.6;

  int get matchPercentage => (similarityScore * 100).round();

  String get matchQuality {
    if (isHighMatch) return 'High Match';
    if (isMediumMatch) return 'Medium Match';
    return 'Low Match';
  }

  Map<String, dynamic> toJson() => {
        'petId': petId,
        'petName': petName,
        'similarityScore': similarityScore,
        'imageUrl': imageUrl,
        'breed': breed,
        'location': location,
        'lastSeen': lastSeen?.toIso8601String(),
        'contactInfo': contactInfo,
        'additionalData': additionalData,
      };

  factory MatchResult.fromJson(Map<String, dynamic> json) => MatchResult(
        petId: json['petId'] as String,
        petName: json['petName'] as String,
        similarityScore: json['similarityScore'] as double,
        imageUrl: json['imageUrl'] as String?,
        breed: json['breed'] as String?,
        location: json['location'] as String?,
        lastSeen: json['lastSeen'] != null
            ? DateTime.parse(json['lastSeen'] as String)
            : null,
        contactInfo: json['contactInfo'] as String?,
        additionalData: json['additionalData'] as Map<String, dynamic>?,
      );

  @override
  String toString() =>
      'MatchResult(pet: $petName, similarity: ${matchPercentage}%, quality: $matchQuality)';
}

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
  static double cosineSimilarity(
      List<double> vectorA, List<double> vectorB) {
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

    final denominator = (normA.sqrt() * normB.sqrt());
    if (denominator == 0) return 0.0;

    return dotProduct / denominator;
  }

  /// Calculate Euclidean distance between two feature vectors
  static double euclideanDistance(
      List<double> vectorA, List<double> vectorB) {
    if (vectorA.length != vectorB.length) {
      throw ArgumentError('Vectors must have the same length');
    }

    double sum = 0.0;
    for (int i = 0; i < vectorA.length; i++) {
      final diff = vectorA[i] - vectorB[i];
      sum += diff * diff;
    }

    return sum.sqrt();
  }

  double similarityTo(PetFeatureVector other) {
    return cosineSimilarity(features, other.features);
  }

  Map<String, dynamic> toJson() => {
        'petId': petId,
        'features': features,
        'extractedAt': extractedAt.toIso8601String(),
        'imageUrl': imageUrl,
      };

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
