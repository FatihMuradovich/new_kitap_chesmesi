part of 'banner_cubit.dart';


abstract class BannerState extends Equatable {
  const BannerState();

  @override
  List<Object> get props => [];
}

class BannerInitial extends BannerState {}

class BannerLoading extends BannerState {}

class BannerLoaded extends BannerState {
  final List<BannerModel> images;

  const BannerLoaded({required this.images});

  @override
  List<Object> get props => [images];
}

class BannerError extends BannerState {
  final String message;

  const BannerError({required this.message});

  @override
  List<Object> get props => [message];
}
