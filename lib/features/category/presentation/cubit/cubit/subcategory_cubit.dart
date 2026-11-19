
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/category/domain/repository/subcateogry_repository.dart';
import 'package:new_kitap_chesmesi/features/category/presentation/cubit/cubit/subcategory_state.dart';

class SubcategoryCubit extends Cubit<SubcategoryState> {
  SubcateogryRepository repository;
  SubcategoryCubit(
    this.repository,
  ) : super(SubcategoryInitial());

  Future<void> fetchSubCategories(String id) async {
    emit(SubcategoryLoading());
    try {
      final subcategories = await repository.fetchSubcategory(id);
      emit(SubcategoryLoaded(subcategories: subcategories));
    } catch (e) {
      emit(SubcategoryError(message: e.toString()));
    }
  }
}
