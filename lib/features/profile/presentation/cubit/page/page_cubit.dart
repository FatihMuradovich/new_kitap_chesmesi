import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/profile/domain/repository/page_repository.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/page/page_state.dart';

class PageCubit extends Cubit<PageState> {
  final PageRepository pageRepository;
  String? _lastLocaleCode;

  PageCubit({required this.pageRepository}) : super(PageInitial());

  Future<void> fetchPageContent({
    bool force = false,
    String? localeCode,
  }) async {
    // Aynı oturum içinde, aynı dil için içerik zaten yüklüyse tekrar çağırma
    if (!force &&
        state is PageLoaded &&
        _lastLocaleCode != null &&
        _lastLocaleCode == localeCode) {
      return;
    }
    try {
      log('PageCubit: fetchPageContent başlatıldı (locale: $localeCode)');
      emit(PageLoading());

      final pageContent = await pageRepository.getPageContent();
      log('PageCubit: Sayfa içeriği başarıyla alındı');
      _lastLocaleCode = localeCode;

      emit(PageLoaded(pageContent));
    } catch (e) {
      log('PageCubit: Hata oluştu: $e');
      log('PageCubit: Hata tipi: ${e.runtimeType}');
      emit(PageError(e.toString()));
    }
  }

  /// About Us içeriğini döndürür
  String getAboutUsContent() {
    final currentState = state;
    if (currentState is PageLoaded) {
      return currentState.pageModel.aboutUs;
    }
    return '';
  }

  /// Terms of Use içeriğini döndürür
  String getTermsOfUseContent() {
    final currentState = state;
    if (currentState is PageLoaded) {
      return currentState.pageModel.termsOfUse;
    }
    return '';
  }
}
