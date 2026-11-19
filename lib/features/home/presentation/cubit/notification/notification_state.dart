import 'package:new_kitap_chesmesi/features/home/domain/model/notification_model.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notifications;

  NotificationLoaded({required this.notifications});
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError({required this.message});
}

class NotificationMarkedAsRead extends NotificationState {}

class NotificationDeleted extends NotificationState {}

class NotificationActionLoading extends NotificationState {
  final int notificationId;

  NotificationActionLoading({required this.notificationId});
}
