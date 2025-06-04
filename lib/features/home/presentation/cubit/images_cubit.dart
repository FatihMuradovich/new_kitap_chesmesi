import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/home/data_source/banner_data_source.dart';
part 'images_state.dart';

class ImagesCubit extends Cubit<ImageState> {
  final ImagesDataSource dataSource;

  ImagesCubit({required this.dataSource}) : super(ImageInitial());

  Future<void> fetchImages() async {
    emit(ImageLoading());
    try {
      final images = await dataSource.getImages();
      emit(ImageLoaded(images: images));
    } catch (e) {
      emit(ImageError(message: e.toString()));
    }
  }
}