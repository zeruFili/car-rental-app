import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/api_endpoints.dart';
import 'package:get/get.dart';

class MastersManufacturingHomePage extends StatefulWidget {
  const MastersManufacturingHomePage({super.key});

  @override
  State<MastersManufacturingHomePage> createState() =>
      _MastersManufacturingHomePageState();
}

class _MastersManufacturingHomePageState
    extends State<MastersManufacturingHomePage> {
  bool isDarkMode = false;
  int currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0A5D4A) : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildNavigationBar(isDesktop),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                children: [
                  _buildHomePage(isDesktop),
                  _buildLeadershipPage(isDesktop),
                  _buildFeaturesPage(isDesktop),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isDesktop
          ? null
          : BottomNavigationBar(
              currentIndex: currentPage,
              onTap: (index) {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              selectedItemColor: const Color(0xFF0A5D4A),
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Leadership'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.grid_view), label: 'Features'),
              ],
            ),
    );
  }

  Widget _buildNavigationBar(bool isDesktop) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF0A5D4A) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF0A5D4A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_graph, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Text(
                  'MASTERSFACTURING',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: isDesktop ? 16 : 12,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          if (isDesktop) ...[
            _buildNavItem('Home', 0),
            _buildNavItem('About', 1),
            _buildNavItem('Team', 2),
            _buildNavItem('Blog', 3),
            _buildNavItem('Contact', 4),
          ],
          const SizedBox(width: 16),
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: isDarkMode ? Colors.white : const Color(0xFF0A5D4A)),
            onPressed: () {
              setState(() {
                isDarkMode = !isDarkMode;
              });
            },
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: () {
              Get.toNamed(ApiEndPoints.loginEmail); // Navigate to login page
            },
            style: OutlinedButton.styleFrom(
              foregroundColor:
                  isDarkMode ? Colors.white : const Color(0xFF0A5D4A),
              side: BorderSide(
                color: isDarkMode ? Colors.white : const Color(0xFF0A5D4A),
              ),
            ),
            child: const Text('Sign In'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              Get.toNamed(
                  ApiEndPoints.registerEmail); // Navigate to register page
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A5D4A),
              foregroundColor: Colors.white,
            ),
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String title, int index) {
    return TextButton(
      onPressed: () {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      style: TextButton.styleFrom(
        foregroundColor: isDarkMode ? Colors.white : const Color(0xFF0A5D4A),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontWeight:
              currentPage == index ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildHomePage(bool isDesktop) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Text(
              'Empowering African Innovators to Transform Markets with AI for a Lasting Global Legacy',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isDesktop ? 40 : 28,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : const Color(0xFF0A5D4A),
                height: 1.2,
              ),
            ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3, end: 0),
            const SizedBox(height: 20),
            Text(
              'Harnessing AI to empower innovators and transform global.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isDesktop ? 18 : 16,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 800.ms)
                .slideY(begin: 0.3, end: 0),
            const SizedBox(height: 60),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                _buildFeatureCard(
                  'Music Production',
                  'Gregory John Brown',
                  '"Let us bring your music to life with our expert production team. From mixing to mastering, we\'ve got you covered."',
                  Icons.music_note,
                  0,
                ),
                _buildFeatureCard(
                  'Game Production',
                  'Mikias G',
                  '"Immerse players from design to deployment, in captivating worlds with our innovative game production."',
                  Icons.sports_esports,
                  1,
                ),
                _buildFeatureCard(
                  'Artificial Intelligence',
                  'Natnael Melese',
                  '"Enforcing AI tools by making next generation AI. From development to implementation, we\'re leading the tech revolution."',
                  Icons.psychology,
                  2,
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A5D4A),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Join our community'),
            )
                .animate()
                .fadeIn(delay: 800.ms, duration: 800.ms)
                .scale(begin: const Offset(0.9, 0.9)),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor:
                    isDarkMode ? Colors.white : const Color(0xFF0A5D4A),
                side: BorderSide(
                  color: isDarkMode ? Colors.white : const Color(0xFF0A5D4A),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
              child: const Text('Donate'),
            ).animate().fadeIn(delay: 1000.ms, duration: 800.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(String title, String author, String description,
      IconData icon, int index) {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black12 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: isDarkMode ? Colors.white70 : Colors.black87,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF0A5D4A),
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    author,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: (400 + (index * 200)).ms, duration: 800.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildLeadershipPage(bool isDesktop) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Text(
              'Led by Gregory John Brown',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isDesktop ? 40 : 28,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : const Color(0xFF0A5D4A),
                height: 1.2,
              ),
            ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3, end: 0),
            const SizedBox(height: 20),
            Text(
              'MASTERSFACTURING harnesses AI to empower innovators and transform global markets through strategic innovation.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isDesktop ? 18 : 16,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 800.ms)
                .slideY(begin: 0.3, end: 0),
            const SizedBox(height: 40),
            Container(
              width: isDesktop ? 600 : double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.black12 : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: const Color(0xFF0A5D4A),
                    child: Text(
                      'GJB',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 800.ms)
                      .scale(begin: const Offset(0.8, 0.8)),
                  const SizedBox(height: 20),
                  Text(
                    'Gregory John Brown',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Founder & CEO',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Under the visionary leadership of Gregory John Brown, MASTERSFACTURING is not just a business; it\'s a long-term mission to redefine global markets, culture, and economy. With a patent-pending, groundbreaking music catalytic finance ecosystem, MASTERSFACTURING is designed to revolutionize how young innovators access resources and build sustainable businesses.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(FontAwesomeIcons.globe),
                        color: const Color(0xFF0A5D4A),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(FontAwesomeIcons.facebook),
                        color: const Color(0xFF0A5D4A),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(FontAwesomeIcons.twitter),
                        color: const Color(0xFF0A5D4A),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(FontAwesomeIcons.linkedin),
                        color: const Color(0xFF0A5D4A),
                      ),
                    ],
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(delay: 600.ms, duration: 800.ms)
                .slideY(begin: 0.2, end: 0),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A5D4A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                  ),
                  child: const Text('Donate'),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        isDarkMode ? Colors.white : const Color(0xFF0A5D4A),
                    side: BorderSide(
                      color:
                          isDarkMode ? Colors.white : const Color(0xFF0A5D4A),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                  ),
                  icon: const Icon(Icons.chat),
                  label: const Text('Join our community'),
                ),
              ],
            ).animate().fadeIn(delay: 1000.ms, duration: 800.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesPage(bool isDesktop) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Text(
              'Main Features Of Play',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isDesktop ? 40 : 28,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : const Color(0xFF0A5D4A),
                height: 1.2,
              ),
            ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3, end: 0),
            const SizedBox(height: 20),
            Text(
              'By harnessing AI, the platform empowers young innovators, creating a groundbreaking music finance ecosystem. It strategically positions Ethiopia to redefine global economic landscapes.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isDesktop ? 18 : 16,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 800.ms)
                .slideY(begin: 0.3, end: 0),
            const SizedBox(height: 60),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                _buildFeatureGridItem(
                  'Building a Legacy for the Next 1,000 Years',
                  'Under the visionary leadership of Gregory John Brown, MASTERSFACTURING is not just a business; it\'s a long-term mission to redefine global markets, culture, and economy.',
                  Icons.card_giftcard,
                  0,
                ),
                _buildFeatureGridItem(
                  'Harnessing AI for Strategic Innovation and Global Impact',
                  'At the heart of MASTERSFACTURING lies an AI Production Factory that is set to revolutionize industries by 2025, surpassing even the giants like Alibaba and Google.',
                  Icons.auto_awesome,
                  1,
                ),
                _buildFeatureGridItem(
                  'Empowering the Next Generation of Innovators',
                  'Gregory John Brown\'s mission is deeply rooted in empowering the youth of Ethiopia and the global diaspora. MASTERSFACTURING is designed to be a revolutionary platform that nurtures young talents.',
                  Icons.people,
                  2,
                ),
                _buildFeatureGridItem(
                  'Transforming Global Markets with Strategic Precision',
                  'MASTERSFACTURING is a globally strategic initiative that leverages Ethiopia\'s unique position to impact the world economy. Mr. Brown\'s strategic vision includes partnerships with global entities.',
                  Icons.grid_view,
                  3,
                ),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (currentPage > 0) {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  icon: const Icon(Icons.arrow_back),
                  style: IconButton.styleFrom(
                    backgroundColor: isDarkMode
                        ? Colors.white24
                        : Colors.black.withOpacity(0.05),
                    foregroundColor:
                        isDarkMode ? Colors.white : const Color(0xFF0A5D4A),
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () {
                    if (currentPage < 2) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  icon: const Icon(Icons.arrow_forward),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF0A5D4A),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 1000.ms, duration: 800.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureGridItem(
      String title, String description, IconData icon, int index) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black12 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0A5D4A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.white70 : Colors.black87,
              height: 1.6,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: (400 + (index * 200)).ms, duration: 800.ms)
        .slideY(begin: 0.2, end: 0);
  }
}
