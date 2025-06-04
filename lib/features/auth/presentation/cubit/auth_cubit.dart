// auth_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/user_model.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/repository/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;
  UserModel? user;
  AuthCubit({required this.repository}) : super(AuthInitial());

  Future<void> register({
    required String name,
    required String surname,
    required String birthday,
    required String phone,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
       user = await repository.register(
        name: name,
        surname: surname,
        birthday: birthday,
        phone: phone,
        password: password,
      );
      emit(AuthSuccess(user as UserModel));
    } catch (e) {
      print(e);
      emit(AuthError(e.toString()));
    }
  }

  Future<void> login({required String phone, required String password}) async {
    emit(AuthLoading());
    try {
       user = await repository.login(phone: phone, password: password);
      emit(AuthSuccess(user as UserModel));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
