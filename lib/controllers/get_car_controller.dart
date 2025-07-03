import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:html' as html; // For web only
import '../apis/car_api.dart';
import '../Model/car_model.dart'; // Adjust the import based on your file structure

class CarController {
  List<Car> cars = []; // Change the type to List<Car>

  Future<bool> fetchCars() async {
    final carApi = CarApi();
    try {
      final response = await carApi.getAllCars();
      if (response.statusCode == 200) {
        cars = (response.data as List)
            .map((carJson) => Car.fromJson(carJson))
            .toList(); // Parse the car data
        return true;
      } else {
        print('Failed to fetch cars: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }

  Future<bool> createCar({
    required String make,
    required String model,
    required String year,
    required String pricePerDay,
    required String description,
    required List<XFile> photos,
  }) async {
    try {
      final formData = FormData();

      final CarApi _carApi = CarApi();

      // Add car data fields
      formData.fields.addAll([
        MapEntry('make', make),
        MapEntry('model', model),
        MapEntry('year', year),
        MapEntry('pricePerDay', pricePerDay),
        MapEntry('description', description),
      ]);

      // Add photos to FormData
      for (var photo in photos) {
        if (kIsWeb) {
          // Web handling
          final bytes = await photo.readAsBytes();
          formData.files.add(MapEntry(
            'myImages',
            MultipartFile.fromBytes(
              bytes,
              filename: photo.name,
            ),
          ));
        } else {
          // Mobile handling
          formData.files.add(MapEntry(
            'myImages',
            await MultipartFile.fromFile(photo.path),
          ));
        }
      }

      final response = await _carApi.createCar(formData);
      return response.statusCode == 201;
    } catch (e) {
      print('Error during car creation: $e');
      return false;
    }
  }
}
