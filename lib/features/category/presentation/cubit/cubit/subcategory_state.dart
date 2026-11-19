
import 'package:equatable/equatable.dart';
import 'package:new_kitap_chesmesi/features/category/domain/model/subcategory_model.dart';


abstract class SubcategoryState extends Equatable {
  const SubcategoryState();

  @override
  List<Object> get props => [];
}

class SubcategoryInitial extends SubcategoryState {}

class SubcategoryLoading extends SubcategoryState {}

class SubcategoryLoaded extends SubcategoryState {
  final List<SubcategoryModel> subcategories;

  const SubcategoryLoaded({required this.subcategories});

  @override
  List<Object> get props => [subcategories];
}

class SubcategoryError extends SubcategoryState {
  final String message;

  const SubcategoryError({required this.message});

  @override
  List<Object> get props => [message];
}
