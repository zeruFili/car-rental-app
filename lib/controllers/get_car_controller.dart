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
}
