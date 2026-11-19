import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/home/domain/repository/notification_repository.dart';
import 'package:new_kitap_chesmesi/features/home/presentation/cubit/notification/notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository notificationRepository;

  NotificationCubit({required this.notificationRepository})
      : super(NotificationInitial());

  Future<void> fetchNotifications() async {
    try {
      emit(NotificationLoading());
      final notifications = await notificationRepository.getNotifications();
      emit(NotificationLoaded(notifications: notifications));
    } catch (e) {
      emit(NotificationError(message: e.toString()));
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      emit(NotificationActionLoading(notificationId: notificationId));
      await notificationRepository.markAsRead(notificationId);
      emit(NotificationMarkedAsRead());
      // Refresh notifications after marking as read
      await fetchNotifications();
    } catch (e) {
      emit(NotificationError(message: e.toString()));
      // Reload current notifications on error
      await fetchNotifications();
    }
  }

  Future<void> markAllAsRead() async {
    try {
      emit(NotificationLoading());
      await notificationRepository.markAllAsRead();
      emit(NotificationMarkedAsRead());
      // Refresh notifications after marking all as read
      await fetchNotifications();
    } catch (e) {
      emit(NotificationError(message: e.toString()));
      // Reload current notifications on error
      await fetchNotifications();
    }
  }

  Future<void> deleteNotification(int notificationId) async {
    try {
      emit(NotificationActionLoading(notificationId: notificationId));
      await notificationRepository.deleteNotification(notificationId);
      emit(NotificationDeleted());
      // Refresh notifications after deletion
      await fetchNotifications();
    } catch (e) {
      emit(NotificationError(message: e.toString()));
      // Reload current notifications on error
      await fetchNotifications();
    }
  }
}
