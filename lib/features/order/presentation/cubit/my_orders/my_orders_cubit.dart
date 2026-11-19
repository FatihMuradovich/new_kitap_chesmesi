import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/order_api_exception.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/order_model.dart';
import 'package:new_kitap_chesmesi/features/order/domain/repository/order_repository.dart';
import 'my_orders_state.dart';

class MyOrdersCubit extends Cubit<MyOrdersState> {
  static const int pageSize = 20;

  final OrderRepository orderRepository;

  MyOrdersCubit({required this.orderRepository}) : super(MyOrdersInitial());

  OrderStatus? _statusFilter;

  Future<void> loadMyOrders({OrderStatus? status}) async {
    _statusFilter = status;
    emit(MyOrdersLoading());
    await _fetchFirstPage();
  }

  /// Aşağı çekip yenile — `Loading` emit etmez ki liste titremesin.
  Future<void> refresh() => _fetchFirstPage();

  Future<void> _fetchFirstPage() async {
    try {
      final result = await orderRepository.getMyOrders(
        page: 1,
        limit: pageSize,
        status: _statusFilter,
      );
      emit(MyOrdersLoaded(
        orders: result.orders,
        count: result.count,
        currentPage: 1,
        hasMore: result.orders.length < result.count,
      ));
    } catch (e) {
      emit(MyOrdersError(statusCode: _statusCodeOf(e)));
    }
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! MyOrdersLoaded) return;
    if (!currentState.hasMore) return;

    emit(MyOrdersLoadingMore(currentOrders: currentState.orders));

    final nextPage = currentState.currentPage + 1;
    try {
      final result = await orderRepository.getMyOrders(
        page: nextPage,
        limit: pageSize,
        status: _statusFilter,
      );
      final allOrders = [...currentState.orders, ...result.orders];
      emit(MyOrdersLoaded(
        orders: allOrders,
        count: result.count,
        currentPage: nextPage,
        // Boş sayfa geldiyse döngüye girme.
        hasMore: result.orders.isNotEmpty && allOrders.length < result.count,
      ));
    } catch (_) {
      // Sayfa ekleme hatası ekranı bozmasın — önceki state'e dön.
      emit(currentState);
    }
  }

  int? _statusCodeOf(Object e) =>
      e is OrderApiException ? e.statusCode : null;
}
