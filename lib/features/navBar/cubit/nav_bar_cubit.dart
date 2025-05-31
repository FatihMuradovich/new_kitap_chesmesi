
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'nav_bar_state.dart';

class NavBarCubit extends Cubit<bool> {
  NavBarCubit() : super(true);

  void showNavBar() => emit(true); // NavBar'ı göster
  void hideNavBar() => emit(false); // NavBar'ı gizle
}
