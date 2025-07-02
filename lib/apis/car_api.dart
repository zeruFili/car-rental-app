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
}
