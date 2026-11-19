import 'package:equatable/equatable.dart';
import 'package:new_kitap_chesmesi/features/special_order/domain/model/special_order_model.dart';

abstract class SpecialOrdersState extends Equatable {
  const SpecialOrdersState();

  @override
  List<Object?> get props => [];
}

class SpecialOrdersInitial extends SpecialOrdersState {}

class SpecialOrdersLoading extends SpecialOrdersState {}

class SpecialOrdersLoaded extends SpecialOrdersState {
  final List<SpecialOrderRequestData> requests;

  /// Toplam kayıt sayısı — API'nin `count` alanı.
  final int count;
  final int currentPage;
  final bool hasMore;

  const SpecialOrdersLoaded({
    required this.requests,
    required this.count,
    this.currentPage = 1,
    this.hasMore = false,
  });

  @override
  List<Object?> get props => [requests, count, currentPage, hasMore];
}

/// Sonraki sayfa çekilirken — mevcut liste ekranda kalır.
class SpecialOrdersLoadingMore extends SpecialOrdersState {
  final List<SpecialOrderRequestData> currentRequests;

  const SpecialOrdersLoadingMore({required this.currentRequests});

  @override
  List<Object?> get props => [currentRequests];
}

class SpecialOrdersError extends SpecialOrdersState {
  final int? statusCode;

  const SpecialOrdersError({this.statusCode});

  @override
  List<Object?> get props => [statusCode];
}
