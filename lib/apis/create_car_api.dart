import 'package:dio/dio.dart';
import '../apis/base_api.dart';

class CarApis extends BaseUrl {
  Future<Response> createCar(Map<String, dynamic> data) async {
    try {
      final response = await dio.post('cars', data: data);
      return response; // Return the response for further handling
    } catch (e) {
      // Handle errors (e.g., network issues, server errors)
      throw Exception('Failed to create car: $e');
    }
  }
}
