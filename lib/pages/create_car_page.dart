import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:html' as html; // For web only
import '../controllers/get_car_controller.dart';
import './car_page.dart'; // Import the car rental page

class CreateCarPage extends StatefulWidget {
  const CreateCarPage({Key? key}) : super(key: key);

  @override
  _CreateCarPageState createState() => _CreateCarPageState();
}

class _CreateCarPageState extends State<CreateCarPage> {
  final _formKey = GlobalKey<FormState>();
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final CarController _carController = CarController();

  List<XFile> _pickedFiles = [];
  List<String> _webImagePaths = []; // For web previews
  bool _isLoading = false;

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    // Clean up web image URLs
    for (var url in _webImagePaths) {
      html.Url.revokeObjectUrl(url);
    }
    super.dispose();
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      setState(() {
        _pickedFiles = pickedFiles;
        if (kIsWeb) {
          // Generate web preview URLs
          _webImagePaths = [];
          for (var file in pickedFiles) {
            _generateWebImageUrl(file);
          }
        }
      });
    }
  }

  Future<void> _generateWebImageUrl(XFile file) async {
    final bytes = await file.readAsBytes();
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    setState(() {
      _webImagePaths.add(url);
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final scaffoldMessenger = ScaffoldMessenger.of(context);

      try {
        final success = await _carController.createCar(
          make: _makeController.text,
          model: _modelController.text,
          year: _yearController.text,
          pricePerDay: _priceController.text,
          description: _descriptionController.text,
          photos: _pickedFiles,
        );

        if (success) {
          // Clear the form
          _makeController.clear();
          _modelController.clear();
          _yearController.clear();
          _priceController.clear();
          _descriptionController.clear();
          setState(() {
            _pickedFiles = [];
            _webImagePaths = [];
          });

          // Redirect to CarRentalPage with a fresh state
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => CarRentalPage()),
            (Route<dynamic> route) => false,
          );
        } else {
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('Failed to create car listing'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Car Listing'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: _makeController,
                      label: 'Make',
                      hint: 'Enter car make',
                      icon: Icons.directions_car,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _modelController,
                      label: 'Model',
                      hint: 'Enter car model',
                      icon: Icons.car_repair,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _yearController,
                      label: 'Year',
                      hint: 'Enter manufacturing year',
                      icon: Icons.calendar_today,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _priceController,
                      label: 'Price per Day',
                      hint: 'Enter rental price',
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _descriptionController,
                      label: 'Description',
                      hint: 'Enter car description',
                      icon: Icons.description,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _pickImages,
                      child: const Text('Select Photos'),
                    ),
                    const SizedBox(height: 16),
                    _buildImagePreview(),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Create Listing'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildImagePreview() {
    if (_pickedFiles.isEmpty) {
      return const Text('No images selected');
    }

    if (kIsWeb) {
      return Wrap(
        spacing: 8.0,
        children: _webImagePaths
            .map((path) => Image.network(
                  path,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ))
            .toList(),
      );
    } else {
      return Wrap(
        spacing: 8.0,
        children: _pickedFiles
            .map((file) => Image.network(
                  file.path,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ))
            .toList(),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
