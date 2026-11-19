// ignore: file_names
import 'package:equatable/equatable.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/etrap_model.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/welayat_model.dart';

abstract class WelayatAndEtrapState extends Equatable {
  const WelayatAndEtrapState();

  @override
  List<Object> get props => [];
}

final class WelayatAndEtrapInitial extends WelayatAndEtrapState {}

final class WelayatAndEtrapLoading extends WelayatAndEtrapState {}

final class WelayatAndEtrapLoaded extends WelayatAndEtrapState {
  final List<WelayatModel> welayats;
  final List<EtrapModel> etraps;
  final bool etrapsHasMore;
  final int etrapsCurrentPage;
  final bool etrapsLoadingMore;

  const WelayatAndEtrapLoaded({
    required this.welayats,
    required this.etraps,
    this.etrapsHasMore = false,
    this.etrapsCurrentPage = 1,
    this.etrapsLoadingMore = false,
  });

  @override
  List<Object> get props =>
      [welayats, etraps, etrapsHasMore, etrapsCurrentPage, etrapsLoadingMore];
}

final class WelayatAndEtrapError extends WelayatAndEtrapState {
  final String message;
  const WelayatAndEtrapError({required this.message});
}