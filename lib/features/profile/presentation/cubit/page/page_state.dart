import 'package:new_kitap_chesmesi/features/profile/domain/model/page_model.dart';

abstract class PageState {}

class PageInitial extends PageState {}

class PageLoading extends PageState {}

class PageLoaded extends PageState {
  final PageModel pageModel;

  PageLoaded(this.pageModel);
}

class PageError extends PageState {
  final String message;

  PageError(this.message);
}
