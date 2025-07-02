import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3748)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 6, // Sample data
        itemBuilder: (context, index) {
          final isUnread = index < 3;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isUnread ? const Color(0xFFF0FDF4) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isUnread
                    ? const Color(0xFF0A5D4A).withOpacity(0.2)
                    : const Color(0xFFE5E7EB),
              ),
            ),
            child: ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF0A5D4A).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  _getNotificationIcon(index),
                  color: const Color(0xFF0A5D4A),
                ),
              ),
              title: Text(
                _getNotificationTitle(index),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isUnread ? FontWeight.w600 : FontWeight.w500,
                  color: const Color(0xFF2D3748),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    _getNotificationMessage(index),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getNotificationTime(index),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
              trailing: isUnread
                  ? Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0A5D4A),
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
              contentPadding: const EdgeInsets.all(16),
            ),
          );
        },
      ),
    );
  }

  IconData _getNotificationIcon(int index) {
    switch (index % 3) {
      case 0:
        return Icons.car_rental;
      case 1:
        return Icons.payment;
      case 2:
        return Icons.star;
      default:
        return Icons.notifications;
    }
  }

  String _getNotificationTitle(int index) {
    switch (index % 3) {
      case 0:
        return 'New Rental Request';
      case 1:
        return 'Payment Received';
      case 2:
        return 'New Review';
      default:
        return 'Notification';
    }
  }

  String _getNotificationMessage(int index) {
    switch (index % 3) {
      case 0:
        return 'John Doe wants to rent your BMW X5 for 3 days';
      case 1:
        return 'You received ETB 4500 for Toyota Camry rental';
      case 2:
        return 'Sarah left a 5-star review for your Mercedes C-Class';
      default:
        return 'You have a new notification';
    }
  }

  String _getNotificationTime(int index) {
    switch (index) {
      case 0:
        return '2 minutes ago';
      case 1:
        return '1 hour ago';
      case 2:
        return '3 hours ago';
      case 3:
        return '1 day ago';
      case 4:
        return '2 days ago';
      case 5:
        return '1 week ago';
      default:
        return 'Just now';
    }
  }
}
