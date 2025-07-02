class Car {
  final String id;
  final String make;
  final String model;
  final String year;
  final String description;
  final String pricePerDay;
  final String availability;
  final String owner;
  final List<String> photos;

  Car({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.description,
    required this.pricePerDay,
    required this.availability,
    required this.owner,
    required this.photos,
  });

  // Factory method to create a Car from JSON
  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['_id'] ?? '',
      make: json['make'] ?? '',
      model: json['model'] ?? '',
      year: json['year'] ?? '',
      description: json['description'] ?? '',
      pricePerDay: json['pricePerDay'] ?? '',
      availability: json['availability'] ?? '',
      owner: json['owner'] ?? '',
      photos:
          List<String>.from(json['photos'] ?? []), // Convert to List<String>
    );
  }

  // Method to convert Car to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'make': make,
      'model': model,
      'year': year,
      'description': description,
      'pricePerDay': pricePerDay,
      'availability': availability,
      'owner': owner,
      'photos': photos,
    };
  }
}
