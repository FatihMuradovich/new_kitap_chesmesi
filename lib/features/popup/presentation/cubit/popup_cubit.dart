import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/popup/domain/repositories/popup_repository.dart';
import 'package:new_kitap_chesmesi/features/popup/presentation/cubit/popup_state.dart';

class PopupCubit extends Cubit<PopupState> {
  final PopupRepository repository;

  PopupCubit({required this.repository}) : super(PopupInitial());

  Future<void> fetchLatestPopup() async {
    log('🚀 Fetching latest popup...', name: 'PopupCubit');
    emit(PopupLoading());
    try {
      final popup = await repository.getLatestPopup();
      
      log('📦 Popup received: ${popup?.title}, active: ${popup?.active}', name: 'PopupCubit');
      
      if (popup != null && popup.active) {
        log('✅ Emitting PopupLoaded state', name: 'PopupCubit');
        emit(PopupLoaded(popup: popup));
      } else {
        log('⚠️ Popup is null or inactive, emitting PopupEmpty', name: 'PopupCubit');
        emit(PopupEmpty());
      }
    } catch (e) {
      log('❌ Error: $e', name: 'PopupCubit');
      emit(PopupError(message: e.toString()));
    }
  }

  void dismissPopup() {
    log('🚫 Dismissing popup', name: 'PopupCubit');
    emit(PopupEmpty());
  }
}

