import 'package:equatable/equatable.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/order_model.dart';

abstract class MyOrdersState extends Equatable {
  const MyOrdersState();

  @override
  List<Object?> get props => [];
}

class MyOrdersInitial extends MyOrdersState {}

class MyOrdersLoading extends MyOrdersState {}

class MyOrdersLoaded extends MyOrdersState {
  final List<OrderData> orders;

  /// Toplam kayıt sayısı — API'nin `count` alanı.
  final int count;
  final int currentPage;
  final bool hasMore;

  const MyOrdersLoaded({
    required this.orders,
    required this.count,
    this.currentPage = 1,
    this.hasMore = false,
  });

  MyOrdersLoaded copyWith({
    List<OrderData>? orders,
    int? count,
    int? currentPage,
    bool? hasMore,
  }) {
    return MyOrdersLoaded(
      orders: orders ?? this.orders,
      count: count ?? this.count,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [orders, count, currentPage, hasMore];
}

/// Sonraki sayfa çekilirken — mevcut liste ekranda kalır, altta yükleme gösterilir.
class MyOrdersLoadingMore extends MyOrdersState {
  final List<OrderData> currentOrders;

  const MyOrdersLoadingMore({required this.currentOrders});

  @override
  List<Object?> get props => [currentOrders];
}

class MyOrdersError extends MyOrdersState {
  final int? statusCode;

  const MyOrdersError({this.statusCode});

  @override
  List<Object?> get props => [statusCode];
}
