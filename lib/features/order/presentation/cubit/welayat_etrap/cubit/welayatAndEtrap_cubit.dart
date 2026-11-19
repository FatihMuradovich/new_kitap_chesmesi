import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/welayat_etrap/cubit/welayatAndEtrap_state.dart';
import 'package:new_kitap_chesmesi/features/order/domain/repository/welayat_repository.dart';
import 'package:new_kitap_chesmesi/features/order/domain/repository/etrap_repository.dart';

class WelayatAndEtrapCubit extends Cubit<WelayatAndEtrapState> {
  static const int _etrapsPageSize = 15;

  final WelayatRepository welayatRepository;
  final EtrapRepository etrapRepository;
  WelayatAndEtrapCubit(
      {required this.welayatRepository, required this.etrapRepository})
      : super(WelayatAndEtrapInitial());

  Future<void> getWelayats() async {
    try {
      emit(WelayatAndEtrapLoading());
      final welayats = await welayatRepository.getWelayats();
      emit(WelayatAndEtrapLoaded(welayats: welayats, etraps: []));
    } catch (e) {
      emit(WelayatAndEtrapError(message: e.toString()));
    }
  }

  Future<void> getEtraps() async {
    try {
      emit(WelayatAndEtrapLoading());
      final etraps = await etrapRepository.getEtraps();
      emit(WelayatAndEtrapLoaded(welayats: [], etraps: etraps));
    } catch (e) {
      emit(WelayatAndEtrapError(message: e.toString()));
    }
  }

  Future<void> getEtrapsByWelayatId(int welayatId) async {
    try {
      emit(WelayatAndEtrapLoading());
      final etraps = await etrapRepository.getEtrapsByWelayatId(
        welayatId,
        page: 1,
        limit: _etrapsPageSize,
      );
      emit(WelayatAndEtrapLoaded(
        welayats: [],
        etraps: etraps,
        etrapsHasMore: etraps.length >= _etrapsPageSize,
        etrapsCurrentPage: 1,
      ));
    } catch (e) {
      emit(WelayatAndEtrapError(message: e.toString()));
    }
  }

  Future<void> loadMoreEtrapsByWelayatId(int welayatId) async {
    final currentState = state;
    if (currentState is! WelayatAndEtrapLoaded) return;
    if (!currentState.etrapsHasMore || currentState.etrapsLoadingMore) return;

    emit(WelayatAndEtrapLoaded(
      welayats: currentState.welayats,
      etraps: currentState.etraps,
      etrapsHasMore: currentState.etrapsHasMore,
      etrapsCurrentPage: currentState.etrapsCurrentPage,
      etrapsLoadingMore: true,
    ));

    try {
      final nextPage = currentState.etrapsCurrentPage + 1;
      final newEtraps = await etrapRepository.getEtrapsByWelayatId(
        welayatId,
        page: nextPage,
        limit: _etrapsPageSize,
      );
      final allEtraps = [...currentState.etraps, ...newEtraps];
      emit(WelayatAndEtrapLoaded(
        welayats: currentState.welayats,
        etraps: allEtraps,
        etrapsHasMore: newEtraps.length >= _etrapsPageSize,
        etrapsCurrentPage: nextPage,
        etrapsLoadingMore: false,
      ));
    } catch (_) {
      emit(WelayatAndEtrapLoaded(
        welayats: currentState.welayats,
        etraps: currentState.etraps,
        etrapsHasMore: currentState.etrapsHasMore,
        etrapsCurrentPage: currentState.etrapsCurrentPage,
        etrapsLoadingMore: false,
      ));
    }
  }
}
