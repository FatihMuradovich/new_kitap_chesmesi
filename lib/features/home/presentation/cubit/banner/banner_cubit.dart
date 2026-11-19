import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/home/data/data_source/banner_data_source.dart';
import 'package:new_kitap_chesmesi/features/home/domain/model/banner_model.dart';
part 'banner_state.dart';

class BannerCubit extends Cubit<BannerState> {
  final BannerDataSource bannerDataSource;

  BannerCubit({required this.bannerDataSource}) : super(BannerInitial());

  Future<void> fetchBannerImages() async {
    emit(BannerLoading());
    try {
      final images = await bannerDataSource.getBannerImages();
      emit(BannerLoaded(images: images));
    } catch (e) {
      emit(BannerError(message: e.toString()));
    }
  }
}
