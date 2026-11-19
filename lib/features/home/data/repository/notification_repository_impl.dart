import 'package:new_kitap_chesmesi/features/home/data/data_source/notification_data_source.dart';
import 'package:new_kitap_chesmesi/features/home/domain/model/notification_model.dart';
import 'package:new_kitap_chesmesi/features/home/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationDataSource notificationDataSource;

  NotificationRepositoryImpl({required this.notificationDataSource});

  @override
  Future<List<NotificationModel>> getNotifications() {
    return notificationDataSource.getNotifications();
  }

  @override
  Future<void> markAsRead(int notificationId) {
    return notificationDataSource.markAsRead(notificationId);
  }

  @override
  Future<void> markAllAsRead() {
    return notificationDataSource.markAllAsRead();
  }

  @override
  Future<void> deleteNotification(int notificationId) {
    return notificationDataSource.deleteNotification(notificationId);
  }
}

