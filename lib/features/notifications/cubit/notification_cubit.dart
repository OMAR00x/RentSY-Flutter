import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/notification_model.dart';
import '../repository/notification_repository.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notifications;
  NotificationLoaded(this.notifications);
}

class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
}

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository repository;

  NotificationCubit(this.repository) : super(NotificationInitial());

  Future<void> loadNotifications() async {
    emit(NotificationLoading());
    try {
      final notifications = await repository.getNotifications();
      emit(NotificationLoaded(notifications));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await repository.markAsRead(id);
      await loadNotifications();
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await repository.markAllAsRead();
      await loadNotifications();
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}