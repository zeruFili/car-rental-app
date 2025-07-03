class Car {
  final String id; // This will be populated by the backend
  final String make;
  final String model;
  final String year;
  final String description;
  final String pricePerDay;
  final List<String> photos; // Only photos provided by the client

  Car({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.description,
    required this.pricePerDay,
    required this.photos,
  });

  // Factory method to create a Car from JSON
  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['_id'] ?? '', // Backend will provide this
      make: json['make'] ?? '',
      model: json['model'] ?? '',
      year: json['year'] ?? '',
      description: json['description'] ?? '',
      pricePerDay: json['pricePerDay'] ?? '',
      photos:
          List<String>.from(json['photos'] ?? []), // Convert to List<String>
    );
  }

  // Method to convert Car to JSON (excluding id, owner, and availability)
  Map<String, dynamic> toJson() {
    return {
      'make': make,
      'model': model,
      'year': year,
      'description': description,
      'pricePerDay': pricePerDay,
      'photos': photos,
    };
  }
}
