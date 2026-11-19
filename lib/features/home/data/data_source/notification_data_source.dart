import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/home/domain/model/notification_model.dart';

class NotificationDataSource {
  final DioClient dioClient;

  NotificationDataSource({required this.dioClient});

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await dioClient.dio.get('/user/notifications');

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;

        if (responseData['success'] == true) {
          final List data = responseData['data'] as List;
          return data.map((e) => NotificationModel.fromMap(e)).toList();
        } else {
          throw Exception('API returned unsuccessful response');
        }
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      throw Exception('Error while fetching notifications: $e');
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      final response = await dioClient.dio.patch(
        '/user/notifications/$notificationId/read',
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to mark notification as read');
      }
    } catch (e) {
      throw Exception('Error while marking notification as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final response = await dioClient.dio.patch(
        '/user/notifications/read-all',
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to mark all notifications as read');
      }
    } catch (e) {
      throw Exception('Error while marking all notifications as read: $e');
    }
  }

  Future<void> deleteNotification(int notificationId) async {
    try {
      final response = await dioClient.dio.delete(
        '/user/notifications/$notificationId',
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete notification');
      }
    } catch (e) {
      throw Exception('Error while deleting notification: $e');
    }
  }
}

