import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/order_api_exception.dart';
import 'package:new_kitap_chesmesi/features/special_order/domain/model/special_order_model.dart';
import 'package:new_kitap_chesmesi/features/special_order/domain/repository/special_order_repository.dart';
import 'special_orders_state.dart';

/// "Taleplerim" listesi — `MyOrdersCubit` ile aynı sayfalama sözleşmesi.
class SpecialOrdersCubit extends Cubit<SpecialOrdersState> {
  static const int pageSize = 20;

  final SpecialOrderRepository specialOrderRepository;

  SpecialOrdersCubit({required this.specialOrderRepository})
      : super(SpecialOrdersInitial());

  SpecialOrderStatus? _statusFilter;

  Future<void> loadMyRequests({SpecialOrderStatus? status}) async {
    _statusFilter = status;
    emit(SpecialOrdersLoading());
    await _fetchFirstPage();
  }

  /// Aşağı çekip yenile — `Loading` emit etmez ki liste titremesin.
  Future<void> refresh() => _fetchFirstPage();

  Future<void> _fetchFirstPage() async {
    try {
      final result = await specialOrderRepository.getMyRequests(
        page: 1,
        limit: pageSize,
        status: _statusFilter,
      );
      emit(SpecialOrdersLoaded(
        requests: result.requests,
        count: result.count,
        currentPage: 1,
        hasMore: result.requests.length < result.count,
      ));
    } catch (e) {
      emit(SpecialOrdersError(statusCode: _statusCodeOf(e)));
    }
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! SpecialOrdersLoaded) return;
    if (!currentState.hasMore) return;

    emit(SpecialOrdersLoadingMore(currentRequests: currentState.requests));

    final nextPage = currentState.currentPage + 1;
    try {
      final result = await specialOrderRepository.getMyRequests(
        page: nextPage,
        limit: pageSize,
        status: _statusFilter,
      );
      final allRequests = [...currentState.requests, ...result.requests];
      emit(SpecialOrdersLoaded(
        requests: allRequests,
        count: result.count,
        currentPage: nextPage,
        // Boş sayfa geldiyse döngüye girme.
        hasMore:
            result.requests.isNotEmpty && allRequests.length < result.count,
      ));
    } catch (_) {
      // Sayfa ekleme hatası ekranı bozmasın — önceki state'e dön.
      emit(currentState);
    }
  }

  int? _statusCodeOf(Object e) => e is OrderApiException ? e.statusCode : null;
}
