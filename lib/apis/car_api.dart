import 'package:dio/dio.dart';
import '../apis/base_api.dart';

class CarApi extends BaseUrl {
  Future<Response> getAllCars() async {
    try {
      final response = await dio.get('cars'); // Adjust the endpoint as needed
      return response; // Return the response for further handling
    } catch (e) {
      throw Exception('Failed to fetch cars: $e');
    }
  }

  Future<Response> createCar(FormData data) async {
    // Change the parameter type to FormData
    try {
      final response = await dio.post('cars', data: data);
      return response; // Return the response for further handling
    } catch (e) {
      // Handle errors (e.g., network issues, server errors)
      throw Exception('Failed to create car: $e');
    }
  }
}
