import 'package:flutter/material.dart';
import '../controllers/get_car_controller.dart';
import '../Model/car_model.dart';
import 'package:get/get.dart';
import '../utils/api_endpoints.dart';

class CarRentalPage extends StatefulWidget {
  const CarRentalPage({super.key});

  @override
  _CarRentalPageState createState() => _CarRentalPageState();
}

class _CarRentalPageState extends State<CarRentalPage> {
  final CarController carController = CarController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedBrand = 'All';
  bool _isLoading = true;

  // Brand data with their respective filter values
  final List<Map<String, String>> brands = [
    {'name': 'All', 'image': 'assets/brands/all.png'},
    {'name': 'BYD', 'image': 'assets/brands/byd.png'},
    {'name': 'Toyota', 'image': 'assets/brands/toyota.png'},
    {'name': 'SUZUKI', 'image': 'assets/brands/suzuki.png'},
    {'name': 'Audi', 'image': 'assets/brands/audi.png'},
    {'name': 'Tesla', 'image': 'assets/brands/tesla.png'},
    {'name': 'BMW', 'image': 'assets/brands/bmw.png'},
    {'name': 'Mercedes', 'image': 'assets/brands/mercedes.png'},
  ];

  @override
  void initState() {
    super.initState();
    _loadCars();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  Future<void> _loadCars() async {
    setState(() {
      _isLoading = true;
    });
    await carController.fetchCars();
    setState(() {
      _isLoading = false;
    });
  }

  void _onBrandSelected(String brand) {
    setState(() {
      _selectedBrand = brand;
    });
  }

  void _showCarImages(Car car) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CarImageGallery(car: car),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredCars = carController.cars.where((car) {
      final fullName = '${car.make} ${car.model}'.toLowerCase();
      final matchesSearch = fullName.contains(_searchQuery);
      final matchesBrand = _selectedBrand == 'All' ||
          car.make.toLowerCase() == _selectedBrand.toLowerCase();
      return matchesSearch && matchesBrand;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildBrandSection(),
          _buildSectionTitle('Top Rated Cars'),
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : carController.cars.isEmpty
                    ? _buildEmptyState()
                    : _buildCarsList(filteredCars),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        'Rent Car anytime',
        style: TextStyle(
          color: Color(0xFF2D3748),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          offset: const Offset(0, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          color: const Color(0xFFF8F9FA), // Match page background
          child: Container(
            margin: const EdgeInsets.all(8),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFF0A5D4A),
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              enabled: false,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sign In Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Get.toNamed(ApiEndPoints.loginEmail);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF0A5D4A),
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFF0A5D4A)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Get.toNamed(ApiEndPoints.registerEmail);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A5D4A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search any car...',
          hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF)),
          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF0A5D4A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.tune, color: Colors.white),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF0A5D4A)),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBrandSection() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Top Brands',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'View All',
                    style: TextStyle(color: Color(0xFF0A5D4A)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: brands.length,
              itemBuilder: (context, index) {
                final brand = brands[index];
                final isSelected = _selectedBrand == brand['name'];

                return GestureDetector(
                  onTap: () => _onBrandSelected(brand['name']!),
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF0A5D4A)
                                : const Color(0xFFF7F8FA),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF0A5D4A)
                                  : const Color(0xFFE5E7EB),
                            ),
                          ),
                          child: brand['name'] == 'All'
                              ? Icon(
                                  Icons.apps,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF6B7280),
                                  size: 24,
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Image.asset(
                                    brand['image']!,
                                    color: isSelected ? Colors.white : null,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.directions_car,
                                        color: isSelected
                                            ? Colors.white
                                            : const Color(0xFF6B7280),
                                      );
                                    },
                                  ),
                                ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          brand['name']!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected
                                ? const Color(0xFF0A5D4A)
                                : const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'View All',
              style: TextStyle(color: Color(0xFF0A5D4A)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A5D4A)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_car_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No cars found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarsList(List<Car> cars) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: cars.length,
      itemBuilder: (context, index) {
        final car = cars[index];
        return GestureDetector(
          onTap: () => _showCarImages(car),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        color: const Color(0xFFF7F8FA),
                        child: car.photos.isNotEmpty
                            ? Image.asset(
                                'assets/${car.photos[0]}',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.directions_car,
                                    size: 64,
                                    color: Color(0xFF9CA3AF),
                                  );
                                },
                              )
                            : const Icon(
                                Icons.directions_car,
                                size: 64,
                                color: Color(0xFF9CA3AF),
                              ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.favorite_border,
                          color: Color(0xFF6B7280),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${car.make} ${car.model}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Available Now',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0FDF4),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.person,
                                  size: 14,
                                  color: Color(0xFF16A34A),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '4 Seats',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF16A34A),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0FDF4),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.local_gas_station,
                                  size: 14,
                                  color: Color(0xFF16A34A),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'ETB ${car.pricePerDay}/Day',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF16A34A),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CarImageGallery extends StatefulWidget {
  final Car car;

  const CarImageGallery({super.key, required this.car});

  @override
  _CarImageGalleryState createState() => _CarImageGalleryState();
}

class _CarImageGalleryState extends State<CarImageGallery> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.car.make} ${widget.car.model}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentImageIndex = index;
                    });
                  },
                  itemCount: widget.car.photos.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xFFF7F8FA),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/${widget.car.photos[index]}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.directions_car,
                                size: 64,
                                color: Color(0xFF9CA3AF),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
                if (widget.car.photos.length > 1)
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.car.photos.asMap().entries.map((entry) {
                        return Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentImageIndex == entry.key
                                ? const Color(0xFF0A5D4A)
                                : Colors.white.withOpacity(0.5),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        widget.car.description ??
                            'This ${widget.car.make} ${widget.car.model} is a premium vehicle offering excellent comfort, safety, and performance. Perfect for both city driving and long trips. Features include modern amenities, fuel efficiency, and reliable performance.',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Price per day',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                            Text(
                              'ETB ${widget.car.pricePerDay}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0A5D4A),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle booking
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A5D4A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Book Now',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
